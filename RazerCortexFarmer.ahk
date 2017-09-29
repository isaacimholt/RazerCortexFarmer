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


; --------------- OPEN RAZER CORTEX ---------------

if !ProcessExist("RazerCortex.exe"){
    Run, "C:\Program Files (x86)\Razer\Razer Cortex\CortexLauncher.exe"
    WinWait, ahk_exe RazerCortex.exe
    WinClose, ahk_exe RazerCortex.exe
}

; --------------- OPEN BATTLE.NET ---------------

; (using WinExist to open from systray too)
if !WinExist("ahk_exe Battle.net.exe"){
    Try Run, "C:\Program Files (x86)\Blizzard App\Battle.net.exe"
    Try Run, "C:\Program Files (x86)\Battle.net\Battle.net.exe"
    WinWait, ahk_exe Battle.net.exe
}

; --------------- OPEN HEARTHSTONE ---------------

; bring window to front 
WinActivate, ahk_exe Battle.net.exe
; click hearthstone icon on left
FindClick("hearthstone.png", "o30 r w60000,500")
; get window size
CoordMode, Mouse, Relative
WinGetPos, x, y, w, h, ahk_exe Battle.net.exe
; click launch button 300px from left edge & 70px from window bottom
clickheight := h - 70
Click 300, %clickheight%

/*
*   Helper Functions
*/

ProcessExist(Name){
	Process,Exist,%Name%
	return Errorlevel
}