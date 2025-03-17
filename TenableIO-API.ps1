#This script uses the Tenable.io API to export the DMZ agent scan and then download the nessus file to the specified path
$accessKeyIO = "<redacted>"
$secretKeyIO = "<redacted>"
$uuid = "<redacted>"
$headers = @{}
$headers.Add("accept", "application/json")
$headers.Add("content-type", "application/json")
$headers.Add("X-ApiKeys", "accessKey=$accessKeyIO;secretKey=$secretKeyIO")
$export = Invoke-RestMethod -Uri "https://cloud.tenable.com/scans/$uuid/export" -Method POST -Headers $headers -Body '{"format":"nessus"}'
$exportFile = $export.file
$headers.accept = "application/octet-stream"
Invoke-RestMethod -Uri "https://cloud.tenable.com/scans/480/export/$exportFile/download" -Method GET -Headers $headers -OutFile C:\users\<redacted>\desktop\dmz.nessus

#This script uses the Tenable.sc API script to import the nessus file from the script above into Tenable.sc
