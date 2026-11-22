# Quick Command Reference

## Push Issue #1 (Ready Now!)

```bash
git checkout feature/issue-1-pending-upgrade-ui
git push -u origin feature/issue-1-pending-upgrade-ui
```

**Then create PR at**: https://github.com/SiLioLabs/PayFlow/pulls

---

## Create Remaining Branches

### Issue #2: Contract Config

```bash
git checkout master
git checkout -b feature/issue-2-contract-config-display

# Manually add code (see PUSH_TO_GITHUB_GUIDE.md for exact code)

git add frontend/src/stellar.ts frontend/src/components/admin/ProtocolStatsPanel.tsx
git commit -m "feat: Add contract configuration display in single RPC call"
git push -u origin feature/issue-2-contract-config-display
```

### Issue #3: Merchant Freeze

```bash
git checkout master
git checkout -b feature/issue-3-merchant-freeze-reason

# Manually add code (see PUSH_TO_GITHUB_GUIDE.md for exact code)

git add frontend/src/stellar.ts frontend/src/components/admin/MerchantFreezePanel.tsx frontend/src/components/SubscribeForm.tsx frontend/src/pages/AdminDashboard.tsx
git commit -m "feat: Add merchant freeze reason display and management"
git push -u origin feature/issue-3-merchant-freeze-reason
```

### Issue #4: Revenue Withdrawal

```bash
git checkout master
git checkout -b feature/issue-4-merchant-revenue-withdrawal

# Manually add code (see PUSH_TO_GITHUB_GUIDE.md for exact code)

git add frontend/src/stellar.ts frontend/src/components/MerchantDashboard.tsx
git commit -m "feat: Add merchant revenue withdrawal from dashboard"
git push -u origin feature/issue-4-merchant-revenue-withdrawal
```

---

## Automation Script

```powershell
.\separate-issues.ps1
```

---

## Verify Branches

```bash
git branch -a
```

---

## Check Status

```bash
git status
```

---

## View Commit History

```bash
git log --oneline --graph --all
```

---

## If You Need to Start Over

```bash
# Back to master and reset
git checkout master
git reset --hard origin/master

# Delete local branches
git branch -D feature/issue-1-pending-upgrade-ui
git branch -D feature/issue-2-contract-config-display
git branch -D feature/issue-3-merchant-freeze-reason
git branch -D feature/issue-4-merchant-revenue-withdrawal
```

---

## After All Branches Are Pushed

Create PRs at: https://github.com/SiLioLabs/PayFlow/pulls

**PR Titles:**
1. `feat: Add pending upgrade UI for contract WASM management`
2. `feat: Add contract configuration display in single RPC call`
3. `feat: Add merchant freeze reason display and management`
4. `feat: Add merchant revenue withdrawal from dashboard`

---

## Troubleshooting

### Can't push?
```bash
git pull origin master --rebase
git push -u origin <branch-name>
```

### Wrong files added?
```bash
git reset HEAD <file>
git checkout -- <file>
```

### Need to amend commit?
```bash
git add <file>
git commit --amend --no-edit
git push -f origin <branch-name>
```
