/*
1. Aprire Cortex
2. Aprire Battle.net
3. Aprire Heartstone
4. Muovere il mouse
5. Dopo 5 ore spegnere tutto
*/

#SingleInstance, force
#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn         ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#Include libs\FindClick.ahk         ; useful lib for clicking images
#Include libs\BattlenetGames.ahk
#Include libs\gui.ahk


; --------------- OPEN GUI ---------------

game_choice := select_game_gui()


; --------------- OPEN RAZER CORTEX ---------------

; (using WinExist to open from systray too)
if !WinExist("Razer Cortex"){
    
    ; check if there is existing path
    IniRead, cortex_path, config.ini, Paths, Cortex

    path_array := []
        path_array[1] := "C:\Program Files\Razer\Razer Cortex\CortexLauncher.exe"
        path_array[2] := "C:\Program Files (x86)\Razer\Razer Cortex\CortexLauncher.exe"

        for index, path in path_array{

            ; check if this file exists
            if FileExist(path){
                cortex_path := path
                Break
            }
        }

        ; if we've still not found the file, then have user select it
        if (cortex_path == "ERROR"){
            MsgBox % "Please select the Cortex Launcher executable"            
            FileSelectFile, cortex_path, 3, , Select Cortex Launcher, Executables (*.exe)
        }

    ; save the file location for next time
    IniWrite, %cortex_path%, config.ini, Paths, Cortex
    

    ; open the file
    Run, %cortex_path%
    
    WinWait, Razer Cortex
    WinClose, Razer Cortex
}


; --------------- RUN GAMES ---------------

if (game_choice == "Hearthstone") {
    open_battlenet_game("Hearthstone", "WTCG")
} else if (game_choice == "Diablo III") {
    open_battlenet_game("Diablo", "D3")
} else if (game_choice == "Overwatch") {
    open_battlenet_game("Overwatch", "Pro")
} else {
    MsgBox % "ah stronzo che cazzo hai fatto nn esiste sto gioco di merda"
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