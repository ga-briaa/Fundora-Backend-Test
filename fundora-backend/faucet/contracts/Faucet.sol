// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Faucet is Ownable {
    IERC20 public token;
    
    // Amount to dispense (e.g., 100 mUSDC)
    uint256 public dripAmount = 100 * (10**6); // 100 * 10^6 (USDC decimals)

    // Cooldown period (e.g., 5 minutes)
    uint256 public cooldown = 5 minutes;

    // Mapping to track when each address last requested tokens
    mapping(address => uint256) public lastRequestTime;

    event TokensRequested(address indexed to, uint256 amount);

    constructor(address tokenAddress, address initialOwner) Ownable(initialOwner) {
        token = IERC20(tokenAddress);
    }

    /**
     * @notice Allows a user to request tokens from the faucet.
     */
    function requestTokens() public {
        // Check if cooldown has passed
        require(
            block.timestamp >= lastRequestTime[msg.sender] + cooldown, 
            "Faucet: Cooldown period is not over"
        );
        
        // Check if faucet has enough tokens
        require(
            token.balanceOf(address(this)) >= dripAmount, 
            "Faucet: Not enough tokens in the faucet"
        );

        // Update last request time
        lastRequestTime[msg.sender] = block.timestamp;

        // Send the tokens
        bool sent = token.transfer(msg.sender, dripAmount);
        require(sent, "Faucet: Token transfer failed");

        emit TokensRequested(msg.sender, dripAmount);
    }

    // --- Admin Functions ---

    /**
     * @notice Allows the owner to withdraw all tokens from the faucet.
     */
    function withdrawTokens() public onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        bool sent = token.transfer(owner(), balance);
        require(sent, "Faucet: Token withdrawal failed");
    }

    /**
     * @notice Allows the owner to set a new drip amount.
     */
    function setDripAmount(uint256 _amount) public onlyOwner {
        dripAmount = _amount;
    }

    /**
     * @notice Allows the owner to set a new cooldown period.
     */
    function setCooldown(uint256 _cooldown) public onlyOwner {
        cooldown = _cooldown;
    }
}