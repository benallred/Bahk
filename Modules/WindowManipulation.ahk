$#w::
    Input, chordKey, L1 M T1
    if chordKey = t
    {
        WinSet, AlwaysOnTop, Toggle, A
    }
    else if chordKey = r
    {
        Input, chordKey2, L1 M T1
        if (chordKey2 >= 1 && chordKey2 <= 9)
        {
            WinSet, Transparent, % chordKey2 * 25.5, A
        }
        else
        {
            WinSet, Transparent, Off, A
        }
    }
    else
    {
        Send, % StrReplace(A_ThisHotkey, "$", "")
    }
    return
