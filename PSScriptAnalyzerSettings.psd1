@{
    # Use Severity when you want to limit the generated diagnostic records to a
    # subset of: Error, Warning and Information.
    # Uncomment the following line if you only want Errors and Warnings but
    # not Information diagnostic records.
    #Severity = @('Error','Warning')

    # Use IncludeRules when you want to run only a subset of the default rule set.
    #IncludeRules = @('PSAvoidDefaultValueSwitchParameter',
    #                 'PSMissingModuleManifestField',
    #                 'PSReservedCmdletChar',
    #                 'PSReservedParams',
    #                 'PSShouldProcess',
    #                 'PSUseApprovedVerbs',
    #                 'PSUseDeclaredVarsMoreThanAssigments')

    # Use ExcludeRules when you want to run most of the default set of rules except
    # for a few rules you wish to "exclude".  Note: if a rule is in both IncludeRules
    # and ExcludeRules, the rule will be excluded.
    #ExcludeRules = @('PSAvoidUsingWriteHost','PSMissingModuleManifestField')

    # You can use the following entry to supply parameters to rules that take parameters.
    # For instance, the PSAvoidUsingCmdletAliases rule takes a whitelist for aliases you
    # want to allow.
    #Rules = @{
    #    Do not flag 'cd' alias.
    #    PSAvoidUsingCmdletAliases = @{Whitelist = @('cd')}

    #    Check if your script uses cmdlets that are compatible on PowerShell Core,
    #    version 6.0.0-alpha, on Linux.
    #    PSUseCompatibleCmdlets = @{Compatibility = @("core-6.0.0-alpha-linux")}
    #}
    IncludeDefaultRules = $true
    # Verify Module is installed and the correct path
    # Path to module depends on how installed - this case assumes -Scope AllUsers
    CustomRulePath = "C:\\Program Files\\WindowsPowerShell\\Modules\\InjectionHunter\\1.0.0\\InjectionHunter.psd1"
}
Rules = @{
    PSAvoidUsingCmdletAliases = @{Whitelist = @('where')}

    PSPlaceOpenBrace = @{
        Enable             = $true
        OnSameLine         = $true
        NewLineAfter       = $true
        IgnoreOneLineBlock = $true
    }

    PSPlaceCloseBrace = @{
        Enable             = $true
        NewLineAfter       = $true
        IgnoreOneLineBlock = $true
        NoEmptyLineBefore  = $false
    }

    PSUseConsistentIndentation = @{
        Enable          = $true
        Kind            = 'tab'
        IndentationSize = 4
    }

    PSUseConsistentWhitespace = @{
        Enable         = $true
        CheckOpenBrace = $true
        CheckOpenParen = $true
        CheckOperator  = $true
        CheckSeparator = $true
    }

    PSAlignAssignmentStatement = @{
        Enable         = $true
        CheckHashtable = $true
    }
}
