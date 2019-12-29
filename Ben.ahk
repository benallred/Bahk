#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
#Warn ; Enable every type of warning; show each warning in a message box
#SingleInstance Ignore ; Skips the dialog box and leaves the old instance running
SendMode Input ; Recommended for new scripts due to its superior speed and reliability
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Notes
;; #=Win; ^=Ctrl; +=Shift; !=Alt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants

programTitle = Bahk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Script Startup

if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%" /restart
    ExitApp
}

Menu, Tray, Icon, Bahk.ico, , 1
TrayTip, % programTitle, Loaded
