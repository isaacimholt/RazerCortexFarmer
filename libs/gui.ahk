#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


select_game_gui(){
    global
    local vGameChoice
    Gui Show, w300 h150, Select Game to idle
    Gui, Add, Text, x10 y10 w90 Center,text here 
    Gui Add, DropDownList, vGameChoice, Hearthstone|Diablo III|Overwatch
    Gui Add, Button, x110 y80 w80 h23, &OK
    Gui, +LastFound
    GuiHWND := WinExist()
    WinWaitClose, ahk_id %GuiHWND%  ;--waiting for gui to close
    return GameChoice

    GuiClose:
    ButtonOK:
    Gui, Submit 
    GuiControlGet, GameChoice 
    return GameChoice
}
