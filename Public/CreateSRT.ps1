Function New-SRT {
    Param(
        $InputObj
    )
    $i = 1
    ForEach($SRT in $InputObj){
        $result += @"
$i
$($SRT.Start),00 --> $($SRT.Finish),00
$($SRT.Time) $($SRT.Type)
"@
        If($SRT -ne $InputObj[-1]){ $result += "`r`n`r`n"; $i++} 
    }
    return $result
}

Function Invoke-SRT {
    Param(
        [ValidateSet("Course", "Lap")]
        $Type,
        $Start = "00:00:00",
        $Finish,
        $Time
    )
    $result = @()
    $result += @{
        Type = $Type
        Start = $Start
        Finish = $Finish
        Time = $Time
    }
    return $result
}

Function Add-Subtitles {
    [Alias("addsubs")]
    Param (
        $InputPath,
        $OutputPath,
        $SubsPath
    )
    ffmpeg -i $InputPath -vf subtitles=$SubsPath $OutputPath
}