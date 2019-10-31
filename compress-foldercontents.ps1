# Example of using .Net to compress files
<#
.PARAMETER srcFolder
	Name of folder for compressing contents.
.PARAMETER resultFile
	Name of resulting compressed file.
.NOTES
	04.14/2018 JJK:	TODO: Parameter validate on resultfile to ensure extension is Zip
	04.14/2018 JJK:	TODO: Parameterize Compression type
#>
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