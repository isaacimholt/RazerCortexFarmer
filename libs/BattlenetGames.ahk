

; --------------- OPEN BATTLE.NET ---------------

open_battlenet(){
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
    WinActivate, Blizzard App
}


; --------------- OPEN BATTLENET GAME ---------------


open_battlenet_game(game_window_title, launcher_img){

    ; make sure battlenet is running and active
    open_battlenet()

    ; click game icon on left

    /*
      'o' means start of ahk ImageSearch command options
      'TransBlack' is used to make black count as transparent
      for .png this makes transparency work
      o30:  allow 30 shades of variance
      r:    search relative to window
      w60000,500: wait 60s and check every 500ms
    */
    FindClick(launcher_img, "oTransBlack,30 r w60000,500")

    ; click launch button 300px from left edge & 70px from window bottom
    CoordMode, Mouse, Relative
    WinGetPos, x, y, w, h, Blizzard App
    clickheight := h - 70
    Click 300, %clickheight%
    WinWait, %game_window_title%
    WinActivate, %game_window_title%
    if WinExist("Blizzard App"){
        WinMinimize, Blizzard App
    }
}

