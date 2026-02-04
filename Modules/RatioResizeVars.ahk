;; Ratio Resize - Global Variables and Init
;; Must be loaded before other modules

global RATIO := 1.5
global g_IsResizing := false
global g_ResizingHwnd := 0
global g_OriginalWidth := 0
global g_OriginalHeight := 0
global g_ResizeEdge := ""
global g_hWinEventHook := 0
global g_WinEventProcCallback := 0
global g_CtrlWasHeld := false

; Schedule init after auto-execute completes
SetTimer, RatioResize_AutoInit, -1
