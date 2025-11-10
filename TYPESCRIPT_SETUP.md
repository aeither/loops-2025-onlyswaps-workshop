# TypeScript Setup Summary

## What Was Added

This workshop now includes a complete TypeScript/Node.js setup for interacting with OnlySwaps contracts using ethers.js, providing an alternative to using `cast` commands.

### Files Created

#### Configuration Files
- **`package.json`** - Node.js project configuration with scripts and dependencies
- **`tsconfig.json`** - TypeScript compiler configuration
- **`.gitignore`** - Updated to include `node_modules`, `dist`, and log files

#### TypeScript Scripts (`scripts/` directory)

1. **`execute-swap.ts`** - Execute a cross-chain swap
   - Connects to your wallet
   - Calls the `executeSwap()` function on your deployed contract
   - Displays transaction details and request ID
   
2. **`check-status.ts`** - Check swap execution status  
   - Shows if the swap has finished executing
   - Displays detailed swap parameters from the router
   - Shows timestamps and amounts

3. **`check-balances.ts`** - Check token balances on both chains
   - Shows contract balance on Base Sepolia (source)
   - Shows solver balance on Base Sepolia  
   - Shows contract balance on Avalanche Fuji (destination)

4. **`README.md`** - Documentation for the scripts

### Dependencies Installed

- **`ethers`** (v6.13.3) - Ethereum library for interacting with smart contracts
- **`dotenv`** (v16.4.5) - Load environment variables from `.env` file
- **`ws`** (v8.18.0) - WebSocket support for ethers.js
- **`tsx`** (v4.19.2) - TypeScript execution engine
- **`typescript`** (v5.5.4) - TypeScript compiler
- **`@types/node`** - TypeScript definitions for Node.js
- **`@types/ws`** - TypeScript definitions for WebSocket

### Key Features

#### 1. Smart Provider Creation
The scripts automatically detect whether you're using HTTP or WebSocket RPC URLs and create the appropriate provider:

```typescript
function createProvider(rpcUrl: string): ethers.Provider {
  if (rpcUrl.startsWith('wss://') || rpcUrl.startsWith('ws://')) {
    return new ethers.WebSocketProvider(rpcUrl, undefined, { WebSocket: WebSocket as any });
  } else {
    return new ethers.JsonRpcProvider(rpcUrl);
  }
}
```

#### 2. Sensible Defaults
All scripts include default values for RPC URLs and addresses, so they work out of the box:

```typescript
const rpcUrl = process.env.BASE_RPC_URL || 'https://sepolia.base.org';
const contractAddress = process.env.CONTRACT_ADDRESS || '0xDFCE37d029Ef1078fD528E58Da4594afC02fa48e';
```

#### 3. User-Friendly Output
Scripts provide formatted, easy-to-read output with emojis and clear sections:

```
🔗 Connecting to Base Sepolia...
📡 RPC URL: https://sepolia.base.org
📄 Checking swap status...

🎫 Request ID: 0x71587ad7e69f6a4b77de718a47511fb9d5a4227de9b8cec22a534935934f5f47
✓ Has finished executing: ✅ YES
```

## Usage

### One-Time Setup
```bash
npm install
```

### Running Scripts

```bash
# Check swap status
npm run check-status

# Check balances on both chains
npm run check-balances

# Execute a new swap (requires PRIVATE_KEY in .env)
npm run execute-swap
```

### Alternative: Direct Execution with npx
```bash
npx tsx scripts/check-status.ts
npx tsx scripts/check-balances.ts
npx tsx scripts/execute-swap.ts
```

## Comparison: Cast vs TypeScript

| Task | Cast Command | TypeScript Script |
|------|-------------|------------------|
| Check if swap executed | `cast call $CONTRACT_ADDRESS "hasFinishedExecuting()" --rpc-url $BASE_RPC_URL` | `npm run check-status` |
| Check contract balance | `cast call $RUSD_ADDRESS "balanceOf(address)" $CONTRACT_ADDRESS --rpc-url $AVAX_RPC_URL \| cast to-dec` | `npm run check-balances` |
| Execute swap | `cast send --rpc-url $BASE_RPC_URL --private-key $PRIVATE_KEY $CONTRACT_ADDRESS "executeSwap()"` | `npm run execute-swap` |

## Benefits

✅ **Simpler Commands** - `npm run check-status` vs long cast commands  
✅ **Better Errors** - Clear error messages instead of cryptic hex  
✅ **Formatted Output** - Human-readable with units and labels  
✅ **Multiple Operations** - One command can check multiple things  
✅ **Type Safety** - TypeScript catches errors at compile time  
✅ **Extensible** - Easy to add custom functionality  
✅ **WebSocket Support** - Works with both HTTP and WS RPC URLs  
✅ **Production Ready** - Same tools used in real frontend applications  

## Real-World Application

These scripts demonstrate how to use ethers.js to interact with OnlySwaps, which is the foundation for:

- Frontend web applications (React, Next.js, Vue, etc.)
- Backend services and APIs
- Monitoring and analytics tools
- Automated trading bots
- Custom integrations

The patterns used here can be directly applied to building production applications with the OnlySwaps protocol.

## Next Steps

To build a full application, you might want to:

1. **Frontend Integration** - Use these patterns in a React/Next.js app
2. **Event Listening** - Add WebSocket listeners for `SwapRequested` events
3. **Multiple Swaps** - Track multiple request IDs simultaneously
4. **User Interface** - Build a UI to display swap history and status
5. **Advanced Features** - Implement cancellations, fee updates, etc.

Refer to the [onlyswaps-js library](https://github.com/randa-mu/onlyswaps-js) for a more complete client implementation.

