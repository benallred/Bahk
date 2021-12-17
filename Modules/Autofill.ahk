$#f::
    autofills := LoadAutofills()
    if (autofills.Count() = 0)
    {
        FirstRun()
    }
    else
    {
        currentNode := autofills
        Loop
        {
            Input, chordKey, L1 M T1
            if (ErrorLevel = "Timeout" || !currentNode[chordKey])
            {
                break
            }
            currentNode := currentNode[chordKey]
        }
        if (currentNode.default)
        {
            Send, % currentNode.default
        }
        else
        {
            Send, % StrReplace(A_ThisHotkey, "$", "")
        }
    }
    return

GetAutofillFilePath()
{
    EnvGet, OneDrive, OneDrive
    return OneDrive "\." A_ScriptName ".autofills"
}

LoadAutofills()
{
    local
    autofills := {}
    Loop, Read, % GetAutofillFilePath()
    {
        keyValuePair := StrSplit(A_LoopReadLine, "=")
        key := keyValuePair[1]
        keyPartsLength := StrSplit(key, ".").Length()
        parentNode := autofills
        currentNodeName :=
        Loop, Parse, key, .
        {
            currentNodeName := A_LoopField
            if (A_Index < keyPartsLength)
            {
                parentNode := parentNode[A_LoopField]
            }
        }
        parentNode[currentNodeName] := { default: keyValuePair[2] }
    }
    return autofills
}

SaveAutofills(autofills, currentPath = "")
{
    local
    if (autofills.default)
    {
        FileAppend, % currentPath "=" autofills.default "`n", % GetAutofillFilePath()
    }
    For key, value in autofills
    {
        if (key != "default")
        {
            SaveAutofills(value, (currentPath ? currentPath "." : "") key)
        }
    }
}

FirstRun()
{
    local
    MsgBox, % 4 + 64, , This is the first time you've used the autofill functionality.`nWould you like to set it up now?
    IfMsgBox, Yes
    {
        InputBox, firstName, , First name, , 250, 125
        InputBox, lastName, , Last name, , 250, 125
        InputBox, addressLine1, , Address line 1, , 250, 125
        InputBox, city, , City, , 250, 125
        InputBox, state, , State (abbreviation), , 250, 125
        InputBox, zipCode, , Zip code, , 250, 125
        InputBox, phoneNumber, , Phone number (xxx-xxx-xxxx), , 250, 125
        InputBox, email1, , Email (personal 1), , 250, 125
        InputBox, email2, , Email (personal 2), , 250, 125
        InputBox, emailWork, , Email (work), , 250, 125
        InputBox, birthday, , Birthday (mm/dd/yyyy), , 250, 125
        InputBox, username, , Username, , 250, 125

        phoneNumberParts := StrSplit(phoneNumber, "-")

        autofills := { }
        autofills["n"] := { default: firstName " " lastName }
        autofills["n"]["t"] := { default: firstName "{tab}{tab}" lastName }
        autofills["n"]["t"]["1"] := { default: firstName "{tab}" lastName }
        autofills["a"] := { default: addressLine1 }
        autofills["a"]["2"] := { default: city "{tab}" state "{tab}" zipCode }
        autofills["p"] := { default: phoneNumberParts[1] "-" phoneNumberParts[2] "-" phoneNumberParts[3] }
        autofills["p"]["t"] := { default: phoneNumberParts[1] "{tab}" phoneNumberParts[2] "{tab}" phoneNumberParts[3] }
        autofills["p"]["a"] := { default: phoneNumberParts[1] phoneNumberParts[2] phoneNumberParts[3] }
        autofills["e"] := { default: email1 }
        autofills["e"]["2"] := { default: email2 }
        autofills["e"]["w"] := { default: emailWork }
        autofills["b"] := { default: birthday }
        autofills["u"] := { default: username }

        SaveAutofills(autofills)
    }
}
