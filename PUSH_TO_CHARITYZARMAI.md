# Push 4 Issues to charityzarmai/PayFlow

## Setup (Already Done ✓)

```bash
git remote add charityzarmai https://github.com/charityzarmai/PayFlow.git
```

## Push Issue #1 (Ready Now!)

```bash
git checkout feature/issue-1-pending-upgrade-ui
git push -u charityzarmai feature/issue-1-pending-upgrade-ui
```

**Then create PR at:** https://github.com/charityzarmai/PayFlow/compare/master...feature/issue-1-pending-upgrade-ui

---

## For Issues #2, #3, #4

Since the code for these issues is mixed in the files, you have **3 options**:

### Option 1: Push All Together (Easiest - 5 minutes)

Push the current branch with all changes:

```bash
git checkout master
git checkout -b feature/all-4-issues
git add -A
git commit -m "feat: Add 4 missing frontend features

- Issue #1: Pending upgrade UI
- Issue #2: Contract config display
- Issue #3: Merchant freeze reason
- Issue #4: Revenue withdrawal"
git push -u charityzarmai feature/all-4-issues
```

Then create **1 PR** with all 4 issues, or **4 PRs** from the same branch with different focus.

### Option 2: Sequential PRs (Medium - 20 minutes)

Create branches that build on each other:

```bash
# Issue #2 (builds on Issue #1)
git checkout feature/issue-1-pending-upgrade-ui
git checkout -b feature/issue-2-contract-config-display

# Add Issue #2 code (see below)
git add frontend/src/stellar.ts frontend/src/components/admin/ProtocolStatsPanel.tsx
git commit -m "feat: Add contract config display"
git push -u charityzarmai feature/issue-2-contract-config-display

# Issue #3 (builds on Issue #2)
git checkout -b feature/issue-3-merchant-freeze-reason

# Add Issue #3 code (see below)
git add <files>
git commit -m "feat: Add merchant freeze reason"
git push -u charityzarmai feature/issue-3-merchant-freeze-reason

# Issue #4 (builds on Issue #3)
git checkout -b feature/issue-4-merchant-revenue-withdrawal

# Add Issue #4 code (see below)
git add <files>
git commit -m "feat: Add revenue withdrawal"
git push -u charityzarmai feature/issue-4-merchant-revenue-withdrawal
```

### Option 3: Separate from Master (Best - 45 minutes)

Manually separate each issue. See `PUSH_TO_GITHUB_GUIDE.md` for detailed code.

---

## Code to Add for Each Issue

### Issue #2: Contract Config (2 files)

**frontend/src/stellar.ts** - Add after getReferrer():
```typescript
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

**frontend/src/components/admin/ProtocolStatsPanel.tsx** - See the backup or git diff.

### Issue #3: Merchant Freeze (4 files)

**Copy these files:**
- `frontend/src/components/admin/MerchantFreezePanel.tsx` (already exists)
- Update `frontend/src/stellar.ts` (add 3 functions)
- Update `frontend/src/components/SubscribeForm.tsx` (add freeze checking)
- Update `frontend/src/pages/AdminDashboard.tsx` (import panel)

### Issue #4: Revenue Withdrawal (2 files)

**frontend/src/stellar.ts** - Add at end:
```typescript
export async function buildWithdrawMerchantRevenueTx(merchantPublicKey: string): Promise<string> {
  return buildTx(merchantPublicKey, "withdraw_merchant_revenue", [addressVal(merchantPublicKey)]);
}
```

**frontend/src/components/MerchantDashboard.tsx** - See git diff or backup.

---

## Quick Commands for Each Approach

### Approach 1: All Together
```bash
git checkout -b feature/all-4-issues
git add -A
git commit -m "feat: Add 4 missing frontend features"
git push -u charityzarmai feature/all-4-issues
```

### Approach 2: Sequential (After Issue #1 is pushed)
```bash
# Start from Issue #1
git checkout feature/issue-1-pending-upgrade-ui

# Add Issue #2
git checkout -b feature/issue-2-contract-config-display
# Add code, commit, push

# Add Issue #3
git checkout -b feature/issue-3-merchant-freeze-reason
# Add code, commit, push

# Add Issue #4
git checkout -b feature/issue-4-merchant-revenue-withdrawal
# Add code, commit, push
```

---

## After Pushing

Create PRs at: **https://github.com/charityzarmai/PayFlow/pulls**

**PR Titles:**
1. `feat: Add pending upgrade UI for contract WASM management`
2. `feat: Add contract configuration display in single RPC call`
3. `feat: Add merchant freeze reason display and management`
4. `feat: Add merchant revenue withdrawal from dashboard`

---

## Recommended Approach

**For quickest results:**

1. ✅ Push Issue #1 (already committed, just push)
2. Use **Approach 1** (all together) or **Approach 2** (sequential)
3. Create PRs and mention they're related

**For cleanest git history:**

1. Use **Approach 3** (manual separation)
2. See `PUSH_TO_GITHUB_GUIDE.md` for full code

---

## Check Push Status

```bash
git branch -vv
```

Look for branches tracking `charityzarmai/feature-*`

---

## If Push Hangs or Fails

```bash
# Cancel with Ctrl+C, then:
git push charityzarmai feature/issue-1-pending-upgrade-ui --force

# Or try with verbose output:
GIT_CURL_VERBOSE=1 git push -u charityzarmai feature/issue-1-pending-upgrade-ui
```

---

## Repository URLs

- **Your GitHub**: https://github.com/charityzarmai/PayFlow
- **Original**: https://github.com/SiLioLabs/PayFlow

Both remotes are configured, so you can push to both if needed.

---

**Start with:** 
```bash
git push -u charityzarmai feature/issue-1-pending-upgrade-ui
```

Then decide on approach for Issues #2-4! 🚀
