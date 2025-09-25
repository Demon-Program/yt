# Roblox Cookie Decoder
Add-Type -AssemblyName System.Security

# Path to the Roblox cookies file
$cookieFile = "C:\device1\RobloxCookies.dat"

if (-Not (Test-Path $cookieFile)) {
    Write-Host "File not found: $cookieFile" -ForegroundColor Red
    exit
}

try {
    $json = Get-Content $cookieFile | ConvertFrom-Json
    $base64 = $json.CookiesData
} catch {
    Write-Host "Cannot read file or file is not JSON." -ForegroundColor Red
    exit
}

try {
    $bytes = [System.Convert]::FromBase64String($base64)
} catch {
    Write-Host "Invalid Base64 format." -ForegroundColor Red
    exit
}

try {
    $plain = [System.Text.Encoding]::UTF8.GetString(
        [System.Security.Cryptography.ProtectedData]::Unprotect(
            $bytes,
            $null,
            [System.Security.Cryptography.DataProtectionScope]::CurrentUser
        )
    )
    Write-Host "Decoded Roblox Cookie:" -ForegroundColor Green
    Write-Output $plain
} catch {
    Write-Host "Failed to decrypt. You must run this on the same Windows account that created the file." -ForegroundColor Red
}


