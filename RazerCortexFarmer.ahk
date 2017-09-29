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

#Include FindClick.ahk  ; usefull lib for clicking images

ProcessExist(Name){
	Process,Exist,%Name%
	return Errorlevel
}

; run Razer Cortex
if !ProcessExist("RazerCortex.exe"){
    Run, "C:\Program Files (x86)\Razer\Razer Cortex\CortexLauncher.exe"
    ; wait 30 seconds for program to load
    Sleep, 30 * 1000
}

; open Battle.net
if !ProcessExist("Battle.net.exe"){
    Try Run, "C:\Program Files (x86)\Blizzard App\Battle.net.exe"
    Try Run, "C:\Program Files (x86)\Battle.net\Battle.net.exe"
    ; wait 30 seconds for program to load
    Sleep, 30 * 1000
}

; open Hearthstone

; bring window to front 
WinActivate, ahk_exe Battle.net.exe ; will this work if closed to tray???
; search img hearthstone.png
; click hearthstone icon on left
FindClick("hearthstone.png", "o30 r")
; get window size
; click 315px from left edge & 70px from window bottom
; click launch botton