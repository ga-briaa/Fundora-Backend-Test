// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MockUSDC is ERC20, Ownable {
    constructor(address initialOwner) 
        ERC20("Mock USDC", "mUSDC")
        Ownable(initialOwner)
    {
        // Mint 10 million tokens to the deployer
        _mint(initialOwner, 10_000_000 * (10**6));
    }

    // Override decimals to be 6 (USDC standard) instead of 18
    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

    // Optional: A way for the owner to mint more if the faucet runs dry
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}