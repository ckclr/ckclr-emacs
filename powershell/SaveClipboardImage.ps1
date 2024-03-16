# SaveClipboardImage.ps1

param (
    [String]$ImagePath  # The path where the image will be saved
)

Add-Type -AssemblyName System.Drawing

$image = Get-Clipboard -Format Image

if ($image -ne $null) {
    $image.Save($ImagePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $image.Dispose()
    Write-Host "The image has been saved to: $ImagePath"
} else {
    Write-Host "No image found in the clipboard."
}
