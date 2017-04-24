# create a json file from pipeline
get-package -ProviderName chocolatey | convertto-json | set-content c:\etc\test.json
# use json file as source
$packages = get-content c:\etc\test.json | convertfrom-json