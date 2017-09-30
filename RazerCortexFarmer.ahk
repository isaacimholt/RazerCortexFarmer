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

#Include libs\FindClick.ahk  ; usefull lib for clicking images


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
    ; TODO: CHECK WINDOW TITLE AS WELL THERE IS A BUYG WHERE IT COLLIDES WITH OTHER OPEN BLIZZARD WINDOWS
}


; --------------- OPEN HEARTHSTONE ---------------

; bring battle.net to front 
WinActivate, ahk_exe Battle.net.exe

; click hearthstone icon on left
; (options are: 30 shades of variance allowed, relative window, wait 60s, check every 500ms)
FindClick("imgs\hearthstone.png", "o30 r w60000,500")

; click launch button 300px from left edge & 70px from window bottom
CoordMode, Mouse, Relative
WinGetPos, x, y, w, h, ahk_exe Battle.net.exe
clickheight := h - 70
Click 300, %clickheight%
WinWait, ahk_exe Hearthstone.exe
WinActivate, Hearthstone
if WinExist("ahk_exe Battle.net.exe"){
    WinMinimize, ahk_exe Battle.net.exe
}


; --------------- MAX HOURS ---------------

minute_counter := 0
MAX_MINUTES := 5 * 60   ; keep game open for 5 hrs max
SetTimer, TimerCounter, 60000


; --------------- ANTI-AFK ---------------

max_idle := 1000 * 60 * 5
min_idle := 1000 * 5

;TODO: implement with timers
Loop {
    if ( A_TimeIdlePhysical > max_idle ){
        Loop {
            if ( A_TimeIdlePhysical < min_idle ){
                Break
            }
            MoveMouseRand()

            Sleep, %min_idle%
        }   
    }
    Sleep, 1000

}


; --------------- HELPER FUNCTIONS ---------------

ProcessExist(Name){
	Process,Exist,%Name%
	return Errorlevel
}

MoveMouseRand(){
    Random, ranX, -100, 100
    Random, ranY, -100, 100
    mousemove, %ranX%, %ranY%, 100, R
}

TimerCounter:
    IfWinExist, Hearthstone
    {
        minute_counter += 1
    }
    if ( minute_counter > MAX_MINUTES ){
        SetTimer, TimerCounter, off
        TrayTip, info, %minute_counter%
        WinClose, Hearthstone
        ExitApp
    }
Return