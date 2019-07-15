IF ($isMac) {
    "Running on a Mac"
}
ElseIf ($IsWindows){
    "Will run"
    If(get-installedmodule){
        "Modules installed"
    }
    Else {
        "No modules installed"
    }
}
ElseIf ($isLinux){
    "Running on linux"
}
