# Script to fix import paths in SyllabusView components
$copyPath = "C:\Users\camer\OneDrive\Documents\Desktop\both\copy\CoursePlanningTool\frontend\src"
$syllabusViewPath = "$copyPath\components\screens\CoursePage\SyllabusView"

Write-Host "Fixing import paths in SyllabusView components..." -ForegroundColor Green

# Get all tsx files in the SyllabusView directory and subdirectories
$files = Get-ChildItem -Path $syllabusViewPath -Filter "*.tsx" -Recurse

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Fix ButtonLogic import paths
    # From: "../../../components/Button/ButtonLogic" 
    # To:   "../../../../../components/Button/ButtonLogic" (for files in SyllabusView root)
    # To:   "../../../../../../components/Button/ButtonLogic" (for files in subdirectories)
    
    # Determine directory depth from SyllabusView
    $relativePath = $file.FullName.Replace($syllabusViewPath, "").Replace("\", "/")
    $depth = ($relativePath.Split('/') | Where-Object { $_ -ne "" }).Count - 1
    
    if ($depth -eq 0) {
        # Files directly in SyllabusView folder
        $content = $content -replace [regex]::Escape('../../../components/Button/ButtonLogic'), '../../../../../components/Button/ButtonLogic'
        $content = $content -replace [regex]::Escape('../../../SyllabusLayout/SyllabusPageHeader'), '../../../../../SyllabusLayout/SyllabusPageHeader'
        $content = $content -replace [regex]::Escape('../../../utils/'), '../../../../../utils/'
        $content = $content -replace [regex]::Escape('../../../components/RedirectingModal/RedirectingModal'), '../../../../../components/RedirectingModal/RedirectingModal'
        $content = $content -replace [regex]::Escape('../../../components/SyllabusComponents/'), '../../../../../components/SyllabusComponents/'
    } else {
        # Files in subdirectories of SyllabusView
        $dotsPrefix = "../" * ($depth + 4)  # 4 levels up to get to src, then adjust for depth
        $content = $content -replace [regex]::Escape('../../../components/Button/ButtonLogic'), "${dotsPrefix}components/Button/ButtonLogic"
        $content = $content -replace [regex]::Escape('../../../SyllabusLayout/SyllabusPageHeader'), "${dotsPrefix}SyllabusLayout/SyllabusPageHeader"
        $content = $content -replace [regex]::Escape('../../../utils/'), "${dotsPrefix}utils/"
        $content = $content -replace [regex]::Escape('../../../components/RedirectingModal/RedirectingModal'), "${dotsPrefix}components/RedirectingModal/RedirectingModal"
        $content = $content -replace [regex]::Escape('../../../components/SyllabusComponents/'), "${dotsPrefix}components/SyllabusComponents/"
        $content = $content -replace [regex]::Escape('../../../components/Tables/'), "${dotsPrefix}components/Tables/"
        $content = $content -replace [regex]::Escape('../../../assets/'), "${dotsPrefix}assets/"
    }
    
    # Write back if changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "  Updated imports in $($file.Name)" -ForegroundColor Cyan
    }
}

Write-Host "Import path fixes complete!" -ForegroundColor Green