# Complete Testing Guide - Step by Step

Follow these commands in order to test everything works correctly.

## Prerequisites Check

First, verify you have everything set up:

```bash
# 1. Check you're in the right directory
pwd
# Should show: /Users/giovannifulin/Documents/GitHub/loops-2025-onlyswaps-workshop

# 2. Check your .env file exists and has required variables
cat .env | grep -E "PRIVATE_KEY|MY_ADDRESS|BASE_RPC_URL|AVAX_RPC_URL|CONTRACT_ADDRESS"
```

## Step 1: Build the Smart Contract

```bash
# Build the Solidity contract
forge build
```

**Expected output:** `Compiler run successful!`

## Step 2: Install TypeScript Dependencies

```bash
# Install Node.js dependencies for TypeScript scripts
npm install
```

**Expected output:** Should show packages installed without errors

## Step 3: Load Environment Variables

```bash
# Load your environment variables
source .env

# Verify they're loaded
echo "Private Key: ${PRIVATE_KEY:0:10}..."
echo "My Address: $MY_ADDRESS"
echo "Base RPC: $BASE_RPC_URL"
echo "Contract: $CONTRACT_ADDRESS"
```

## Step 4: Deploy the Contract (If Not Already Deployed)

**Skip this if you already have a deployed contract!**

```bash
# Deploy the contract to Base Sepolia
forge create src/MyContract.sol:MyContract \
  --rpc-url $BASE_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --constructor-args $MY_ADDRESS

# After deployment, export the contract address
# (Replace with your actual deployed address)
export CONTRACT_ADDRESS=0xYourDeployedContractAddress

# Verify the contract exists on-chain
cast code $CONTRACT_ADDRESS --rpc-url $BASE_RPC_URL
```

**Expected output:** Should show a long hex string (not just `0x`)

## Step 5: Test TypeScript Scripts - Check Status

```bash
# Test the check-status script
npm run check-status
```

**Expected output:**
- Should show your request ID
- Should show whether swap has finished executing
- Should display swap details (amounts, fees, timestamps)

## Step 6: Test TypeScript Scripts - Check Balances

```bash
# Test the check-balances script
npm run check-balances
```

**Expected output:**
- Contract balance on Base Sepolia
- Solver balance on Base Sepolia
- Contract balance on Avalanche Fuji
- Should show if tokens were received

## Step 7: Execute a New Swap (Optional)

**⚠️ Note:** Only run this if you want to execute a NEW swap. The faucet has a 24-hour cooldown!

```bash
# Execute a new swap via TypeScript
npm run execute-swap
```

**Expected output:**
- Transaction hash
- Request ID
- Gas used
- Confirmation that swap was initiated

## Step 8: Verify with Cast Commands (Alternative)

Test the same operations using `cast` commands:

```bash
# Check if swap has finished executing
cast call $CONTRACT_ADDRESS "hasFinishedExecuting()" --rpc-url $BASE_RPC_URL

# Expected: 0x0000000000000000000000000000000000000000000000000000000000000001 (true)
# or 0x0000000000000000000000000000000000000000000000000000000000000000 (false)

# Get the last request ID
cast call $CONTRACT_ADDRESS "lastRequestId()" --rpc-url $BASE_RPC_URL

# Check contract balance on destination chain (Avalanche Fuji)
cast call $RUSD_ADDRESS "balanceOf(address)" $CONTRACT_ADDRESS --rpc-url $AVAX_RPC_URL | cast to-dec

# Check solver balance on source chain (Base Sepolia)
cast call $RUSD_ADDRESS "balanceOf(address)" 0xeBF1B841eFF6D50d87d4022372Bc1191E781aB68 --rpc-url $BASE_RPC_URL | cast to-dec
```

## Step 9: Compare Results

Both TypeScript scripts and cast commands should show the same data:

```bash
# Run both and compare
echo "=== TypeScript Script ==="
npm run check-status

echo -e "\n=== Cast Command ==="
cast call $CONTRACT_ADDRESS "hasFinishedExecuting()" --rpc-url $BASE_RPC_URL
```

## Complete Test Sequence (Copy-Paste All at Once)

Here's a complete sequence you can run:

```bash
#!/bin/bash

# Step 1: Build
echo "🔨 Step 1: Building contract..."
forge build

# Step 2: Install dependencies (if not already done)
echo "📦 Step 2: Installing dependencies..."
npm install

# Step 3: Load environment
echo "🔐 Step 3: Loading environment..."
source .env

# Step 4: Check status with TypeScript
echo "📊 Step 4: Checking swap status (TypeScript)..."
npm run check-status

# Step 5: Check balances with TypeScript
echo "💰 Step 5: Checking balances (TypeScript)..."
npm run check-balances

# Step 6: Verify with cast
echo "✅ Step 6: Verifying with cast commands..."
cast call $CONTRACT_ADDRESS "hasFinishedExecuting()" --rpc-url $BASE_RPC_URL

echo "✨ All tests complete!"
```

## Troubleshooting

### If TypeScript scripts fail:

```bash
# Check Node.js version (should be 18+)
node --version

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Check environment variables are loaded
source .env
echo $CONTRACT_ADDRESS
```

### If contract deployment fails:

```bash
# Check you have ETH on Base Sepolia
cast balance $MY_ADDRESS --rpc-url $BASE_RPC_URL

# Check RPC URL is correct
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  $BASE_RPC_URL
```

### If swap execution fails:

```bash
# Check contract has RUSD tokens
cast call $RUSD_ADDRESS "balanceOf(address)" $CONTRACT_ADDRESS --rpc-url $BASE_RPC_URL | cast to-dec

# Check faucet cooldown (must wait 24 hours between mints)
# The error will say: "Faucet: Wait 24h between mints"
```

## Expected Final State

After all tests pass, you should see:

✅ Contract deployed and verified on-chain  
✅ TypeScript scripts working correctly  
✅ Swap status showing execution state  
✅ Balances showing tokens on both chains  
✅ Cast commands matching TypeScript output  

## Quick Reference

| Test | Command |
|------|---------|
| Build contract | `forge build` |
| Check status | `npm run check-status` |
| Check balances | `npm run check-balances` |
| Execute swap | `npm run execute-swap` |
| Verify with cast | `cast call $CONTRACT_ADDRESS "hasFinishedExecuting()" --rpc-url $BASE_RPC_URL` |

