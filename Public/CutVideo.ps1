Function New-Videoes {
    Param(
        [Parameter(Position = 0)]
        [string]$InputPath,
        [Parameter(Position = 1)]
        [string]$OutputPath
    )
    # New-GetVideoParams $InputVideo $OutputVideo | Get-Video
    New-Video $InputPath $OutputPath
    While($choice -ne 'N'){
        $choice = Read-Host "Cut more videos?"

        $GridArguments = @{
            OutputMode = 'Single'
            Title      = 'Please select a video to load and click OK'
        }

        $videos = Get-ChildItem | Select-Object -Property Name
        $InputVideo = "test.mkv" # $videos.Name | Out-GridView @GridArguments
        $OutputVideo = "test2.mkv" # Read-Host "Output File"
        $NewVideoParams = @{
            InputPath = $InputVideo
            OutputPath = $OutputVideo
        }
        # Write-Host $NewVideoParams.InputPath, $NewVideoParams.OutputPath
        New-Video @NewVideoParams
    }
}

Function New-Video {
    Param(
        [Parameter(Position = 0)]
        [string]$InputPath,
        [Parameter(Position = 1)]
        [string]$OutputPath
    )
        # New-GetVideoParams $InputPath $OutputPath | Get-Video
        Write-Host $InputPath, $OutputPath
        $VideoParams = New-GetVideoParams $InputPath $OutputPath
        # Write-Host $VideoParams.InputPath, $VideoParams.OutputPath
        Get-Video @VideoParams
}

Function New-GetVideoParams {
    Param(
        [Parameter(Position = 0)]
        [string]$InputPath,
        [Parameter(Position = 1)]
        [string]$OutputPath
    )
    Write-Host $InputPath, $OutputPath
    $Times = Get-Split $InputPath
    $VideoParams = @{
        InputPath = $InputPath
        OutputPath = $OutputPath
        Start = $Times[0]
        End = $Times[1]
    }
    return $VideoParams
}

Function Get-Split {
    Param(
        [Parameter(Position = 0)]
        $InputPath
    )
    $timesPath = "$env:USERPROFILE\Documents\WindowsPowerShell\Scripts\CTR\tmp\times.txt"
    While($choice -ne 'Y'){
        Write-Host "Hit Ctrl+S to save the times."
        mpv $InputPath --quiet > $timesPath
        $splits = (cat $timesPath) -match '^\d.*'
        Write-Host $splits
        $choice = Read-Host "Are these correct?"
    }
    return $splits
}

Function Get-Video {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        $InputPath,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        $OutputPath,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        $Start,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        $End
    )
    if (!$InputPath) {
        $InputPath = (Get-Location).path
    }
    $Length = Get-TimeDifference -Start $Start -End $End
    ffmpeg -ss $Start -i $InputPath -t $Length $OutputPath
}

Function Get-TimeDifference{
    param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
        $Start,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
        $End
        )
    process{
        $TypedStart = ([DateTime]::ParseExact($Start, "HH:mm:ss",$null))
        $TypedEnd = ([DateTime]::ParseExact($End, "HH:mm:ss",$null))
        $elapsed = [PSCustomObject]@{
            Start = $Start
            End = $End
            Elapsed = ($TypedEnd - $TypedStart).ToString("hh\:mm\:ss")
        }
        $elapsed.elapsed
    }
}