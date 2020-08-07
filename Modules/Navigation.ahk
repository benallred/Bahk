CapsLock & `::HomeRowNavigationEnabled(true)

#If, HomeRowNavigationEnabled()
*h::Navigate("Left")
*j::Navigate("Down")
*k::Navigate("Up")
*l::Navigate("Right")
CapsLock & h::Navigate("Home")
CapsLock & j::Navigate("PgDn")
CapsLock & k::Navigate("PgUp")
CapsLock & l::Navigate("End")
#If

HomeRowNavigationEnabled(toggle = false)
{
    static homeRowNavigationEnabled := 0

    if (toggle)
    {
        homeRowNavigationEnabled := !homeRowNavigationEnabled
    }

    return homeRowNavigationEnabled
}

Navigate(direction)
{
    local
    modifiers :=
    if (GetKeyState("Ctrl"))
        modifiers .= "^"
    if (GetKeyState("Shift"))
        modifiers .= "+"
    Send, % modifiers "{" direction "}"
}
