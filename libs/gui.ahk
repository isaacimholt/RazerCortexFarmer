#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


select_game_gui(game_data){
    global
    local vGameChoice, index

    dropdown_list_values := ""
    loop, % game_data.MaxIndex()
    {
        if (dropdown_list_values == ""){
            dropdown_list_values := game_data[A_Index].game_name
        } else {
            dropdown_list_values := dropdown_list_values . "|" . game_data[A_Index].game_name
        }
    }
            
    ; Read last game choosen
    IniRead, N, data/config.ini, DefaultGame, Game, 1
    Gui Show, w300 h150, Select Game to idle
    Gui, Add, Text, x100 y20 w100 h23 Center,Select a game to idle
    Gui Add, DropDownList, x90 y50 Choose%N% vGameChoice, %dropdown_list_values%
    Gui Add, Button, x110 y80 w80 h23, &OK
    Gui, +LastFound
    GuiHWND := WinExist()
    WinWaitClose, ahk_id %GuiHWND%  ;--waiting for gui to close
    return index

    GuiClose:
        ExitApp
    ButtonOK:
        Gui, Submit 
        GuiControlGet, GameChoice
        ; Read game index
        index := 1
        loop, % game_data.MaxIndex() {
            if (GameChoice == game_data[A_Index].game_name) {
                index := A_Index
                Break
            }
        }
        ; Save game index
        IniWrite, %index%, data/config.ini, DefaultGame, Game
        return index
}
