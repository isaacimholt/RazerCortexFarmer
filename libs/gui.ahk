#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


Gui, Show , w200 h200, Window title
Gui, Add, Text, x10 y10 w90 Center,text here 
Gui, Add, DropDownList, vColorChoice, Black|White|Red|Green|Blue
Gui, Add, Button, default, OK
return

GuiClose:
ButtonOK:
Gui, Submit 
GuiControlGet, ColorChoice 
MsgBox You entered "%ColorChoice%".
ExitApp