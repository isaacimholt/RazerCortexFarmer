#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

Gui Add, DropDownList, x90 y50 w120, DropDownList||
Gui Add, Button, x110 y80 w80 h23, &OK

Gui Show, w300 h150, Select Game
Return

GuiEscape:
GuiClose:
    ExitApp