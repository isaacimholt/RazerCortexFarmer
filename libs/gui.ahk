#SingleInstance, force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


select_game_gui(){
    global
    local vGameChoice
    IniRead, N, config.ini, DefaultGame, Game, [1]
    Gui Show, w300 h150, Select Game to idle
    Gui, Add, Text, x100 y20 w100 h23 Center,Select a game to idle
    Gui Add, DropDownList, x90 y50 Choose%N% vGameChoice, Hearthstone||Diablo3|Overwatch
    Gui Add, Button, x110 y80 w80 h23, &OK
    Gui, +LastFound
    GuiHWND := WinExist()
    WinWaitClose, ahk_id %GuiHWND%  ;--waiting for gui to close
    return GameChoice

    GuiClose:
        ExitApp
    ButtonOK:
        Gui, Submit 
        GuiControlGet, GameChoice
        IniRead, index, data/games.ini, GameList, %GameChoice%
        IniWrite, %index%, config.ini, DefaultGame, Game
        return GameChoice
}
