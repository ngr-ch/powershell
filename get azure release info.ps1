$url = "https://vsrm.dev.azure.com/raja12bab/Gragle/_apis/release/definitions/1/revisions?api-version=7.1-preview.4"

Write-Host "URL: $url"
$pipeline = Invoke-RestMethod -Uri $url -Method Get -Headers @{
    Authorization = "*******"
}
Write-Host "Pipeline = $($pipeline | ConvertTo-Json -Depth 100)"

# Update an existing variable named TestVar to its new value 2
$pipeline.variables.TestVar.value = "789"

####****************** update the modified object **************************
$json = @($pipeline) | ConvertTo-Json -Depth 99

$updatedef = Invoke-RestMethod -Uri $url -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization = "tvwcsk43dnqc3xkpjewh6u6k2exromwj6bnkkym4rw3yzw7hbu2a"}

write-host "==========================================================" 
Write-host "The value of Varialbe 'TestVar' is updated to" $updatedef.variables.TestVar.value