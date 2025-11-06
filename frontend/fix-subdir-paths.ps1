# PowerShell script to fix remaining import path issues in SyllabusView subdirectories
$baseDir = "src/components/screens/CoursePage/SyllabusView"

# Files in subdirectories need 5 levels (../../../../../) to reach src root
$subdirFiles = @(
    "Learning Outcomes/LearningOutcomesNew.tsx",
    "Learning Outcomes/LearningOutcomesAccordionStep4.tsx", 
    "Learning Resources/LearningResources.tsx",
    "Overview/Overview.tsx",
    "Overview/OverviewCard.tsx"
)

foreach ($file in $subdirFiles) {
    $fullPath = Join-Path $baseDir $file
    if (Test-Path $fullPath) {
        Write-Host "Processing: $file"
        
        $content = Get-Content -Path $fullPath -Raw
        $originalContent = $content
        
        # Fix import paths from 4 levels to 5 levels for subdirectory files
        $content = $content -replace '"\.\./\.\./\.\./\.\./components/', '"../../../../../components/'
        $content = $content -replace '"\.\./\.\./\.\./\.\./utils/', '"../../../../../utils/'
        $content = $content -replace '"\.\./\.\./\.\./\.\./SyllabusLayout/', '"../../../../../SyllabusLayout/'
        $content = $content -replace '"\.\./\.\./\.\./\.\./assets/', '"../../../../../assets/'
        
        if ($content -ne $originalContent) {
            Set-Content -Path $fullPath -Value $content -NoNewline
            Write-Host "  ✓ Updated: $file"
        } else {
            Write-Host "  - No changes needed: $file"
        }
    } else {
        Write-Host "  ⚠ File not found: $file"
    }
}

Write-Host "Import path fixing complete!"