# PowerShell script to separate 4 issues into individual branches and push them

Write-Host "=== Separating 4 Issues into Individual Branches ===" -ForegroundColor Green

# Check if we're in the correct directory
if (-not (Test-Path "frontend/src/stellar.ts")) {
    Write-Host "Error: Please run this script from the PayFlow root directory" -ForegroundColor Red
    exit 1
}

# Stash any uncommitted changes
Write-Host "`nStashing current changes..." -ForegroundColor Yellow
git stash save "Backup before issue separation"

# Go to master
Write-Host "Switching to master branch..." -ForegroundColor Yellow
git checkout master

Write-Host "`n=== Issue #1: Pending Upgrade UI (Already Done) ===" -ForegroundColor Cyan
Write-Host "Branch 'feature/issue-1-pending-upgrade-ui' already exists with commit"
Write-Host "Pushing Issue #1..." -ForegroundColor Yellow
git checkout feature/issue-1-pending-upgrade-ui
git push -u origin feature/issue-1-pending-upgrade-ui
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Issue #1 pushed successfully!" -ForegroundColor Green
} else {
    Write-Host "✗ Issue #1 push failed. Please push manually." -ForegroundColor Red
}

Write-Host "`n=== Next Steps for Issues #2, #3, #4 ===" -ForegroundColor Cyan
Write-Host @"

The remaining issues (#2, #3, #4) have mixed changes in stellar.ts.
You need to manually separate them:

OPTION 1: Manual Separation (Recommended)
==========================================
1. For each issue, create a new branch from master
2. Manually add only the relevant functions to stellar.ts
3. Add the respective component changes
4. Commit and push

OPTION 2: Sequential PRs
========================
Create PRs that build on each other:
- Issue #2 PR: depends on Issue #1
- Issue #3 PR: depends on Issue #2
- Issue #4 PR: depends on Issue #3

Then merge them in sequence.

FILES BY ISSUE:
===============

Issue #2 (Contract Config):
- frontend/src/stellar.ts: getContractConfig(), ContractConfig interface
- frontend/src/components/admin/ProtocolStatsPanel.tsx

Issue #3 (Merchant Freeze):
- frontend/src/stellar.ts: getMerchantFreezeReason(), buildFreezeMerchantTx(), buildUnfreezeMerchantTx()
- frontend/src/components/admin/MerchantFreezePanel.tsx
- frontend/src/components/SubscribeForm.tsx  
- frontend/src/pages/AdminDashboard.tsx

Issue #4 (Revenue Withdrawal):
- frontend/src/stellar.ts: buildWithdrawMerchantRevenueTx()
- frontend/src/components/MerchantDashboard.tsx

"@

Write-Host "`nWould you like to continue with creating the remaining branches? (Y/N)" -ForegroundColor Yellow
$response = Read-Host

if ($response -eq 'Y' -or $response -eq 'y') {
    Write-Host "`nCreating remaining branches from master..." -ForegroundColor Yellow
    
    git checkout master
    
    # Create Issue #2 branch
    Write-Host "`nCreating branch for Issue #2..." -ForegroundColor Yellow
    git checkout -b feature/issue-2-contract-config-display
    Write-Host "Branch 'feature/issue-2-contract-config-display' created" -ForegroundColor Green
    Write-Host "Please manually add Issue #2 changes, then run:" -ForegroundColor Yellow
    Write-Host "  git add <files>" -ForegroundColor Cyan
    Write-Host "  git commit -m 'feat: Add contract config display'"  -ForegroundColor Cyan
    Write-Host "  git push -u origin feature/issue-2-contract-config-display" -ForegroundColor Cyan
    
    # Back to master
    git checkout master
    
    # Create Issue #3 branch
    Write-Host "`nCreating branch for Issue #3..." -ForegroundColor Yellow
    git checkout -b feature/issue-3-merchant-freeze-reason
    Write-Host "Branch 'feature/issue-3-merchant-freeze-reason' created" -ForegroundColor Green
    Write-Host "Please manually add Issue #3 changes, then run:" -ForegroundColor Yellow
    Write-Host "  git add <files>" -ForegroundColor Cyan
    Write-Host "  git commit -m 'feat: Add merchant freeze reason management'" -ForegroundColor Cyan
    Write-Host "  git push -u origin feature/issue-3-merchant-freeze-reason" -ForegroundColor Cyan
    
    # Back to master
    git checkout master
    
    # Create Issue #4 branch
    Write-Host "`nCreating branch for Issue #4..." -ForegroundColor Yellow
    git checkout -b feature/issue-4-merchant-revenue-withdrawal
    Write-Host "Branch 'feature/issue-4-merchant-revenue-withdrawal' created" -ForegroundColor Green
    Write-Host "Please manually add Issue #4 changes, then run:" -ForegroundColor Yellow
    Write-Host "  git add <files>" -ForegroundColor Cyan
    Write-Host "  git commit -m 'feat: Add merchant revenue withdrawal'" -ForegroundColor Cyan
    Write-Host "  git push -u origin feature/issue-4-merchant-revenue-withdrawal" -ForegroundColor Cyan
    
    git checkout master
    
    Write-Host "`n=== All branches created! ===" -ForegroundColor Green
    Write-Host "Next: Manually add changes to each branch and push" -ForegroundColor Yellow
}

Write-Host "`nDone! Check GIT_PUSH_INSTRUCTIONS.md for detailed guidance." -ForegroundColor Green
