#IfWinNotActive ahk_exe msedge.exe
^+c::
    Clipboard :=
    Send, ^c
    ClipWait
    Clipboard := Clipboard ; get clipboard as text
    return
#If

^+v::
    clipboardOrig := ClipboardAll
    Clipboard := Trim(Clipboard)
    Send, ^v
    Sleep, 500 ; clipboardOrig can be copied back before ^v happens
    Clipboard := clipboardOrig
    clipboardOrig = ; free memory in case clipboard was large
    return
