function Test-Equality {
        [OutputType([boolean])]
        Param(
            # The objects to compare for equality
            [Parameter(Mandatory, ValueFromPipeline)]
            [ValidateNotNullOrEmpty()]
            [object[]] $Object
        )

        $head = $input | Select -First 1
        $input | Select -Skip 1 | % { recursiveEquality $head $_ } | Test-All
    }

    function recursiveEquality($a, $b) {
        if ($a -is [array] -and $b -is [array]) {
            Write-Debug "recursively test arrays '$a' '$b'"
            if ($a.Count -ne $b.Count) {
            return $false
            }
            $inequalIndexes = 0..($a.Count - 1) | ? { -not (recursiveEquality $a[$_] $b[$_]) }
            return $inequalIndexes.Count -eq 0
        }
        if ($a -is [hashtable] -and $b -is [hashtable]) {
            Write-Debug "recursively test hashtable '$a' '$b'"
            $inequalKeys = $a.Keys + $b.Keys `
            | Sort-Object -Unique `
            | ? { -not (recursiveEquality $a[$_] $b[$_]) }
            return $inequalKeys.Count -eq 0
        }
        if ((isPsCustomObject $a) -and (isPsCustomObject $b)) {
            Write-Debug "a is pscustomobject: $($a -is [psobject])"
            Write-Debug "recursively test objects '$a' '$b'"
            $inequalKeys = $a.psobject.Properties + $b.psobject.Properties `
            | % Name `
            | Sort-Object -Unique `
            | ? { -not (recursiveEquality $a.$_ $b.$_) }
            return $inequalKeys.Count -eq 0
        }
        Write-Debug "test leaves '$a' '$b'"
        return $a.GetType() -eq $b.GetType() -and $a -eq $b
    }
    
    function isPsCustomObject($v) {
        $v.PSTypeNames -contains 'System.Management.Automation.PSCustomObject'
    }