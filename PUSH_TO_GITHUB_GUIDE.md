# Complete Guide: Push 4 Issues Separately to GitHub

## Current Situation

✅ All 4 issues have been implemented and tested
✅ Issue #1 has been committed to branch `feature/issue-1-pending-upgrade-ui`
⚠️ Issues #2, #3, #4 need to be separated into individual branches

## Quick Start

### Option 1: Automated (Recommended)

Run the PowerShell script:

```powershell
cd C:\Users\TOSHIBA\Desktop\PayFlow
.\separate-issues.ps1
```

This will:
1. Push Issue #1 automatically
2. Create empty branches for Issues #2, #3, #4
3. Guide you through manual separation

### Option 2: Manual Step-by-Step

Follow the detailed instructions below.

---

## Detailed Manual Instructions

### Step 1: Push Issue #1 ✅ (Ready to go!)

```bash
cd C:\Users\TOSHIBA\Desktop\PayFlow
git checkout feature/issue-1-pending-upgrade-ui
git push -u origin feature/issue-1-pending-upgrade-ui
```

**Create PR:**
1. Go to https://github.com/SiLioLabs/PayFlow/pulls
2. Click "New Pull Request"
3. Base: `master`, Compare: `feature/issue-1-pending-upgrade-ui`
4. Title: `feat: Add pending upgrade UI for contract WASM management`
5. Description:
```markdown
## Issue #1: Pending Upgrade Display

### Changes
- ✅ Add `PendingUpgradePanel.tsx` component
- ✅ Implement `getPendingUpgrade()` to read pending WASM hash
- ✅ Add `buildProposeUpgradeTx()`, `buildCancelPendingUpgradeTx()`, `buildCommitUpgradeTx()`
- ✅ Commit requires typing first 8 characters of hash for confirmation
- ✅ Integrate panel into AdminDashboard

### Testing
- [ ] Propose upgrade with valid 64-char hex hash
- [ ] Test commit with correct hash prefix
- [ ] Test cancel functionality
```

---

### Step 2: Prepare Issue #2 (Contract Config)

```bash
git checkout master
git checkout -b feature/issue-2-contract-config-display
```

**Add ONLY these changes to stellar.ts:**

```typescript
// Add after getReferrer function (around line 1713)

// ── Issue #2: Contract Config ─────────────────────────────────────────────────

export interface ContractConfig {
  feeBps: number;
  feeCollector: string | null;
  gracePeriod: bigint;
  minInterval: bigint;
  maxBatchSize: number;
  globalVolumeCap: bigint;
  whitelistEnabled: boolean;
  paused: boolean;
  schemaVersion: number;
}

export function getContractConfig(caller: string): Promise<ContractConfig | null> {
  return dedupedCall(`getContractConfig:${caller}`, async () => {
    try {
      const retval = await simulateContractRead(caller, "get_contract_config", []);
      if (!retval || retval.switch().name === "scvVoid") return null;

      return ScValDecoder.decodeStruct<ContractConfig>(retval, {
        feeBps: decodeU32,
        feeCollector: (v) => ScValDecoder.decodeOption(v, ScValDecoder.decodeAddress),
        gracePeriod: (v) => ScValDecoder.decodeU64(v),
        minInterval: (v) => ScValDecoder.decodeU64(v),
        maxBatchSize: decodeU32,
        globalVolumeCap: (v) => ScValDecoder.decodeI128(v),
        whitelistEnabled: ScValDecoder.decodeBool,
        paused: ScValDecoder.decodeBool,
        schemaVersion: decodeU32,
      });
    } catch {
      return null;
    }
  });
}
```

**Update ProtocolStatsPanel.tsx:**
- Import `getContractConfig` and `ContractConfig`
- Add `config` state variable
- Fetch config in the refresh function
- Display config fields with units

```bash
git add frontend/src/stellar.ts frontend/src/components/admin/ProtocolStatsPanel.tsx
git commit -m "feat: Add contract configuration display in single RPC call

- Add getContractConfig() to fetch all config in one call
- Add ContractConfig interface with all config fields
- Update ProtocolStatsPanel to display config with proper units
- Shows fee (bps), grace period (s), min interval (s), max batch size, volume cap
- Replaces multiple separate RPC reads with single call
- Resolves Issue #2"

git push -u origin feature/issue-2-contract-config-display
```

---

### Step 3: Prepare Issue #3 (Merchant Freeze)

```bash
git checkout master
git checkout -b feature/issue-3-merchant-freeze-reason
```

**Add these files:**

1. **stellar.ts** - Add merchant freeze functions:
```typescript
// ── Issue #3: Merchant Freeze with Reason ─────────────────────────────────────

export function getMerchantFreezeReason(
  caller: string,
  merchant: string
): Promise<string | null> {
  return dedupedCall(`getMerchantFreezeReason:${merchant}`, async () => {
    try {
      const retval = await simulateContractRead(caller, "get_merchant_freeze_reason", [
        addressVal(merchant),
      ]);
      if (!retval || retval.switch().name === "scvVoid") return null;

      return ScValDecoder.decodeOption(retval, ScValDecoder.decodeString);
    } catch {
      return null;
    }
  });
}

export async function buildFreezeMerchantTx(
  adminPublicKey: string,
  merchant: string,
  reason: string | null
): Promise<string> {
  if (reason && new TextEncoder().encode(reason).length > 128) {
    throw new Error("Freeze reason must be 128 bytes or fewer (error code 47)");
  }

  const reasonVal = reason
    ? { tag: "Some", val: nativeToScVal(reason, { type: "string" }) }
    : { tag: "None" };

  return buildTx(adminPublicKey, "freeze_merchant", [
    addressVal(merchant),
    nativeToScVal(reasonVal, { type: "option" }),
  ]);
}

export async function buildUnfreezeMerchantTx(
  adminPublicKey: string,
  merchant: string
): Promise<string> {
  return buildTx(adminPublicKey, "unfreeze_merchant", [addressVal(merchant)]);
}
```

2. Copy `MerchantFreezePanel.tsx` from backup
3. Update `SubscribeForm.tsx` - Add freeze checking
4. Update `AdminDashboard.tsx` - Import and add MerchantFreezePanel

```bash
git add frontend/src/stellar.ts frontend/src/components/admin/MerchantFreezePanel.tsx frontend/src/components/SubscribeForm.tsx frontend/src/pages/AdminDashboard.tsx

git commit -m "feat: Add merchant freeze reason display and management

- Add getMerchantFreezeReason() to read freeze reason from contract
- Add buildFreezeMerchantTx() and buildUnfreezeMerchantTx() for admin controls
- Create MerchantFreezePanel component for admin freeze management
- Update SubscribeForm to check and display freeze status automatically
- Show freeze warning banner when merchant address is entered
- Handle MerchantFrozen error (code 22) with reason display
- Client-side validation for 128-byte reason limit (prevents error code 47)
- Add admin panel to check freeze reason for any merchant
- Resolves Issue #3"

git push -u origin feature/issue-3-merchant-freeze-reason
```

---

### Step 4: Prepare Issue #4 (Revenue Withdrawal)

```bash
git checkout master
git checkout -b feature/issue-4-merchant-revenue-withdrawal
```

**Add to stellar.ts:**

```typescript
// ── Issue #4: Withdraw Merchant Revenue ───────────────────────────────────────

export async function buildWithdrawMerchantRevenueTx(merchantPublicKey: string): Promise<string> {
  return buildTx(merchantPublicKey, "withdraw_merchant_revenue", [addressVal(merchantPublicKey)]);
}
```

**Update MerchantDashboard.tsx:**
- Import `buildWithdrawMerchantRevenueTx` and `friendlyError`
- Add withdraw button to revenue card
- Add withdrawal modal with confirmation
- Handle zero balance case

```bash
git add frontend/src/stellar.ts frontend/src/components/MerchantDashboard.tsx

git commit -m "feat: Add merchant revenue withdrawal from dashboard

- Add buildWithdrawMerchantRevenueTx() function for merchant revenue withdrawal
- Add withdraw button to MerchantDashboard revenue card
- Add confirmation modal with balance preview before withdrawal
- Handle ZeroBalanceAvailable error (code 21) gracefully
- Disable button when balance is zero with explanatory tooltip
- Refresh balance automatically after successful withdrawal
- Respect contract pause state
- Resolves Issue #4"

git push -u origin feature/issue-4-merchant-revenue-withdrawal
```

---

## After Pushing All Branches

### Create 4 Pull Requests

For each branch, create a PR:

1. **Issue #1 PR:**
   - Title: `feat: Add pending upgrade UI for contract WASM management`
   - Base: `master` ← Compare: `feature/issue-1-pending-upgrade-ui`

2. **Issue #2 PR:**
   - Title: `feat: Add contract configuration display in single RPC call`
   - Base: `master` ← Compare: `feature/issue-2-contract-config-display`

3. **Issue #3 PR:**
   - Title: `feat: Add merchant freeze reason display and management`
   - Base: `master` ← Compare: `feature/issue-3-merchant-freeze-reason`

4. **Issue #4 PR:**
   - Title: `feat: Add merchant revenue withdrawal from dashboard`
   - Base: `master` ← Compare: `feature/issue-4-merchant-revenue-withdrawal`

### PR Template

```markdown
## Changes
- List main changes here

## Testing
- [ ] Test case 1
- [ ] Test case 2

## Screenshots
(if applicable)

## Related Issues
Resolves #[issue-number]
```

---

## Troubleshooting

### Problem: stellar.ts has all issues mixed together

**Solution:** Manually separate by copying only the relevant functions for each issue.

### Problem: Can't push due to conflicts

**Solution:** 
```bash
git pull origin master
git rebase master
# Fix any conflicts
git push -u origin <branch-name>
```

### Problem: Forgot to add a file

**Solution:**
```bash
git add <forgotten-file>
git commit --amend --no-edit
git push -f origin <branch-name>
```

---

## Summary of What to Push

| Issue | Branch Name | Files Changed | Status |
|-------|-------------|---------------|--------|
| #1 | `feature/issue-1-pending-upgrade-ui` | PendingUpgradePanel.tsx, stellar.ts, AdminDashboard.tsx | ✅ Ready |
| #2 | `feature/issue-2-contract-config-display` | stellar.ts, ProtocolStatsPanel.tsx | ⚠️ Manual |
| #3 | `feature/issue-3-merchant-freeze-reason` | stellar.ts, MerchantFreezePanel.tsx, SubscribeForm.tsx, AdminDashboard.tsx | ⚠️ Manual |
| #4 | `feature/issue-4-merchant-revenue-withdrawal` | stellar.ts, MerchantDashboard.tsx | ⚠️ Manual |

---

## Need Help?

Check these files:
- `GIT_PUSH_INSTRUCTIONS.md` - Alternative instructions
- `IMPLEMENTATION_SUMMARY.md` - What was implemented
- `IMPLEMENTATION_CHECKLIST.md` - Detailed checklist
- `docs/NEW_FRONTEND_APIS.md` - API documentation

Good luck! 🚀
