#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
#Warn ; Enable every type of warning; show each warning in a message box
#SingleInstance Ignore ; Skips the dialog box and leaves the old instance running
SendMode Input ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
#Include %A_ScriptDir% ; Change the working directory used by all subsequent occurrences of #Include and FileInstall. SetWorkingDir has no effect on #Include because #Include is processed before the script begins executing.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Notes
;; #=Win; ^=Ctrl; +=Shift; !=Alt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants

programTitle = Bahk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Environment Variables

EnvGet, LocalAppData, LocalAppData

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

#d::
    Input chordKey, L1 M T1
    if chordKey = t
    {
        FormatTime, dateString, %A_Now%, yyyy-MM-dd HH:mm:ss
        Send, % dateString
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
        Send, % dateString
    }
    return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programs

#m::Run, "%LocalAppData%\authy-electron\Authy Desktop.exe"

#IfWinActive Microsoft Store
XButton1::Send, !{Left}
#If
