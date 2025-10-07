Param(
    [Parameter(Mandatory=$true)] [string]$Src,
    [Parameter(Mandatory=$true)] [string]$OutDir
)

$ErrorActionPreference = 'Stop'

# Ensure System.Drawing is available
try {
    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
} catch {
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
}

if (-not (Test-Path -LiteralPath $Src)) {
    throw "Source logo not found: $Src"
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$sizes = @(
    @{W=40;  H=40;  N='Icon-20@2x.png'},
    @{W=60;  H=60;  N='Icon-20@3x.png'},
    @{W=58;  H=58;  N='Icon-29@2x.png'},
    @{W=87;  H=87;  N='Icon-29@3x.png'},
    @{W=80;  H=80;  N='Icon-40@2x.png'},
    @{W=120; H=120; N='Icon-40@3x.png'},
    @{W=120; H=120; N='Icon-60@2x.png'},
    @{W=180; H=180; N='Icon-60@3x.png'},
    @{W=1024;H=1024;N='Icon-1024.png'}
)

$logo = [System.Drawing.Image]::FromFile($Src)
foreach ($s in $sizes) {
    $bmp = New-Object System.Drawing.Bitmap($s.W, $s.H)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Black)
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    $scale = [Math]::Min($s.W / $logo.Width, $s.H / $logo.Height) * 0.9
    if ($scale -le 0) { $scale = 1.0 }
    $newW = [int]([Math]::Max(1, [Math]::Round($logo.Width * $scale)))
    $newH = [int]([Math]::Max(1, [Math]::Round($logo.Height * $scale)))
    $x = [int](($s.W - $newW) / 2)
    $y = [int](($s.H - $newH) / 2)

    $destRect = New-Object System.Drawing.Rectangle($x, $y, $newW, $newH)
    $g.DrawImage($logo, $destRect)

    $outPath = Join-Path $OutDir $s.N
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Output "Wrote $outPath"
}
$logo.Dispose()
