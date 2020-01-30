#^g::Send, % GenerateGuid(true)
#^+g::Send, % GenerateGuid(false)

GenerateGuid(lowerCase = false)
{
    local
    typeLib := ComObjCreate("Scriptlet.TypeLib")
    guid := typeLib.Guid
    StringReplace, guid, guid, `{
    StringReplace, guid, guid, `}
    if (lowerCase)
    {
        StringLower, guid, guid
    }
    return guid
}
