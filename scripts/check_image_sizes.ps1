Add-Type -AssemblyName System.Drawing

$imagePath = "c:\Users\suley\Desktop\taskiai-main\taskiai-main\TaskiAI\TaskiAI\Assets.xcassets"

Get-ChildItem -Path $imagePath -Recurse -Filter "*.png" | ForEach-Object {
    try {
        $img = [System.Drawing.Image]::FromFile($_.FullName)
        Write-Output ("{0}: {1}x{2}" -f $_.Name, $img.Width, $img.Height)
        $img.Dispose()
    } catch {
        Write-Output ("{0}: Error loading" -f $_.Name)
    }
}
