$ErrorActionPreference = 'Stop'

$sourceDir = "c:\Users\suley\Desktop\taskiai-main\taskiai-main\UI (Copy) (1)"
$assetsDir = "c:\Users\suley\Desktop\taskiai-main\taskiai-main\TaskiAI\TaskiAI\Assets.xcassets"

# Copy welcome.png
$welcomeDir = Join-Path $assetsDir "onboarding_welcome.imageset"
New-Item -ItemType Directory -Force -Path $welcomeDir | Out-Null
Copy-Item (Join-Path $sourceDir "welcome.png") (Join-Path $welcomeDir "onboarding_welcome.png") -Force
Write-Output "Copied welcome.png"

# Copy onboard1-8.png
for ($i = 1; $i -le 8; $i++) {
    $imageName = "onboarding_$i"
    $imageDir = Join-Path $assetsDir "$imageName.imageset"
    New-Item -ItemType Directory -Force -Path $imageDir | Out-Null
    Copy-Item (Join-Path $sourceDir "onboard$i.png") (Join-Path $imageDir "$imageName.png") -Force
    Write-Output "Copied onboard$i.png"
}

Write-Output "All assets copied successfully!"
