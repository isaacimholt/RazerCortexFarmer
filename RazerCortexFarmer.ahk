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

; (using WinExist to open from systray too)
if !WinExist("Razer Cortex"){
    
    ; check if there is existing path
    IniRead, cortex_path, config.ini, Path, Cortex

    ; if not, we try some default locations looking for the .exe
    if (cortex_path == "ERROR") {
        
        if FileExist("C:\Program Files\Razer\Razer Cortex\CortexLauncher.exe"){
            cortex_path := "C:\Program Files\Razer\Razer Cortex\CortexLauncher.exe"
        } else if FileExist("C:\Program Files (x86)\Razer\Razer Cortex\CortexLauncher.exe"){
            cortex_path := "C:\Program Files (x86)\Razer\Razer Cortex\CortexLauncher.exe"
        } else { 
            ; if we've still not found the file, then have user select it
            MsgBox % "Please select the Cortex Launcher executable"
            FileSelectFile, cortex_path, 3, , Select Cortex Launcher, Executables (*.exe)
        }

        ; save the file location for next time
        IniWrite, %cortex_path%, config.ini, Path, Cortex
    }

    ; open the file
    Run, %cortex_path%
    
    WinWait, Razer Cortex
    WinClose, Razer Cortex
}


; --------------- OPEN BATTLE.NET ---------------

; (using WinExist to open from systray too)
if !WinExist("Blizzard App"){

    ; check if there is existing path
    IniRead, battlenet_path, config.ini, Paths, BattleNet

    ; if not, we try some default locations looking for the .exe
    if (battlenet_path == "ERROR"){

        path_array := []
        path_array[1] := "C:\Program Files\Blizzard App\Battle.net.exe"
        path_array[2] := "C:\Program Files (x86)\Blizzard App\Battle.net.exe"
        path_array[3] := "C:\Program Files\Battle.net\Battle.net.exe"
        path_array[4] := "C:\Program Files (x86)\Battle.net\Battle.net.exe"

        for index, path in path_array{

            ; check if this file exists
            if FileExist(path){
                battlenet_path := path
                Break
            }
        }

        ; if we've still not found the file, then have user select it
        if (battlenet_path == "ERROR"){
            MsgBox % "Please select the Battle.net.exe file"
            FileSelectFile, battlenet_path, 3, , Select Battle.net.exe, Executables (*.exe)
        }
        
        ; save the file location for next time
        IniWrite, %battlenet_path%, config.ini, Paths, BattleNet
    }
    
    ; open the file
    Run, %battlenet_path%
    WinWait, Blizzard App
}


; --------------- OPEN HEARTHSTONE ---------------

; bring battle.net to front 
WinActivate, Blizzard App

; click hearthstone icon on left
; (options are: 30 shades of variance allowed, relative window, wait 60s, check every 500ms)
FindClick("imgs\hearthstone.png", "o30 r w60000,500")

; click launch button 300px from left edge & 70px from window bottom
CoordMode, Mouse, Relative
WinGetPos, x, y, w, h, Blizzard App
clickheight := h - 70
Click 300, %clickheight%
WinWait, Hearthstone
WinActivate, Hearthstone
if WinExist("Blizzard App"){
    WinMinimize, Blizzard App
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

ProgramFiles32() {
   If (A_Is64bitOS)
      EnvGet, PF32, ProgramFiles(x86)
   Else
      PF32 := A_ProgramFiles
   Return PF32
}
