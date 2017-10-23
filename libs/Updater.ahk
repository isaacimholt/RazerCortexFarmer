#Include, Jxon.ahk

check_updates() {
    ; https://autohotkey.com/docs/commands/URLDownloadToFile.htm#Examples
    ; Example: Download text to a variable:
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", "https://api.github.com/repos/isaacimholt/RazerCortexFarmer/releases", true)
    whr.Send()
    ; Using 'true' above and the call below allows the script to remain responsive.
    whr.WaitForResponse()
    releases_json_txt := whr.ResponseText
    releases_json := Jxon_Load(releases_json_txt)
    MsgBox % releases_json[1]["created_at"]
}

check_updates()