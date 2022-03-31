#Generate URL
$organization = "raja12bab"
$project = "Gragle"
$url_base = "https://dev.azure.com/$organization/$project/"
$url_endpoint = "_apis/distributedtask/variablegroups?api-version=6.0-preview.2"
$url = $url_base + $url_endpoint

#Generate PAT
$Personal_Access_Token= "tvwcsk43dnqc3xkpjewh6u6k2exromwj6bnkkym4rw3yzw7hbu2a"
$user = ""
$token = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $Personal_Access_Token)))
$header = @{authorization = "Basic $token"}
#Make HTTP Request
$response = Invoke-RestMethod -Uri "$url" -Method GET -ContentType "application/json" -headers $header | convertto-json -depth 100

#Class
class BuildInfo 
{
    [string]$BuildName
    [string]$BuildID
    [string]$Status
    [string]$Result
}

#Declare Arraylist to easily add/remove
$Builds = [System.Collections.ArrayList]@()

#Populate the Arraylist with instances based on the class we created earlier
foreach($item in $response.value)
{
    $build = [BuildInfo]::new()
    $build.BuildName = $item.definition.name
    $build.BuildID = $item.definition.id
    $build.Status = $item.status
    $build.Result = $item.result

    $Builds.Add($build) | Out-null #if you comment out 'Out-Null' you will see that this outputs the Count of items. Do this to remove the gibberish
}

#Filter the list for Unique values only
$Builds = $Builds | Select-Object BuildName,BuildID,Status,Result -Unique

#Display the information we care about
for ($i=0;$i -lt $Builds.Count; $i++)
{
    write-host "
                Build Name :  $($Builds[$i].BuildName) `n 
                Build ID : $($Builds[$i].BuildID) `n 
                Build Status : $($Builds[$i].status) `n
                Build Result : $($Builds[$i].result) `n"
}


#Declare the output file name
$output_file = "C:\temp\SampleJson.Json"

#Write the entire json object retrieved into a output file
$response | ConvertTo-Json -Depth 100 | Out-File $output_file