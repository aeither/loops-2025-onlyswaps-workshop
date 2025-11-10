pragma solidity ^0.8.30;

import {Helpers} from "./Helpers.sol";
import {IRouter} from "../dependencies/onlyswaps-solidity-v0.5.0/src/interfaces/IRouter.sol";
import {ERC20FaucetToken} from "../dependencies/onlyswaps-solidity-v0.5.0/src/mocks/ERC20FaucetToken.sol";

contract MyContract {
    IRouter internal onlyswapsRouter;
    ERC20FaucetToken internal token;
    address internal owner;
    bytes32 public lastRequestId; // Store the most recent swap request ID

    // we need to pass the owner as a constructor arg, because by default forge uses deployer contracts
    // on chains that support it, and using `msg.sender` will set the owner to the deployer!
    constructor(address _owner) {
        owner = _owner;
        onlyswapsRouter = IRouter(Helpers.ROUTER_ADDRESS);

        // we mint some of our RUSD tokens so the contract has a balance to trade
        token = ERC20FaucetToken(Helpers.RUSD_ADDRESS);
        token.mint();
    }

    function executeSwap() public {
        require(msg.sender == owner, "only the owner can call execute!");

        // 1. you're going to fill in your code to execute a swap here
        
        // Define the amount to swap (5 tokens with 18 decimals)
        uint256 amountToSwap = 5 * 10**18;
        uint256 fee = Helpers.RECOMMENDED_FEE;
        
        // Approve the router to spend our tokens
        token.approve(Helpers.ROUTER_ADDRESS, amountToSwap + fee);
        
        // Request the cross-chain swap from Base Sepolia to Avalanche Fuji
        lastRequestId = onlyswapsRouter.requestCrossChainSwap(
            Helpers.RUSD_ADDRESS,        // tokenIn (RUSD on Base Sepolia)
            Helpers.RUSD_ADDRESS,        // tokenOut (RUSD on Avalanche Fuji)
            amountToSwap,                // amount to swap
            fee,                         // verification fee
            Helpers.AVAX_CHAIN_ID,       // destination chain (Avalanche Fuji)
            address(this)                // recipient (this contract on destination chain)
        );
    }

    function hasFinishedExecuting() public view returns (bool) {
        // 2. you're going to fill in your code to check if it has been verified here
        
        // If no swap has been executed yet, return false
        if (lastRequestId == bytes32(0)) {
            return false;
        }
        
        // Get the swap request parameters from the router
        IRouter.SwapRequestParameters memory params = onlyswapsRouter.getSwapRequestParameters(lastRequestId);
        
        // Return whether the swap has been executed (fulfilled and verified)
        return params.executed;
    }
}
