# Instructions to Push 4 Issues Separately to GitHub

All 4 issues have been implemented. I've created the first branch and commit for Issue #1. Here's how to push all 4 issues as separate PRs:

## Current Status

✅ **Issue #1 Branch Created**: `feature/issue-1-pending-upgrade-ui` 
- Committed with all pending upgrade UI changes
- Ready to push

## Step-by-Step Instructions

### 1. Push Issue #1 (Already committed)

```bash
cd C:\Users\TOSHIBA\Desktop\PayFlow
git push -u origin feature/issue-1-pending-upgrade-ui
```

Then create PR on GitHub from `feature/issue-1-pending-upgrade-ui` to `master`.

---

### 2. Create and Push Issue #2 (Contract Config Display)

```bash
# Go back to master
git checkout master

# Create new branch
git checkout -b feature/issue-2-contract-config-display

# Add only Issue #2 files
git add frontend/src/stellar.ts frontend/src/components/admin/ProtocolStatsPanel.tsx

# Manual step: Edit stellar.ts to add ONLY Issue #2 code (lines for getContractConfig and ContractConfig interface)
# Manual step: Edit ProtocolStatsPanel.tsx to add config fetch and display

# Commit
git commit -m "feat: Add contract configuration display in single RPC call

- Add getContractConfig() to fetch all config in one call
- Add ContractConfig interface
- Update ProtocolStatsPanel to display config with proper units
- Shows fee (bps), grace period (s), min interval (s), batch size, volume cap
- Resolves Issue #2"

# Push
git push -u origin feature/issue-2-contract-config-display
```

---

### 3. Create and Push Issue #3 (Merchant Freeze Reason)

```bash
# Go back to master
git checkout master

# Create new branch
git checkout -b feature/issue-3-merchant-freeze-reason

# Add Issue #3 files
git add frontend/src/stellar.ts frontend/src/components/SubscribeForm.tsx frontend/src/components/admin/MerchantFreezePanel.tsx frontend/src/pages/AdminDashboard.tsx

# Manual step: Edit stellar.ts to add ONLY Issue #3 functions
# Manual step: Ensure SubscribeForm has freeze checking code
# Manual step: Ensure MerchantFreezePanel exists
# Manual step: Ensure AdminDashboard imports MerchantFreezePanel

# Commit
git commit -m "feat: Add merchant freeze reason display and management

- Add getMerchantFreezeReason() to read freeze reason
- Add buildFreezeMerchantTx() and buildUnfreezeMerchantTx()
- Create MerchantFreezePanel for admin controls
- Update SubscribeForm to check and display freeze status
- Client-side validation for 128-byte reason limit
- Resolves Issue #3"

# Push
git push -u origin feature/issue-3-merchant-freeze-reason
```

---

### 4. Create and Push Issue #4 (Merchant Revenue Withdrawal)

```bash
# Go back to master
git checkout master

# Create new branch
git checkout -b feature/issue-4-merchant-revenue-withdrawal

# Add Issue #4 files
git add frontend/src/stellar.ts frontend/src/components/MerchantDashboard.tsx

# Manual step: Edit stellar.ts to add ONLY buildWithdrawMerchantRevenueTx()
# Manual step: Ensure MerchantDashboard has withdraw button and modal

# Commit
git commit -m "feat: Add merchant revenue withdrawal from dashboard

- Add buildWithdrawMerchantRevenueTx() function
- Add withdraw button to MerchantDashboard
- Add confirmation modal with balance preview
- Handle ZeroBalanceAvailable error (code 21)
- Button disabled when balance is zero
- Resolves Issue #4"

# Push
git push -u origin feature/issue-4-merchant-revenue-withdrawal
```

---

## Alternative: Easier Approach Using Stash

Since all files are already modified with all 4 issues, here's an easier approach:

### Current State
You're on branch `feature/issue-1-pending-upgrade-ui` with Issue #1 committed.

### For Issues #2, #3, #4:

```bash
# Go to master
git checkout master

# Restore all your changes
git checkout feature/issue-1-pending-upgrade-ui -- frontend/src/stellar.ts.backup
mv frontend/src/stellar.ts.backup frontend/src/stellar-all-issues.ts

# Now manually create each branch and cherry-pick only the relevant changes
```

---

## Files Modified by Each Issue

### Issue #1: Pending Upgrade UI
- ✅ `frontend/src/components/admin/PendingUpgradePanel.tsx` (new file)
- ✅ `frontend/src/stellar.ts` (add getPendingUpgrade + 3 build functions)
- ✅ `frontend/src/pages/AdminDashboard.tsx` (import and add PendingUpgradePanel)

### Issue #2: Contract Config
- `frontend/src/stellar.ts` (add getContractConfig + ContractConfig interface)
- `frontend/src/components/admin/ProtocolStatsPanel.tsx` (fetch and display config)

### Issue #3: Merchant Freeze
- `frontend/src/stellar.ts` (add getMerchantFreezeReason + 2 build functions)
- `frontend/src/components/admin/MerchantFreezePanel.tsx` (new file)
- `frontend/src/components/SubscribeForm.tsx` (check freeze status)
- `frontend/src/pages/AdminDashboard.tsx` (import and add MerchantFreezePanel)

### Issue #4: Revenue Withdrawal
- `frontend/src/stellar.ts` (add buildWithdrawMerchantRevenueTx)
- `frontend/src/components/MerchantDashboard.tsx` (add withdraw button and modal)

---

## Recommended Approach

Since the changes are already mixed in stellar.ts, I recommend:

1. ✅ **Issue #1 is done** - just run: `git push -u origin feature/issue-1-pending-upgrade-ui`

2. For Issues #2, #3, #4, **manually separate the code**:
   - Check out master
   - Create new branch for each issue
   - Manually add only the relevant code sections to stellar.ts
   - Add the respective component changes
   - Commit and push

Or alternatively, **create all 4 PRs and mention in the PR description that they build on each other**, then merge them in order.

---

## Quick Commands Summary

```bash
# Issue #1 (DONE - just push)
git checkout feature/issue-1-pending-upgrade-ui
git push -u origin feature/issue-1-pending-upgrade-ui

# Issues #2, #3, #4 - need manual separation
# See detailed instructions above
```

---

## After Pushing

Create PRs on GitHub:
1. Go to https://github.com/SiLioLabs/PayFlow/pulls
2. Click "New Pull Request"
3. Select your branch as source, master as target
4. Fill in PR details referencing the issue number
5. Request review

Let me know if you need help with any specific step!
