#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
#Warn ; Enable every type of warning; show each warning in a message box
#SingleInstance Ignore ; Skips the dialog box and leaves the old instance running
SendMode Input ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
#Include %A_ScriptDir% ; Change the working directory used by all subsequent occurrences of #Include and FileInstall. SetWorkingDir has no effect on #Include because #Include is processed before the script begins executing.
SetTitleMatchMode 2 ; A window's title can contain WinTitle anywhere inside it to be a match

programTitle = Bahk

EnvGet, LocalAppData, LocalAppData

GroupAdd, CtrlShiftZ, OneNote
GroupAdd, CtrlShiftZ, ahk_exe winword.exe
GroupAdd, CtrlShiftZ, ahk_exe excel.exe
GroupAdd, CtrlShiftZ, ahk_exe WindowsTerminal.exe

GroupAdd, NoEmoji, ahk_exe slack.exe
GroupAdd, NoEmoji, ahk_exe Discord.exe

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Script Startup

if not A_IsAdmin
{
    Run, *RunAs "%A_ScriptFullPath%" /restart
    ExitApp
}

startupLinkFile := A_Startup "\" programTitle ".lnk"
IfNotExist, % startupLinkFile
{
    FileCreateShortcut, % A_ScriptFullPath, % startupLinkFile, % A_ScriptDir, , , % A_ScriptDir "\" programTitle ".ico"
}

Menu, Tray, Icon, Bahk.ico, , 1
TrayTip, % programTitle, Loaded

#Include Modules\Autofill.ahk
#Include Modules\CopyPaste.ahk
#Include Modules\Guid.ahk
#Include Modules\Emoji.ahk
#Include Modules\WindowManipulation.ahk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Script Shortcuts

#^+e::Edit

#^+r::
    Reload
    Sleep, 1000
    SoundPlay, *16
    TrayTip, % programTitle, Failed to reload, , 16
    return

#^+s::
    Suspend, Toggle
    if A_IsSuspended = 1
    {
        Menu, Tray, Icon, Bahk-Suspend.ico, , 1
        TrayTip, % programTitle, Suspended
    }
    else
    {
        Menu, Tray, Icon, Bahk.ico, , 1
        TrayTip, % programTitle, Resumed
    }
    return

#^+h::
    SplitPath, A_AhkPath, , ahkLocation
    Run, "%ahkLocation%\AutoHotkey.chm"
    return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Shortcuts

#h::return

#d::
    Input chordKey, L1 M T1
    if chordKey = f ; "file"
    {
        Input chordKey, L1 M T1
        if chordKey = p ; "prefix"
        {
            FormatTime, dateString, %A_Now%, yyyyMMdd
        }
        else
        {
            FormatTime, dateString, %A_Now%, yyyy-MM-dd HH_mm_ss
        }
    }
    else if chordKey = t ; "time"
    {
        FormatTime, dateString, %A_Now%, yyyy-MM-dd HH:mm:ss
    }
    else
    {
        date = %A_Now%
        if (chordKey = "=" || chordKey = "+" || chordKey = "-")
        {
            Input chordKey2, L1 M T1
            if (chordKey2 >= 1 && chordKey2 <= 9)
            {
                date += chordKey2 * (chordKey = "-" ? -1 : 1), days
            }
        }
        FormatTime, dateString, %date%, yyyy-MM-dd, dddd
    }
    Send, % dateString
    return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programs

#m::Run, "%LocalAppData%\authy\Authy Desktop.exe"

#IfWinActive ahk_group CtrlShiftZ
^+z::Send, ^y
#If

#IfWinActive ahk_exe Authy Desktop.exe
^c::
    CoordMode, Mouse, Client
    MouseGetPos, savedX, savedY
    Click, 350, 528
    MouseMove, %savedX%, %savedY%, 0
    return
#If

#IfWinActive ahk_exe outlook.exe
!Up::!+Up
!Down::!+Down
#If

#IfWinActive OneNote
!Up::!+Up
!Down::!+Down
^+PgUp::Send, ^+a!+{Up}{Esc}
^+PgDn::Send, ^+a!+{Down}{Esc}
^+k::Send, {Home}+{End}+{Right}{Delete}
^=::^!+=
^-::^!+-
!+Down::
    clipboardOrig := ClipboardAll
    Send, {Esc}^a^c{Home}^v
    Sleep, 500 ; clipboardOrig can be copied back before ^v happens
    Clipboard := clipboardOrig
    clipboardOrig = ; free memory in case clipboard was large
    return
#If

#IfWinActive ahk_exe winword.exe
!Up::!+Up
!Down::!+Down
^+k::Send, {End}+{Home}{Delete}
^=::
    Send, !wq
    WinWait, Zoom
    Send, !e{Up 10}{Enter}
    return
^-::
    Send, !wq
    WinWait, Zoom
    Send, !e{Down 10}{Enter}
    return
^Numpad0::Send, !wj
^.::Send, !hu{Right}{Enter}{Esc}
#If

#IfWinActive ahk_exe Discord.exe
!F4::WinClose
#If

#IfWinActive Microsoft Store
XButton1::!Left
#If

#IfWinActive ahk_exe Teams.exe
!Left::
    CoordMode, Mouse, Client
    MouseGetPos, savedX, savedY
    MouseMove, 0, 0, 0
    Send, {XButton1}
    MouseMove, %savedX%, %savedY%, 0
    return
!Right::
    CoordMode, Mouse, Client
    MouseGetPos, savedX, savedY
    MouseMove, 0, 0, 0
    Send, {XButton2}
    MouseMove, %savedX%, %savedY%, 0
    return
#If

#IfWinActive ahk_exe msedge.exe
^,::
    ; Sidebar must be turned off for these tab counts
    Send, !+t+{Tab 2}
    Sleep, 100
    Send, {Home}{Right}{Space}+{F6}
    return

$^1::
$^2::
$^3::
$^4::
$^5::
    item := SubStr(A_ThisHotkey, 0) - 1
    WinGetPos, , , clientW, clientH
    if (clientW == 433 and clientH == 658)
    {
        itemY := 135 + 45 * item
        CoordMode, Mouse, Client
        MouseGetPos, savedX, savedY
        Click, 280, %itemY%
        MouseMove, %savedX%, %savedY%, 0
    }
    else
    {
        Send, % StrReplace(A_ThisHotkey, "$", "")
    }
    return
#If
