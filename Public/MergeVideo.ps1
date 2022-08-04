Function Merge-Video {
    [Alias("combovid")]
    param (
        $ConcatPath,
        $OutputPath
    )
    ffmpeg -f concat -safe 0 -i $ConcatPath -c copy $OutputPath
}

Function New-ConcatFile { # Works a treat, as long as I want to merge in alphabetical order.
    Param(
        $InputPath
    )
    if (!$InputPath) {
        $InputPath = Get-Location
    }
    $ConcatPath = "$InputPath\concat.txt"
    
    $VideoCollection = Get-ChildItem -path "$InputPath\*"  -Include @("*Lap*","*SL*","*Course*")
    foreach ($filename in $VideoCollection.name) {
        $concatfile += "file '$filename'`n"
    }
    New-Item $ConcatPath -Value $concatfile -force -confirm:$false | Out-Null
}
