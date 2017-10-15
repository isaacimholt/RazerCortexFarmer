/*
1. Aprire Cortex
2. Aprire Battle.net
3. Aprire Heartstone
4. Muovere il mouse
5. Dopo 5 ore spegnere tutto
*/

#Persistent     ; keep app running
#SingleInstance, force
#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn         ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#Include libs\FindClick.ahk         ; useful lib for clicking images
#Include libs\OpenGames.ahk
#Include libs\gui.ahk
#Include libs\ObjCSV.ahk


; --------------- LOAD GAME DATA ---------------

;strFile := A_ScriptDir . "\data\games.csv"

IfNotExist, my_games.csv
    FileCopy, data\games.csv, my_games.csv

; update data
UpdateGamesCSV("\my_games.csv", "\data\games.csv")

strFile := A_ScriptDir . "\my_games.csv"
strFields := "" ; this will contain the field names after loading csv
game_data := ObjCSV_CSV2Collection(strFile, strFields)

; --------------- OPEN GUI ---------------

game_launch := select_game_gui(game_data)

; --------------- OPEN RAZER CORTEX ---------------

; (using WinExist to open from systray too)
if !WinExist("ahk_exe RazerCortex.exe"){
    
    ; check if there is existing path
    IniRead, cortex_path, data/config.ini, Paths, Cortex

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
    IniWrite, %cortex_path%, data/config.ini, Paths, Cortex
    

    ; open the file
    Run, %cortex_path%
    WinWait, ahk_exe RazerCortex.exe
    ; Sleep, 10000
}

WinClose, Razer Cortex      ; only works with admin privileges

; --------------- RUN GAMES ---------------

if (game_data[game_launch].source == "BattleNet") {
    open_battlenet_game(game_data[game_launch].window_title, game_data[game_launch].game_code)
}
else if (game_data[game_launch].source == "Steam") {
    open_steam_game(game_data[game_launch].window_title, game_data[game_launch].game_code, game_data[game_launch].exe)
}
else if (game_data[game_launch].source == "None") {
    open_none_game(game_data[game_launch])
}

; --------------- ANTI-AFK ---------------

minute_counter := 0             ; for tracking game time
; MAX_GAME_MINUTES := 60 * 5      ; keep game open 5 hours

IniRead, MAX_GAME_MINUTES, data/config.ini, IdleTime, TimeToIdle
IDLE_START := 1000 * 60 * 3     ; start mouse-move after 3 mins user afk (in ms)
IDLE_UPDATE := 1000 * 5         ; move mouse every 5 seconds while user afk (in ms)

; check saved minutes
minute_counter := SaveMinutes()

SetTimer, GameMinutesTimer, 60000   ; run every minute
SetTimer, IdleStartTimer, %IDLE_START%

Return  ; app stays open because of #Persistent

; --------------- TRY ICON MENU ---------------
;IniRead, minutes_idled, data/config.ini, Timer, minutes_idled, 0
;Menu, tray, add  ; Creates a separator line.
;Menu, tray, add, %minutes_idled% minutes ideled, PD ; Creates a new menu item.
; ================================================
; --------------- HELPER FUNCTIONS ---------------

MoveMouseRand(){
    Random, ranX, -100, 100
    Random, ranY, -100, 100
    mousemove, %ranX%, %ranY%, 100, R
}

SaveMinutes(mins:=0){
    ; updates minutes saved on file
    ; call without parameters to check currently saved minutes

    now_date_time = %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%
    
    IniRead, old_date_time, data/config.ini, Timer, last_update, %now_date_time%
    IniRead, old_minutes, data/config.ini, Timer, minutes_idled, 0

    today_10_am = %A_YYYY%-%A_MM%-%A_DD% 10:00
    yesterday := a_now
    yesterday += -1, days
    FormatTime, yesterday_10_am, %yesterday%, yyyy-MM-dd 10:10
    
    if (now_date_time >= today_10_am) {
    	; dopo le 10am
    	if (old_date_time < today_10_am) {
        	now_minutes := 0
    	} else {
        	now_minutes := old_minutes + mins
    	}
    } else {
    	; mattina presto
        if (old_date_time < yesterday_10_am) {
        	now_minutes := 0
    	} else {
        	now_minutes := old_minutes + mins
    	}
    }

    IniWrite, %now_date_time%, data/config.ini, Timer, last_update
    IniWrite, %now_minutes%, data/config.ini, Timer, minutes_idled
    ;percentage := %now_minutes%/%MAX_GAME_MINUTES%*100
    Return now_minutes
}

;PD:

GameMinutesTimer:

    window_title := game_data[game_launch].window_title

    ; keep track of game time, run once per minute
    If WinExist(window_title) {
        minute_counter := SaveMinutes(1)
    }
    
    ; stop idling if max time reached
    if ( minute_counter >= MAX_GAME_MINUTES ){
        SetTimer, GameMinutesTimer, off
        SetTimer, IdleStartTimer, off
        SetTimer, IdleUpdateTimer, off
        WinClose, %window_title% ; possibly requires admin?
        ExitApp
    }

Return

IdleStartTimer:

    ; check that user has been afk long enough to start
    if ( A_TimeIdlePhysical >= IDLE_START ){
        ; switch to IdleUpdateTimer
        SetTimer, , off
        SetTimer, IdleUpdateTimer, %IDLE_UPDATE%
    }

Return

IdleUpdateTimer:

    ; check if user has returned from afk or game not open
    if ( A_TimeIdlePhysical < IDLE_UPDATE or !WinExist(window_title) ){
        /*  
            attention: mousemove command appears to affect A_TimeIdlePhysical
            therefore don't set above to <= as it ALWAYS triggers from itself
        */
        ; switch to IdleStartTimer
        SetTimer, , off
        SetTimer, IdleStartTimer, %IDLE_START%
    } else {
        ; if user hasn't returned - move mouse
        MoveMouseRand()
    }

Return

UpdateGamesCSV(target_csv, source_csv){

    strFileSrc      := A_ScriptDir . source_csv
    strFieldsSrc    := "" ; this will contain the field names after loading csv
    source_obj      := ObjCSV_CSV2Collection(strFileSrc, strFieldsSrc)

    strFileTrgt     := A_ScriptDir . target_csv
    strFieldsTrgt   := "" ; this will contain the field names after loading csv
    target_obj      := ObjCSV_CSV2Collection(strFileTrgt, strFieldsTrgt)

    for s_index,s_value in source_obj{
        exists := False
        for t_index,t_value in target_obj{
            if (s_value.game_name == t_value.game_name) {
                exists := True
                Break
            }
        }
        if (!exists){
            target_obj.push(s_value)
        }
    }

    ObjCSV_Collection2CSV(target_obj, strFileTrgt, 1, strFieldsTrgt, , 1)

}