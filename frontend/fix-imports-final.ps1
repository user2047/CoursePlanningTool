# Final script to fix import paths in components/screens/CoursePage/SyllabusView
$syllabusViewPath = "C:\Users\camer\OneDrive\Documents\Desktop\both\copy\CoursePlanningTool\frontend\src\components\screens\CoursePage\SyllabusView"

Write-Host "Fixing import paths in components/screens/CoursePage/SyllabusView (final fix)..." -ForegroundColor Green

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
        # Files directly in SyllabusView folder 
        # Need to go up 4 levels to reach src: ../../../../
        $content = $content -replace [regex]::Escape('../../components/Button/ButtonLogic'), '../../../../components/Button/ButtonLogic'
        $content = $content -replace [regex]::Escape('../../SyllabusLayout/SyllabusPageHeader'), '../../../../SyllabusLayout/SyllabusPageHeader'
        $content = $content -replace [regex]::Escape('../../utils/'), '../../../../utils/'
        $content = $content -replace [regex]::Escape('../../components/RedirectingModal/RedirectingModal'), '../../../../components/RedirectingModal/RedirectingModal'
        $content = $content -replace [regex]::Escape('../../components/SyllabusComponents/'), '../../../../components/SyllabusComponents/'
        $content = $content -replace [regex]::Escape('../../assets/'), '../../../../assets/'
    } else {
        # Files in subdirectories of SyllabusView
        # Need to go up 5 levels to reach src: ../../../../../
        $content = $content -replace [regex]::Escape('../../../components/Button/ButtonLogic'), '../../../../../components/Button/ButtonLogic'
        $content = $content -replace [regex]::Escape('../../../SyllabusLayout/SyllabusPageHeader'), '../../../../../SyllabusLayout/SyllabusPageHeader'
        $content = $content -replace [regex]::Escape('../../../utils/'), '../../../../../utils/'
        $content = $content -replace [regex]::Escape('../../../components/RedirectingModal/RedirectingModal'), '../../../../../components/RedirectingModal/RedirectingModal'
        $content = $content -replace [regex]::Escape('../../../components/SyllabusComponents/'), '../../../../../components/SyllabusComponents/'
        $content = $content -replace [regex]::Escape('../../../components/Tables/'), '../../../../../components/Tables/'
        $content = $content -replace [regex]::Escape('../../../assets/'), '../../../../../assets/'
    }
    
    # Write back if changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "  Updated imports in $($file.Name)" -ForegroundColor Cyan
    } else {
        Write-Host "  No changes needed for $($file.Name)" -ForegroundColor Gray
    }
}

Write-Host "Final import path fixes complete!" -ForegroundColor Green