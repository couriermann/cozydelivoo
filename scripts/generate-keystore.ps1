# ============================================================
# Keystore Generation Script for The Cozy Courier
# 
# PRIVACY NOTICE:
# - This script does NOT collect any system information
# - This script does NOT read any personal data
# - This script does NOT access IP address or location
# - This script does NOT auto-fill any values
# - ALL inputs are manually provided by the user
#
# SECURITY:
# - The generated keystore should NEVER be committed to git
# - Store the base64 output ONLY in GitHub Secrets
# - Delete the local .jks file after copying to secrets
# ============================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  COZYCOURIER KEYSTORE GENERATION SCRIPT" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "PRIVACY STATEMENT:" -ForegroundColor Yellow
Write-Host "- This script does NOT collect system information" -ForegroundColor Yellow
Write-Host "- This script does NOT read personal data" -ForegroundColor Yellow
Write-Host "- This script does NOT access IP or location" -ForegroundColor Yellow
Write-Host "- ALL values must be manually entered by you" -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# FUNCTION: Prompt for required input (cannot be empty)
# ============================================================
function Get-RequiredInput {
    param (
        [string]$Prompt,
        [string]$Description
    )
    
    Write-Host "$Description" -ForegroundColor Gray
    do {
        $value = Read-Host -Prompt $Prompt
        if ([string]::IsNullOrWhiteSpace($value)) {
            Write-Host "This field is required. Please enter a value." -ForegroundColor Red
        }
    } while ([string]::IsNullOrWhiteSpace($value))
    
    return $value.Trim()
}

# ============================================================
# FUNCTION: Prompt for secure input (password)
# ============================================================
function Get-SecureInput {
    param (
        [string]$Prompt,
        [string]$Description
    )
    
    Write-Host "$Description" -ForegroundColor Gray
    do {
        $secure = Read-Host -Prompt $Prompt -AsSecureString
        $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
        )
        if ([string]::IsNullOrWhiteSpace($plain)) {
            Write-Host "Password is required. Please enter a value." -ForegroundColor Red
        }
        elseif ($plain.Length -lt 6) {
            Write-Host "Password must be at least 6 characters." -ForegroundColor Red
            $plain = ""
        }
    } while ([string]::IsNullOrWhiteSpace($plain))
    
    return $plain
}

# ============================================================
# COLLECT COMPANY/ORGANIZATION DETAILS (7 Required Fields)
# ============================================================

Write-Host "Please enter your COMPANY/ORGANIZATION details:" -ForegroundColor Green
Write-Host "(These will be embedded in the certificate)" -ForegroundColor Gray
Write-Host ""

# 1. Organization Name (Company Name)
$orgName = Get-RequiredInput -Prompt "Organization Name (Company)" -Description "Example: Cozy Courier Games LLC"

# 2. Organizational Unit
$orgUnit = Get-RequiredInput -Prompt "Organizational Unit (Department)" -Description "Example: Mobile Development"

# 3. City/Locality
$city = Get-RequiredInput -Prompt "City/Locality" -Description "Example: San Francisco"

# 4. State/Province
$state = Get-RequiredInput -Prompt "State/Province" -Description "Example: California"

# 5. Country Code (2 letters)
do {
    $country = Get-RequiredInput -Prompt "Country Code (2 letters)" -Description "Example: US"
    if ($country.Length -ne 2) {
        Write-Host "Country code must be exactly 2 letters (e.g., US, UK, DE)" -ForegroundColor Red
        $country = ""
    }
} while ([string]::IsNullOrWhiteSpace($country))
$country = $country.ToUpper()

# 6. Common Name (usually app or company name)
$commonName = Get-RequiredInput -Prompt "Common Name (App/Company)" -Description "Example: The Cozy Courier"

# 7. Email Address
$email = Get-RequiredInput -Prompt "Email Address" -Description "Example: developer@company.com"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Please enter KEYSTORE credentials:" -ForegroundColor Green
Write-Host "(Remember these - you'll need them for GitHub Secrets)" -ForegroundColor Gray
Write-Host ""

# Key Alias
$keyAlias = Get-RequiredInput -Prompt "Key Alias" -Description "Example: cozycourier-upload-key"

# Store Password
Write-Host ""
$storePassword = Get-SecureInput -Prompt "Keystore Password (min 6 chars)" -Description "This password protects the keystore file"

# Key Password
Write-Host ""
$keyPassword = Get-SecureInput -Prompt "Key Password (min 6 chars)" -Description "This password protects the key within the keystore"

# Validity period
Write-Host ""
Write-Host "Certificate validity period in years" -ForegroundColor Gray
$validityYears = Read-Host -Prompt "Validity Years (default: 25)"
if ([string]::IsNullOrWhiteSpace($validityYears)) {
    $validityYears = "25"
}
$validityDays = [int]$validityYears * 365

# ============================================================
# GENERATE KEYSTORE
# ============================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Generating keystore..." -ForegroundColor Green
Write-Host ""

# Construct the Distinguished Name (DN)
$dname = "CN=$commonName, OU=$orgUnit, O=$orgName, L=$city, ST=$state, C=$country, EMAILADDRESS=$email"

# Output file
$keystoreFile = "cozycourier-release.jks"

# Check if keytool is available
$keytool = Get-Command keytool -ErrorAction SilentlyContinue
if (-not $keytool) {
    Write-Host "ERROR: 'keytool' command not found!" -ForegroundColor Red
    Write-Host "Please ensure Java JDK is installed and added to PATH." -ForegroundColor Red
    Write-Host "Download from: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Remove existing keystore if present
if (Test-Path $keystoreFile) {
    Remove-Item $keystoreFile -Force
}

# Generate the keystore using keytool
try {
    $keytoolArgs = @(
        "-genkeypair",
        "-v",
        "-keystore", $keystoreFile,
        "-alias", $keyAlias,
        "-keyalg", "RSA",
        "-keysize", "2048",
        "-validity", $validityDays,
        "-storepass", $storePassword,
        "-keypass", $keyPassword,
        "-dname", $dname
    )
    
    & keytool @keytoolArgs 2>&1 | Out-Null
    
    if (-not (Test-Path $keystoreFile)) {
        throw "Keystore file was not created"
    }
    
    Write-Host "Keystore generated successfully!" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Failed to generate keystore" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# ============================================================
# ENCODE KEYSTORE TO BASE64
# ============================================================

Write-Host ""
Write-Host "Encoding keystore to Base64..." -ForegroundColor Green

$keystoreBytes = [System.IO.File]::ReadAllBytes($keystoreFile)
$keystoreBase64 = [System.Convert]::ToBase64String($keystoreBytes)

# Save base64 to file for easy copying
$base64File = "cozycourier-keystore-base64.txt"
$keystoreBase64 | Out-File -FilePath $base64File -Encoding ASCII -NoNewline

Write-Host "Base64 encoding complete!" -ForegroundColor Green

# ============================================================
# OUTPUT INSTRUCTIONS
# ============================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  KEYSTORE GENERATION COMPLETE!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "FILES CREATED:" -ForegroundColor Yellow
Write-Host "  1. $keystoreFile (JKS keystore file)" -ForegroundColor White
Write-Host "  2. $base64File (Base64 encoded keystore)" -ForegroundColor White
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  GITHUB SECRETS CONFIGURATION" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Add the following secrets to your GitHub repository:" -ForegroundColor Yellow
Write-Host "Go to: Repository > Settings > Secrets and variables > Actions" -ForegroundColor Gray
Write-Host ""
Write-Host "SECRET NAME                      | VALUE" -ForegroundColor Cyan
Write-Host "-------------------------------- | --------------------------------" -ForegroundColor Gray
Write-Host "COZYCOURIER_KEYSTORE_BASE64      | (contents of $base64File)" -ForegroundColor White
Write-Host "COZYCOURIER_KEY_ALIAS            | $keyAlias" -ForegroundColor White
Write-Host "COZYCOURIER_KEY_PASSWORD         | (the key password you entered)" -ForegroundColor White
Write-Host "COZYCOURIER_STORE_PASSWORD       | (the store password you entered)" -ForegroundColor White
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  IMPORTANT SECURITY NOTES" -ForegroundColor Red
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. NEVER commit the .jks file to version control" -ForegroundColor Red
Write-Host "2. NEVER commit the base64.txt file to version control" -ForegroundColor Red
Write-Host "3. Store passwords securely (password manager recommended)" -ForegroundColor Yellow
Write-Host "4. Keep a secure backup of the keystore file" -ForegroundColor Yellow
Write-Host "5. Delete these files from this directory after setup" -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  CERTIFICATE DETAILS" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Organization:    $orgName" -ForegroundColor White
Write-Host "Unit:            $orgUnit" -ForegroundColor White
Write-Host "Common Name:     $commonName" -ForegroundColor White
Write-Host "Location:        $city, $state, $country" -ForegroundColor White
Write-Host "Email:           $email" -ForegroundColor White
Write-Host "Key Alias:       $keyAlias" -ForegroundColor White
Write-Host "Validity:        $validityYears years ($validityDays days)" -ForegroundColor White
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "The Base64 keystore content has been saved to:" -ForegroundColor Green
Write-Host "$base64File" -ForegroundColor Yellow
Write-Host ""
Write-Host "Copy the ENTIRE contents of this file to the" -ForegroundColor Gray
Write-Host "COZYCOURIER_KEYSTORE_BASE64 GitHub secret." -ForegroundColor Gray
Write-Host ""

# ============================================================
# OPTIONAL: Display base64 (truncated for security)
# ============================================================

$base64Preview = $keystoreBase64.Substring(0, [Math]::Min(50, $keystoreBase64.Length))
Write-Host "Base64 Preview (first 50 chars):" -ForegroundColor Gray
Write-Host "$base64Preview..." -ForegroundColor DarkGray
Write-Host ""
Write-Host "Full Base64 length: $($keystoreBase64.Length) characters" -ForegroundColor Gray
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
