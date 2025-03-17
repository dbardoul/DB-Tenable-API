$accessKeySC = "<redacted>"
$secretKeySC = "<redacted>"
$boundary = [System.Guid]::NewGuid().ToString()
$headers = [ordered]@{}
$headers.Add("Accept-Encoding", "gzip, deflate")
$headers.Add("Accept", '*/*')
$headers.add("Content-Type", "multipart/form-data; boundary=$boundary")
$headers.Add("x-apikey", "accessKey=$accessKeySC;secretKey=$secretKeySC")

$filename = "dmz.nessus"
$file = "C:\Users\<redacted>\Desktop\dmz.nessus"
$fileBinary = [IO.File]::ReadAllBytes($file)
$enc = [System.Text.Encoding]::GetEncoding("iso-8859-1")
$fileEnc = $enc.GetString($fileBinary)
$LF = "`n"

$bodyLines = (
  "--$boundary",
  "Content-Disposition: form-data; name=`"Filedata`"; filename=`"$Filename`"",
  "Content-Type: text/plain$LF",
  "",
  "$fileEnc",
  "--$boundary--"
  ) -join $LF

$uploadResponse = Invoke-RestMethod -Uri https://<redacted>.<redacted>.local/rest/file/upload -Method POST -Headers $headers -Body $bodyLines
$uploadFile = $uploadResponse.response.filename
$uploadFileString = [string]$uploadFile
$uploadFileString
$repo = "31"
$integer = [int]$repo

$AuthBody = @{
    filename = $uploadFileString
    repository = @{id = $integer}
    classifyMitigatedAge = "0"
    dhcpTracking = "true"
    scanningVirtualHosts = "false"
} | ConvertTo-Json


$headers2 = @{}
$headers2.Add("accept", "application/json")
$headers2.Add("content-type", "application/json")
$headers2.Add("x-apikey", "accessKey=$accessKeySC;secretKey=$secretKeySC")
Invoke-RestMethod -Uri https://<redacted>.<redacted>.local/rest/scanResults/import -Method POST -Headers $headers2 -Body $AuthBody