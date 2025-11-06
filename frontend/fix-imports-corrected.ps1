# Corrected script to fix import paths in SyllabusView components
$copyPath = "C:\Users\camer\OneDrive\Documents\Desktop\both\copy\CoursePlanningTool\frontend\src"
$syllabusViewPath = "$copyPath\components\screens\CoursePage\SyllabusView"

Write-Host "Fixing import paths in SyllabusView components (corrected)..." -ForegroundColor Green

# Get all tsx files in the SyllabusView directory and subdirectories
$files = Get-ChildItem -Path $syllabusViewPath -Filter "*.tsx" -Recurse

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Determine directory depth from SyllabusView
    $relativePath = $file.FullName.Replace($syllabusViewPath, "").Replace("\", "/")
    $depth = ($relativePath.Split('/') | Where-Object { $_ -ne "" }).Count - 1
    
    if ($depth -eq 0) {
        # Files directly in SyllabusView folder (4 levels up to src)
        $content = $content -replace [regex]::Escape('../../../../../components/Button/ButtonLogic'), '../../../../components/Button/ButtonLogic'
        $content = $content -replace [regex]::Escape('../../../../../SyllabusLayout/SyllabusPageHeader'), '../../../../SyllabusLayout/SyllabusPageHeader'  
        $content = $content -replace [regex]::Escape('../../../../../utils/'), '../../../../utils/'
        $content = $content -replace [regex]::Escape('../../../../../components/RedirectingModal/RedirectingModal'), '../../../../components/RedirectingModal/RedirectingModal'
        $content = $content -replace [regex]::Escape('../../../../../components/SyllabusComponents/'), '../../../../components/SyllabusComponents/'
        $content = $content -replace [regex]::Escape('../../../../../assets/'), '../../../../assets/'
    } else {
        # Files in subdirectories of SyllabusView (5 levels up to src)
        $dotsPrefix = "../" * (5)  # 5 levels up from subdirectories
        $content = $content -replace [regex]::Escape('../../../../../../components/Button/ButtonLogic'), "${dotsPrefix}components/Button/ButtonLogic"
        $content = $content -replace [regex]::Escape('../../../../../../SyllabusLayout/SyllabusPageHeader'), "${dotsPrefix}SyllabusLayout/SyllabusPageHeader"
        $content = $content -replace [regex]::Escape('../../../../../../utils/'), "${dotsPrefix}utils/"
        $content = $content -replace [regex]::Escape('../../../../../../components/RedirectingModal/RedirectingModal'), "${dotsPrefix}components/RedirectingModal/RedirectingModal"
        $content = $content -replace [regex]::Escape('../../../../../../components/SyllabusComponents/'), "${dotsPrefix}components/SyllabusComponents/"
        $content = $content -replace [regex]::Escape('../../../../../../components/Tables/'), "${dotsPrefix}components/Tables/"
        $content = $content -replace [regex]::Escape('../../../../../../assets/'), "${dotsPrefix}assets/"
    }
    
    # Write back if changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "  Updated imports in $($file.Name)" -ForegroundColor Cyan
    }
}

Write-Host "Corrected import path fixes complete!" -ForegroundColor Green