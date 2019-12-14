# Implement your module commands in this script.
Function Compress-Folder {
	<#
	.SYNOPSIS
		Folder compression utility
	.DESCRIPTION
		Function to compress the contents of a folder into a Zip File
	.PARAMETER srcFolder
		Name of folder for compressing contents.
	.PARAMETER resultFile
		Name of resulting compressed file.
	.EXAMPLE
		I ♥ PS >_compress-folder -srcFolder c:\etc -resultfile c:\temp\etc.zip
	.NOTES
		04.14/2018 JJK:	TODO: Parameter validate on resultfile to ensure extension is Zip
		04.14/2018 JJK:	TODO: Parameterize Compression type
	#>
	# Version 1.0.0.0
	[cmdletbinding()]
	Param(
		[Parameter(Mandatory = $true,
			ValueFromPipeline = $true,
			HelpMessage = "Directory of files to be Compressed.")]
		[ValidateScript({ test-path $_ })]
		[System.String]$srcFolder,

		[Parameter(Mandatory = $true,
			ValueFromPipeline = $true,
			HelpMessage = "Location of compressed file.")]
		[ValidateScript({ test-path -Path (Split-Path -Path $_ )})]
		[System.String]$resultFile
	)
	Begin {
		[Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" ) | out-null
		$CompressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
	}
	Process {
		[System.IO.Compression.ZipFile]::CreateFromDirectory($srcFolder, $resultFile, $CompressionLevel, $null)
	}
	End {
		Remove-Variable -Name srcFolder, resultfile
		[System.GC]::Collect()
	}
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function *-*
