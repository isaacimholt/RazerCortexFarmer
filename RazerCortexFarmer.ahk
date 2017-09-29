/*
1. Aprire Cortex
2. Aprire Battle.net
3. Aprire Heartstone
4. Muovere il mouse
5. Dopo 5 ore spegnere tutto
*/

#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn         ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; run cortex
Run, "C:\Program Files (x86)\Razer\Razer Cortex\CortexLauncher.exe"

; wait 30 seconds for program to load
Sleep, 30 * 1000

; open battlenet
Run, ""

; wait 30 seconds for program to load
Sleep, 30 * 1000