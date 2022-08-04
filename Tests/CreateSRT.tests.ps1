
BeforeAll {
    . "$PSScriptRoot\..\Public\CreateSRT.ps1"
    $SRTOutput = @"
1
00:00:00,00 --> 00:00:03,00
1:32:34 Course

2
00:02:34,00 --> 00:03:42,00
34:55 Lap
"@



    $SRTInput = @(
        @{
            Type = "Course"
            Start = "00:00:00"
            Finish = "00:00:03"
            Time = '1:32:34'
        }
        @{
            Type = "Lap"
            Start = "00:02:34"
            Finish = "00:03:42"
            Time = "34:55"
        }
    )
}

Describe 'New-SRT' {
    It 'Takes an array of dictonaries and outputs a string.'{
        $result = New-SRT $SRTInput
        $result | Should -Be $SRTOutput 
    }
}

Describe 'Invoke-SRT' {
    It 'Creates an array of dictionaries based on parameter input.'{
        $result =@()
        $result += Invoke-SRT -Type "Course" -Finish "00:00:03" -Time "1:32:34"
        $result += Invoke-SRT -Type "Lap" -Start "00:02:34" -Finish "00:03:42" -Time "34:55"
        $result, $SRTInput | Test-Equality | Should -BeTrue
    }
}