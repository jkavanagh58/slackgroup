Begin {
    Function convertto-WeekofYear {
        $caldays = @()
        $startday = Get-Date "1.1.2019"
        $counter = 0
        $curDay = Get-Date
        ForEach ($day in $startday.DayOfYear..$curDay.DayOfYear) {
            $calval = (get-date $startday).AddDays($counter)
            $obj = [PSCustomObject]@{
                Date       = $calval
                DOY        = $calval.DayOfYear
                WeekofYear = [int](Get-date $calval -UFormat %V)
            }
            $caldays += $obj
            $counter++
        }
        Remove-Variable counter, startday, curDay
        Return $caldays
    }
}
Process {
    $workingset = convertto-WeekofYear
    $stopPoint = [int](Get-date -UFormat %V)
    $weekCounter = 0
    Do {
        $weekCounter++
        $weekdates = $workingSet | Where WeekofYear -eq $weekCounter | select Date, DOY, WeekofYear
        $1stDay = ($weekdates | Measure-Object -Property Date -Minimum).Minimum
        $lastDay = ($weekdates | Measure-Object -Property Date -Maximum).Maximum
        "Your Filter would be something like -ge {0} and -le {1} for week {2}" -f $1stDay, $lastDay, $weekCounter

    } Until ($weekCounter -eq $stopPoint)
}
End {
    # Need to look at this a little closer
    #Remove-Variable -Name workingset, weekcounter, weeklist, 1stDay, lastDay -ErrorAction SilentlyContinue
    [System.GC]::Collect()
}