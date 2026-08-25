$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot

$requiredFiles = @(
    'README.md',
    'AGENTS.md',
    'PROJECT_FACTS.md',
    'PROJECT_STORY.md',
    'ACCEPTANCE.md',
    'HANDOFF.md',
    'content\CONTENT_STRATEGY.md',
    'content\POST_LIBRARY.md',
    'content\PARENT_COMMUNICATION.md',
    'assets\ASSET_INVENTORY.md',
    'operations\PUBLISHING_CHECKLIST.md',
    'operations\LEAD_LOG_TEMPLATE.md'
)

$requiredAssets = @(
    'assets\profile\avatar.jpg',
    'assets\projects\cat-merge.png',
    'assets\projects\kacha-theatre.png',
    'assets\projects\birthday-wall.png',
    'assets\projects\immersive-reading.png',
    'assets\projects\everything-trading.png'
)

$missing = @()
foreach ($relativePath in $requiredFiles + $requiredAssets) {
    $fullPath = Join-Path $projectRoot $relativePath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        $missing += $relativePath
    }
}

if ($missing.Count -gt 0) {
    throw "Missing required project files: $($missing -join ', ')"
}

$publicContent = Get-ChildItem -LiteralPath (Join-Path $projectRoot 'content') -Filter '*.md' -File
foreach ($file in $publicContent) {
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    if ($text -match '(?i)Web Coding') {
        throw "Incorrect term found in public content: $($file.FullName)"
    }
}

$facts = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $projectRoot 'PROJECT_FACTS.md')
$requiredLinks = @(
    'https://vibe-coding-tutor.vercel.app/',
    'https://zjucatmerge.vercel.app/',
    'https://birthday-message-wall.vercel.app/',
    'https://imagineer-iota.vercel.app/'
)

foreach ($link in $requiredLinks) {
    if (-not $facts.Contains($link)) {
        throw "Canonical link missing from PROJECT_FACTS.md: $link"
    }
}

Write-Output 'Vibe Coding parent outreach validation passed.'
Write-Output "- required documents: $($requiredFiles.Count)"
Write-Output "- reusable assets: $($requiredAssets.Count)"
Write-Output "- canonical links checked: $($requiredLinks.Count)"
