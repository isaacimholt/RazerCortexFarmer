

; --------------- OPEN BATTLE.NET ---------------

open_battlenet(){
    ; (using WinExist to open from systray too)
    if !WinExist("ahk_exe Battle.net.exe"){

        ; check if there is existing path
        IniRead, battlenet_path, data/config.ini, Paths, BattleNet

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
            IniWrite, %battlenet_path%, data/config.ini, Paths, BattleNet
        }
        
        ; open the file
        Run, %battlenet_path%
        WinWait, ahk_exe Battle.net.exe
    }
    ;WinActivate, Blizzard
}

; --------------- OPEN BATTLENET GAME ---------------

; https://us.battle.net/forums/en/wow/topic/20742815763

open_battlenet_game(game_window_title, game_code){

    ; make sure battlenet is running and active
    open_battlenet()

    ;Run, battlenet
    shell:=ComObjCreate("Shell.Application")
    shell.FileRun()
    
    WinWait %shell%
    Send {Raw} battlenet://%game_code%
    Send {ENTER}
    
    WinWait, %game_window_title%
    WinActivate, %game_window_title%
    if WinExist("ahk_exe Battle.net.exe"){
        WinMinimize, ahk_exe Battle.net.exe
    }
}

; --------------- OPEN STEAM GAME ---------------
open_steam_game(game_window_title, game_code, game_process) {
    ; check that game is not open (must not be in-game)
    ; TODO

    ; open game if not open
    IfWinNotExist, %game_window_title% ahk_exe %game_process% {
        Run steam://rungameid/%game_id%
        WinWait, %game_window_title% ahk_exe %game_process, 60*3
    }
}


