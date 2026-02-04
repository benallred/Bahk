;; Ratio Resize
;; Hold Ctrl while resizing a window to enforce a ratio (width:height)
;; Requires: RatioResizeVars.ahk loaded first

RatioResize_AutoInit:
    RatioResize_Init()
return

RatioResize_Init()
{
    global g_hWinEventHook, g_WinEventProcCallback

    ; Event constants
    EVENT_SYSTEM_MOVESIZESTART := 0x000A
    EVENT_SYSTEM_MOVESIZEEND := 0x000B
    WINEVENT_OUTOFCONTEXT := 0x0000

    ; Create callback
    g_WinEventProcCallback := RegisterCallback("RatioResize_WinEventProc")

    ; Register hook for move/size events
    g_hWinEventHook := DllCall("SetWinEventHook"
        , "UInt", EVENT_SYSTEM_MOVESIZESTART
        , "UInt", EVENT_SYSTEM_MOVESIZEEND
        , "Ptr", 0
        , "Ptr", g_WinEventProcCallback
        , "UInt", 0
        , "UInt", 0
        , "UInt", WINEVENT_OUTOFCONTEXT
        , "Ptr")

    ; Register cleanup on exit
    OnExit("RatioResize_Cleanup")
}

RatioResize_WinEventProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime)
{
    global g_IsResizing, g_ResizingHwnd, g_OriginalWidth, g_OriginalHeight, g_ResizeEdge, g_CtrlWasHeld

    ; Only handle window objects
    if (idObject != 0)
        return

    if (event = 0x000A)  ; EVENT_SYSTEM_MOVESIZESTART
    {
        ; Store initial window state
        WinGetPos, x, y, w, h, ahk_id %hwnd%
        g_ResizingHwnd := hwnd
        g_OriginalWidth := w
        g_OriginalHeight := h
        g_IsResizing := true
        g_CtrlWasHeld := GetKeyState("Ctrl", "P")

        ; Detect edge at start (cursor is on the edge now)
        g_ResizeEdge := RatioResize_DetectEdge(hwnd)

        ; Start monitoring for Ctrl key
        SetTimer, RatioResize_Monitor, 50
    }
    else if (event = 0x000B)  ; EVENT_SYSTEM_MOVESIZEEND
    {
        SetTimer, RatioResize_Monitor, Off

        ; Apply ratio if Ctrl was held at any point
        if (g_CtrlWasHeld && g_ResizeEdge != "" && g_ResizeEdge != "move")
        {
            ; Determine direction based on which dimension changed more
            WinGetPos, x, y, finalW, finalH, ahk_id %hwnd%
            deltaW := Abs(finalW - g_OriginalWidth)
            deltaH := Abs(finalH - g_OriginalHeight)

            if (deltaW > 0 || deltaH > 0)
            {
                ; Use the dimension that changed more as the driver
                if (deltaW >= deltaH)
                    direction := "horizontal"
                else
                    direction := "vertical"

                RatioResize_Apply(hwnd, direction)
            }
        }

        g_IsResizing := false
        g_ResizingHwnd := 0
        g_CtrlWasHeld := false
    }
}

RatioResize_Monitor:
    if (!g_IsResizing || !g_ResizingHwnd)
    {
        SetTimer, RatioResize_Monitor, Off
        return
    }

    ; Track if Ctrl is held at any point during resize
    if (GetKeyState("Ctrl", "P"))
        g_CtrlWasHeld := true
return

RatioResize_DetectEdge(hwnd)
{
    ; Get window rect
    WinGetPos, winX, winY, winW, winH, ahk_id %hwnd%

    ; Get cursor position
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY

    ; Edge threshold in pixels
    edgeThreshold := 16

    ; Check which edges cursor is near
    nearLeft := (mouseX >= winX - edgeThreshold && mouseX <= winX + edgeThreshold)
    nearRight := (mouseX >= winX + winW - edgeThreshold && mouseX <= winX + winW + edgeThreshold)
    nearTop := (mouseY >= winY - edgeThreshold && mouseY <= winY + edgeThreshold)
    nearBottom := (mouseY >= winY + winH - edgeThreshold && mouseY <= winY + winH + edgeThreshold)

    ; Corners and horizontal edges both use width as driver
    if ((nearLeft || nearRight) && (nearTop || nearBottom))
        return "corner"

    if (nearLeft || nearRight)
        return "horizontal"

    if (nearTop || nearBottom)
        return "vertical"

    return "move"
}

RatioResize_Apply(hwnd, direction)
{
    global RATIO

    WinGetPos, x, y, w, h, ahk_id %hwnd%

    if (direction = "horizontal" || direction = "corner")
    {
        ; Width is driver, calculate height
        newHeight := Round(w / RATIO)
        if (newHeight != h)
            WinMove, ahk_id %hwnd%, , x, y, w, newHeight
    }
    else if (direction = "vertical")
    {
        ; Height is driver, calculate width
        newWidth := Round(h * RATIO)
        if (newWidth != w)
            WinMove, ahk_id %hwnd%, , x, y, newWidth, h
    }
}

RatioResize_Cleanup()
{
    global g_hWinEventHook, g_WinEventProcCallback

    if (g_hWinEventHook)
    {
        DllCall("UnhookWinEvent", "Ptr", g_hWinEventHook)
        g_hWinEventHook := 0
    }

    if (g_WinEventProcCallback)
    {
        DllCall("GlobalFree", "Ptr", g_WinEventProcCallback)
        g_WinEventProcCallback := 0
    }
}
