# PowerShell script to push all 4 issues to charityzarmai GitHub

Write-Host "=== Pushing 4 Issues to charityzarmai/PayFlow ===" -ForegroundColor Green

# Check if charityzarmai remote exists
$remotes = git remote
if ($remotes -notcontains "charityzarmai") {
    Write-Host "Adding charityzarmai remote..." -ForegroundColor Yellow
    git remote add charityzarmai https://github.com/charityzarmai/PayFlow.git
    Write-Host "✓ Remote added" -ForegroundColor Green
} else {
    Write-Host "✓ charityzarmai remote already exists" -ForegroundColor Green
}

Write-Host "`n=== Issue #1: Pending Upgrade UI ===" -ForegroundColor Cyan
Write-Host "Pushing feature/issue-1-pending-upgrade-ui..." -ForegroundColor Yellow

git checkout feature/issue-1-pending-upgrade-ui
if ($LASTEXITCODE -eq 0) {
    git push -u charityzarmai feature/issue-1-pending-upgrade-ui
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Issue #1 pushed successfully!" -ForegroundColor Green
        Write-Host "Create PR at: https://github.com/charityzarmai/PayFlow/compare/master...feature/issue-1-pending-upgrade-ui" -ForegroundColor Cyan
    } else {
        Write-Host "✗ Issue #1 push failed" -ForegroundColor Red
    }
} else {
    Write-Host "✗ Failed to checkout branch" -ForegroundColor Red
}

Write-Host "`n=== Issue #2: Contract Config Display ===" -ForegroundColor Cyan
Write-Host "Creating and pushing feature/issue-2-contract-config-display..." -ForegroundColor Yellow

git checkout master
git checkout -b feature/issue-2-contract-config-display 2>$null

if ($LASTEXITCODE -eq 0 -or $?) {
    Write-Host "Branch created. Now you need to:" -ForegroundColor Yellow
    Write-Host "1. Add only Issue #2 code to stellar.ts and ProtocolStatsPanel.tsx" -ForegroundColor Cyan
    Write-Host "2. Run: git add <files>" -ForegroundColor Cyan
    Write-Host "3. Run: git commit -m 'feat: Add contract config display'" -ForegroundColor Cyan
    Write-Host "4. Run: git push -u charityzarmai feature/issue-2-contract-config-display" -ForegroundColor Cyan
} else {
    Write-Host "Branch already exists or error occurred" -ForegroundColor Yellow
}

Write-Host "`n=== Issue #3: Merchant Freeze Reason ===" -ForegroundColor Cyan
Write-Host "Creating and pushing feature/issue-3-merchant-freeze-reason..." -ForegroundColor Yellow

git checkout master
git checkout -b feature/issue-3-merchant-freeze-reason 2>$null

if ($LASTEXITCODE -eq 0 -or $?) {
    Write-Host "Branch created. Now you need to:" -ForegroundColor Yellow
    Write-Host "1. Add only Issue #3 code to relevant files" -ForegroundColor Cyan
    Write-Host "2. Run: git add <files>" -ForegroundColor Cyan
    Write-Host "3. Run: git commit -m 'feat: Add merchant freeze reason'" -ForegroundColor Cyan
    Write-Host "4. Run: git push -u charityzarmai feature/issue-3-merchant-freeze-reason" -ForegroundColor Cyan
} else {
    Write-Host "Branch already exists or error occurred" -ForegroundColor Yellow
}

Write-Host "`n=== Issue #4: Merchant Revenue Withdrawal ===" -ForegroundColor Cyan
Write-Host "Creating and pushing feature/issue-4-merchant-revenue-withdrawal..." -ForegroundColor Yellow

git checkout master
git checkout -b feature/issue-4-merchant-revenue-withdrawal 2>$null

if ($LASTEXITCODE -eq 0 -or $?) {
    Write-Host "Branch created. Now you need to:" -ForegroundColor Yellow
    Write-Host "1. Add only Issue #4 code to stellar.ts and MerchantDashboard.tsx" -ForegroundColor Cyan
    Write-Host "2. Run: git add <files>" -ForegroundColor Cyan
    Write-Host "3. Run: git commit -m 'feat: Add merchant revenue withdrawal'" -ForegroundColor Cyan
    Write-Host "4. Run: git push -u charityzarmai feature/issue-4-merchant-revenue-withdrawal" -ForegroundColor Cyan
} else {
    Write-Host "Branch already exists or error occurred" -ForegroundColor Yellow
}

git checkout master

Write-Host "`n=== Summary ===" -ForegroundColor Green
Write-Host "Remote: charityzarmai (https://github.com/charityzarmai/PayFlow.git)" -ForegroundColor Cyan
Write-Host "`nBranches:" -ForegroundColor Yellow
Write-Host "  1. feature/issue-1-pending-upgrade-ui (should be pushed)" -ForegroundColor Cyan
Write-Host "  2. feature/issue-2-contract-config-display (needs manual code)" -ForegroundColor Cyan
Write-Host "  3. feature/issue-3-merchant-freeze-reason (needs manual code)" -ForegroundColor Cyan
Write-Host "  4. feature/issue-4-merchant-revenue-withdrawal (needs manual code)" -ForegroundColor Cyan

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Check if Issue #1 was pushed successfully" -ForegroundColor Cyan
Write-Host "2. For Issues #2-4, see PUSH_TO_GITHUB_GUIDE.md for exact code to add" -ForegroundColor Cyan
Write-Host "3. Create PRs at: https://github.com/charityzarmai/PayFlow/pulls" -ForegroundColor Cyan

Write-Host "`nDone!" -ForegroundColor Green
