# Script to fix overcorrected import paths in SyllabusView components  
$syllabusViewPath = "C:\Users\camer\OneDrive\Documents\Desktop\both\copy\CoursePlanningTool\frontend\src\components\screens\CoursePage\SyllabusView"

Write-Host "Fixing overcorrected import paths..." -ForegroundColor Green

# Get all tsx files in the SyllabusView directory and subdirectories
$files = Get-ChildItem -Path $syllabusViewPath -Filter "*.tsx" -Recurse

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Fix overcorrected paths - reduce the number of ../
    # From ../../../../ to ../../../ for files in root SyllabusView
    # From ../../../../../ to ../../../../ for files in subdirectories
    
    $relativePath = $file.FullName.Replace($syllabusViewPath, "").Replace("\", "/")
    $depth = ($relativePath.Split('/') | Where-Object { $_ -ne "" }).Count - 1
    
    if ($depth -eq 0) {
        # Files directly in SyllabusView folder - reduce from ../../../../ to ../../../
        $content = $content -replace [regex]::Escape('../../../../components/Button/ButtonLogic'), '../../../components/Button/ButtonLogic'
        $content = $content -replace [regex]::Escape('../../../../SyllabusLayout/SyllabusPageHeader'), '../../../SyllabusLayout/SyllabusPageHeader'
        $content = $content -replace [regex]::Escape('../../../../utils/'), '../../../utils/'
        $content = $content -replace [regex]::Escape('../../../../components/RedirectingModal/RedirectingModal'), '../../../components/RedirectingModal/RedirectingModal'
        $content = $content -replace [regex]::Escape('../../../../components/SyllabusComponents/'), '../../../components/SyllabusComponents/'
        $content = $content -replace [regex]::Escape('../../../../assets/'), '../../../assets/'
    } else {
        # Files in subdirectories - reduce from ../../../../../ to ../../../../  
        $content = $content -replace [regex]::Escape('../../../../../components/Button/ButtonLogic'), '../../../../components/Button/ButtonLogic'
        $content = $content -replace [regex]::Escape('../../../../../SyllabusLayout/SyllabusPageHeader'), '../../../../SyllabusLayout/SyllabusPageHeader'
        $content = $content -replace [regex]::Escape('../../../../../utils/'), '../../../../utils/'
        $content = $content -replace [regex]::Escape('../../../../../components/RedirectingModal/RedirectingModal'), '../../../../components/RedirectingModal/RedirectingModal'
        $content = $content -replace [regex]::Escape('../../../../../components/SyllabusComponents/'), '../../../../components/SyllabusComponents/'
        $content = $content -replace [regex]::Escape('../../../../../components/Tables/'), '../../../../components/Tables/'
        $content = $content -replace [regex]::Escape('../../../../../assets/'), '../../../../assets/'
        
        # Also fix the extreme ones with 7 levels
        $content = $content -replace [regex]::Escape('../../../../../../components/Button/ButtonLogic'), '../../../../components/Button/ButtonLogic'
        $content = $content -replace [regex]::Escape('../../../../../../SyllabusLayout/SyllabusPageHeader'), '../../../../SyllabusLayout/SyllabusPageHeader'
        $content = $content -replace [regex]::Escape('../../../../../../utils/'), '../../../../utils/'
        $content = $content -replace [regex]::Escape('../../../../../../components/RedirectingModal/RedirectingModal'), '../../../../components/RedirectingModal/RedirectingModal'
        $content = $content -replace [regex]::Escape('../../../../../../components/SyllabusComponents/'), '../../../../components/SyllabusComponents/'
        $content = $content -replace [regex]::Escape('../../../../../../components/Tables/'), '../../../../components/Tables/'
        $content = $content -replace [regex]::Escape('../../../../../../assets/'), '../../../../assets/'
    }
    
    # Write back if changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "  Fixed overcorrected paths in $($file.Name)" -ForegroundColor Cyan
    } else {
        Write-Host "  No changes needed for $($file.Name)" -ForegroundColor Gray
    }
}

Write-Host "Overcorrected import path fixes complete!" -ForegroundColor Green