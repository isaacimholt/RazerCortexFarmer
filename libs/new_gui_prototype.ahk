﻿; Generated by AutoGUI 1.4.9a
#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

Gui Add, StatusBar,, Status Bar
Gui Add, GroupBox, x8 y8 w168 h139, Select Game
Gui Add, DropDownList, x32 y64 w120, DropDownList||
Gui Add, Text, x32 y32 w120 h23 +0x200, Select game to idle:
Gui Add, CheckBox, x32 y96 w120 h36, Don't open game, just move mouse
Gui Add, Button, x56 y168 w80 h23, Start

Gui Show, w187 h236, Razer Cortex Farmer
Return

GuiEscape:
GuiClose:
    ExitApp

; Do not edit above this line