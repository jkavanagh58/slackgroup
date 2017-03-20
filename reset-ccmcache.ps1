Function get-ccmcachesize {
# Depending on client install method access to folder might require UAC
$cacheItems = (Get-ChildItem C:\windows\ccmcache -recurse -force| Measure-Object -property length -sum)
"{0:N2}" -f ($colItems.sum / 1MB) + " MB"
}
$start = get-ccmcachesize
#Connect to Resource Manager COM Object
$resman = new-object -com "UIResource.UIResourceMgr"
$cacheInfo = $resman.GetCacheInfo()
# Enum Cache elements, compare date, and delete older than 60 days
$cacheinfo.GetCacheElements() | 
    where-object {$_.LastReferenceTime -lt (get-date).AddDays(-60)} | 
    foreach {$cacheInfo.DeleteCacheElement($_.CacheElementID)}
$end = get-ccmcachesize