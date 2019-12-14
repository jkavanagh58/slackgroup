$newPlasterManifestSplat = @{
    TemplateType = 'Item'
    Path = 'c:\etc\plaster01'
    TemplateName = 'sysfunctions'
    TemplateVersion = "1.0"
    Description = "Module of System Functions"
    Author = "John J Kavanagh"
    Title = "System Functions"
}
New-PlasterManifest @newPlasterManifestSplat
invoke-plaster -TemplatePath C:\etc\plaster01 C:\etc