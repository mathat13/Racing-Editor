BeforeAll {
    . "$PSScriptRoot\..\Public\CutVideo.ps1"
    . "$PSScriptRoot\scripts\Test-Equality.ps1"

    $InputPath = "C:\Users\liljo\Documents\WindowsPowerShell\Scripts\CTR\tmp\OS\OS_Course.mkv"
    $OutputPath = "C:\Users\liljo\Documents\WindowsPowerShell\Scripts\CTR\tmp\OS\OS_Course(1).mkv"
    $NewVideoParamsInput = @{
        InputPath = $InputPath
        OutputPath = $OutputPath
    }
    $NewVideoParamsOutput = @{
        InputPath = $InputPath
        OutputPath = $OutputPath
        Start = "00:00:00"
        End =  "00:00:01"
    }
    $GetSplitInput = $NewVideoParamsOutput
    $NewVideoOutput = @{
        $InputPath = "scripts"
        $OutputPath = "b.mkv"
    }
    
    # Test Functions read from testtime.txt in the resources folder rather than an update then a read each time
    # Should be proof enough.

    Function Get-SplitTest {
        Param(
            [Parameter(Position = 0)]
            $InputPath
        )
        $timesPath = "$PSScriptRoot\resources\timestest.txt"
        $splits = (cat $timesPath) -match '^\d.*'
        return $splits
    }

    Function New-VideoParamsTest {
        Param(
            [Parameter(Position = 0)]
            [string]$InputPath,
            [Parameter(Position = 1)]
            [string]$OutputPath
        )
        $Times = Get-SplitTest $InputPath
        $VideoInfo = @{
            InputPath = $InputPath
            OutputPath = $OutputPath
            Start = $Times[0]
            End = $Times[1]        
        }
    }

    Function New-VideoesTest {
        Param(
            [Parameter(Position = 0)]
            [string]$InputVideo,
            [Parameter(Position = 1)]
            [string]$OutputVideo
        )
        While($choice -ne 'N'){
            # New-GetVideoParams $InputPath $OutputPath | Get-Video
            Write-Host $InputVideo $OutputVideo
            $choice = Read-Host "Cut more videos?"
            $GridArguments = @{
            OutputMode = 'Single'
            Title      = 'Please select a video to cut and click OK'
            }
            $videos = Get-ChildItem | Select-Object -Property Name
            $InputPath = "scripts" # $videos | Out-GridView @GridArguments
            $OutputPath = "b.mkv" # Read-Host "Output File: "
            $NewVideoParams = @{
                InputPath = "scripts" # $videos | Out-GridView @GridArguments
                OutputPath = "b.mkv" # Read-Host "Output File: "
            }
            return $NewVideoParams
        }
    }
}

Describe "New-VideoParams validation" {
    It "checks that the actual hash table has correct keys and values" {
        $actual = New-VideoParamsTest @NewVideoParamsInput
        $expected = $NewVideoParamsOutput
        $actual, $expected | Test-Equality | Should -BeTrue
    }
}

Describe 'Get-Split' {
    It 'Takes an input filepath and outputs an array of times.' {
        $actual = Get-SplitTest $InputPath
        $expected = @("00:00:00", "00:00:01")
        $actual | Should -Be $expected
    }
}

Describe 'New-Video Parameter loop' {
    It 'Takes a set of initial parameters and creates a hash table for next function call.' {
        $actual = New-VideoesTest @NewVideoParamsInput
        $expected = $NewVideoOutput
        $actual, $expected | Test-Equality | Should -BeTrue
    }
}

Describe 'New-VideoesTest Out-Gridview' {
    It 'Checks that the Out-GridView outputs correctly.' {
        $GridArguments = @{
            OutputMode = 'Single'
            Title      = 'Please select a map to load and click OK'
        }
        $videos = Get-ChildItem | Select-Object -Property Name
        $actual = $videos.Name | Out-GridView @GridArguments
        $expected = "scripts"
        $actual | Should -Be $expected
    }
}