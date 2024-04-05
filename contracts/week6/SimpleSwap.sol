// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';

contract SimpleSwap {

   ISwapRouter public immutable swapRouter;

   // This example swaps W3BAM/W3EUR
   address public constant W3BAM = 0x9595C767AC5182CbAdfD49b3697FfF2e8E615da7;
   address public constant W3EUR = 0xD48cEd5f54328776bAa092E18aaFAeAD57Cc409f;

   // For this example, we will set the pool fee to 0.3%. (desired fee * 10000)
   uint24 public constant poolFee = 3000;

   constructor(ISwapRouter _swapRouter) {
       swapRouter = _swapRouter;
   }

   /// @notice swapExactInputSingle swaps a fixed amount of the 1st token in the pair for a maximum possible amount of 2nd token
   /// In our example: W3BAM --> W3EUR
   /// using the W3BAM/W3EUR 0.3% pool by calling `exactInputSingle` in the swap router.
   /// @dev The calling address must approve this contract to spend at least `amountIn` worth of its W3BAM for this function to succeed.
   /// @param amountIn The exact amount of W3BAM that will be swapped for W3EUR.
   /// @return amountOut The amount of W3EUR received.
   function swapExactInputSingle(uint256 amountIn) external returns (uint256 amountOut) {
       // msg.sender must approve this contract

       // Transfer the specified amount of W3BAM to this contract.
       TransferHelper.safeTransferFrom(W3BAM, msg.sender, address(this), amountIn);

       // Approve the router to spend W3BAM.
       TransferHelper.safeApprove(W3BAM, address(swapRouter), amountIn);

       // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
       // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
       ISwapRouter.ExactInputSingleParams memory params =
           ISwapRouter.ExactInputSingleParams({
               tokenIn: W3BAM,
               tokenOut: W3EUR,
               fee: poolFee,
               recipient: msg.sender,
               deadline: block.timestamp,
               amountIn: amountIn,
               amountOutMinimum: 0,
               sqrtPriceLimitX96: 0
           });

       // The call to `exactInputSingle` executes the swap.
       amountOut = swapRouter.exactInputSingle(params);
   }

   /// @notice swapExactOutputSingle swaps a minimum possible amount of W3BAM for a fixed amount of W3EUR.
   /// @dev The calling address must approve this contract to spend its W3BAM for this function to succeed. As the amount of input W3BAM is variable,
   /// the calling address will need to approve for a slightly higher amount, anticipating some variance.
   /// @param amountOut The exact amount of W3EUR to receive from the swap.
   /// @param amountInMaximum The amount of W3BAM we are willing to spend to receive the specified amount of W3EUR.
   /// @return amountIn The amount of W3BAM actually spent in the swap.
   function swapExactOutputSingle(uint256 amountOut, uint256 amountInMaximum) external returns (uint256 amountIn) {
       // Transfer the specified amount of W3BAM to this contract.
       TransferHelper.safeTransferFrom(W3BAM, msg.sender, address(this), amountInMaximum);

       // Approve the router to spend the specifed `amountInMaximum` of W3BAM.
       // In production, you should choose the maximum amount to spend based on oracles or other data sources to acheive a better swap.
       TransferHelper.safeApprove(W3BAM, address(swapRouter), amountInMaximum);

       ISwapRouter.ExactOutputSingleParams memory params =
           ISwapRouter.ExactOutputSingleParams({
               tokenIn: W3BAM,
               tokenOut: W3EUR,
               fee: poolFee,
               recipient: msg.sender,
               deadline: block.timestamp,
               amountOut: amountOut,
               amountInMaximum: amountInMaximum,
               sqrtPriceLimitX96: 0
           });

       // Executes the swap returning the amountIn needed to spend to receive the desired amountOut.
       amountIn = swapRouter.exactOutputSingle(params);

       // For exact output swaps, the amountInMaximum may not have all been spent.
       // If the actual amount spent (amountIn) is less than the specified maximum amount, we must refund the msg.sender and approve the swapRouter to spend 0.
       if (amountIn < amountInMaximum) {
           TransferHelper.safeApprove(W3BAM, address(swapRouter), 0);
           TransferHelper.safeTransfer(W3BAM, msg.sender, amountInMaximum - amountIn);
       }
   }
}