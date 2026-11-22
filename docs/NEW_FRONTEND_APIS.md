# New Frontend API Functions

This document describes the new frontend API functions added to expose previously unused contract endpoints.

## Upgrade Management

### `getPendingUpgrade(caller: string): Promise<PendingUpgrade | null>`

Reads the pending WASM upgrade hash from contract temporary storage.

**Returns:**
```typescript
interface PendingUpgrade {
  wasmHash: string;  // 64-character hex string
  expiry: number | null;  // TTL info not directly available
}
```

**Returns `null` if:** No upgrade is queued or the proposal has expired (~24 hour TTL).

---

### `buildProposeUpgradeTx(adminPublicKey: string, wasmHash: string): Promise<string>`

Builds a transaction to propose a new WASM hash for upgrade.

**Parameters:**
- `adminPublicKey`: Admin wallet address
- `wasmHash`: 64-character hex string (32 bytes)

**Throws:** If hash is not exactly 64 hex characters.

**Authorization:** Admin-only (contract enforces).

---

### `buildCancelPendingUpgradeTx(adminPublicKey: string): Promise<string>`

Builds a transaction to cancel a pending upgrade proposal.

**Authorization:** Admin-only.

---

### `buildCommitUpgradeTx(adminPublicKey: string): Promise<string>`

Builds a transaction to commit a pending upgrade.

**Authorization:** Admin-only.

**UI Pattern:** Requires user to type the first 8 characters of the hash to confirm.

---

## Contract Configuration

### `getContractConfig(caller: string): Promise<ContractConfig | null>`

Reads the complete contract configuration in a single RPC call. Replaces multiple individual reads for fee, grace period, limits, etc.

**Returns:**
```typescript
interface ContractConfig {
  feeBps: number;
  feeCollector: string | null;
  gracePeriod: bigint;  // seconds
  minInterval: bigint;  // seconds
  maxBatchSize: number;
  globalVolumeCap: bigint;  // stroops
  whitelistEnabled: boolean;
  paused: boolean;
  schemaVersion: number;
}
```

**Performance:** Single RPC call vs 5+ separate calls.

---

## Merchant Freeze Management

### `getMerchantFreezeReason(caller: string, merchant: string): Promise<string | null>`

Reads the freeze reason for a merchant.

**Returns:**
- Freeze reason string if merchant is frozen
- `null` if merchant is not frozen

**Use Case:** Display to subscribers attempting to subscribe to frozen merchant.

---

### `buildFreezeMerchantTx(adminPublicKey: string, merchant: string, reason: string | null): Promise<string>`

Builds a transaction to freeze a merchant with an optional reason.

**Parameters:**
- `adminPublicKey`: Admin wallet address
- `merchant`: Merchant address to freeze
- `reason`: Optional reason string (max 128 bytes)

**Throws:** Client-side validation error if reason exceeds 128 bytes (prevents contract error code 47).

**Authorization:** Admin-only.

**Effect:** Blocks new subscriptions to this merchant. Existing subscriptions continue to work.

---

### `buildUnfreezeMerchantTx(adminPublicKey: string, merchant: string): Promise<string>`

Builds a transaction to unfreeze a merchant.

**Authorization:** Admin-only.

---

## Merchant Revenue

### `buildWithdrawMerchantRevenueTx(merchantPublicKey: string): Promise<string>`

Builds a transaction for a merchant to withdraw their accumulated revenue.

**Authorization:** Requires merchant authorization (merchant signs their own withdrawal).

**Fails with error code 21** (`ZeroBalanceAvailable`) if merchant has no revenue to withdraw.

**Effect:** Transfers accumulated revenue from contract to merchant wallet and resets balance to zero.

---

## Integration Examples

### Example 1: Display Pending Upgrade

```typescript
import { getPendingUpgrade } from '../stellar';

const pending = await getPendingUpgrade(userPublicKey);
if (pending) {
  console.log('Pending upgrade hash:', pending.wasmHash);
  console.log('First 8 chars:', pending.wasmHash.slice(0, 8));
}
```

### Example 2: Check Merchant Freeze Status

```typescript
import { getMerchantFreezeReason } from '../stellar';

const checkMerchant = async (merchantAddress: string) => {
  const reason = await getMerchantFreezeReason(userKey, merchantAddress);
  if (reason) {
    alert(`This merchant is frozen: ${reason}`);
    return false;
  }
  return true;
};
```

### Example 3: Withdraw Revenue

```typescript
import { buildWithdrawMerchantRevenueTx, getMerchantRevenue } from '../stellar';

const withdrawRevenue = async () => {
  const balance = await getMerchantRevenue(merchantKey);
  if (balance === 0n) {
    alert('No revenue available');
    return;
  }
  
  const xdr = await buildWithdrawMerchantRevenueTx(merchantKey);
  const hash = await signTransaction(xdr);
  console.log('Withdrawn! Transaction:', hash);
};
```

### Example 4: Use Contract Config

```typescript
import { getContractConfig } from '../stellar';

const config = await getContractConfig(userKey);
if (config) {
  console.log('Fee:', config.feeBps, 'bps');
  console.log('Grace period:', config.gracePeriod.toString(), 'seconds');
  console.log('Contract paused:', config.paused);
}
```

---

## Error Handling

All transaction builders may throw:
- Network errors (RPC unavailable)
- Validation errors (invalid addresses, out-of-range values)
- Simulation errors (insufficient resources, contract reverts)

Use `friendlyError()` from `utils/errors.ts` to display user-friendly messages:

```typescript
import { friendlyError } from '../utils/errors';

try {
  const xdr = await buildFreezeMerchantTx(adminKey, merchant, reason);
  const hash = await onSign(xdr);
} catch (err) {
  const msg = friendlyError(err instanceof Error ? err.message : String(err));
  alert(msg);  // Shows: "Freeze reason must be 128 bytes or fewer"
}
```

---

## Related Documentation

- Contract error codes: `frontend/src/utils/errors.ts`
- Contract source: `contract/src/lib.rs`
- Upgrade flow: `contract/src/upgrade.rs`
- Admin functions: `contract/src/admin.rs`
- Merchant freeze: `contract/src/whitelist.rs`
