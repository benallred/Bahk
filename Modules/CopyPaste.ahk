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

^!0::
^!1::
^!2::
^!3::
^!4::
^!5::
^!6::
^!7::
^!8::
^!9::
    clipNumber := SubStr(A_ThisHotkey, 0)
    Send, ^c
    Sleep, 100
    clips%clipNumber% := Clipboard
    return

^+0::
^+1::
^+2::
^+3::
^+4::
^+5::
^+6::
^+7::
^+8::
^+9::
    clipNumber := SubStr(A_ThisHotkey, 0)
    Clipboard := clips%clipNumber%
    Send, ^v
    return
