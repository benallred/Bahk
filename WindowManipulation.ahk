$#w::
    Input, chordKey, L1 M T1
    if chordKey = t
    {
        WinSet, AlwaysOnTop, Toggle, A
    }
    else
    {
        Send, % StrReplace(A_ThisHotkey, "$", "")
    }
    return
