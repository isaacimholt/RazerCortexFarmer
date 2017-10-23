#Include, libs\Jxon.ahk


check_updates() {
    RELEASES_JSON   := _download_json("https://api.github.com/repos/isaacimholt/RazerCortexFarmer/releases")
    GITHUB_VERSION  := RELEASES_JSON[1]["tag_name"]
    ; todo, add VERSION file to project, then compare versions and return true if needs update
    RELEASE_ZIP_URL := RELEASES_JSON[1]["zipball_url"]
    new_name := "Razer Cortex Farmer " . GITHUB_VERSION . ".zip"
    UrlDownloadToFile, %RELEASE_ZIP_URL%, %new_name%
    msgbox % RELEASE_ZIP_URL
}


; ------------------------------------------------
; --------------- HELPER FUNCTIONS ---------------
; ------------------------------------------------


_download_json(url) {
    ; https://autohotkey.com/docs/commands/URLDownloadToFile.htm#Examples
    ; Example: Download text to a variable:
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", url, true)
    whr.Send()
    ; Using 'true' above and the call below allows the script to remain responsive.
    whr.WaitForResponse()
    json_txt := whr.ResponseText
    json := Jxon_Load(json_txt)
    Return json
}