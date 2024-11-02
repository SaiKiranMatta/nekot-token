# Nekot Token (NKT)

## Overview

Nekot (NKT) is an ERC20-compatible token implemented on the Ethereum blockchain. It features standard token functionality along with additional features like pausability, minting, burning, and owner controls.

## Features

-   ERC20 Standard Compliance
-   Configurable Decimals (1-18)
-   Ownership Management
-   Pausable Transfers
-   Minting Capability
-   Burning Mechanism
-   Emergency Token Recovery
-   Overflow Protection
-   Zero Address Protection

## Contract Details

-   **Name:** Nekot
-   **Symbol:** NKT
-   **License:** MIT
-   **Solidity Version:** ^0.8.20

## Functions

### Core ERC20 Functions

-   `balanceOf(address)`: Check token balance of an address
-   `transfer(address, uint256)`: Transfer tokens to a specified address
-   `approve(address, uint256)`: Approve spending allowance for another address
-   `transferFrom(address, address, uint256)`: Transfer tokens on behalf of another address
-   `allowance(address, address)`: Check remaining allowance for a spender

### Allowance Management

-   `increaseAllowance(address, uint256)`: Increase spending allowance
-   `decreaseAllowance(address, uint256)`: Decrease spending allowance

### Token Supply Management

-   `mint(address, uint256)`: Create new tokens (owner only)
-   `burn(uint256)`: Burn tokens from caller's balance

### Administrative Functions

-   `pause()`: Pause all token transfers (owner only)
-   `unpause()`: Resume token transfers (owner only)
-   `transferOwnership(address)`: Transfer contract ownership
-   `recoverERC20(address, uint256)`: Recover accidentally sent ERC20 tokens

## Events

-   `Transfer`: Emitted on token transfers
-   `Approval`: Emitted on allowance changes
-   `Paused`: Emitted when token is paused
-   `Unpaused`: Emitted when token is unpaused
-   `OwnershipTransferred`: Emitted on ownership changes
-   `TokensBurned`: Emitted when tokens are burned
-   `TokensMinted`: Emitted when new tokens are minted

## Development

### Prerequisites

-   Node.js
-   npm/yarn
-   Hardhat

### Installation

```bash
npm install
```

### Testing

```bash
npx hardhat test
```

### Deployment

```bash
npx hardhat ignition deploy ./ignition/modules/Nekot.js
```

To deploy with specific parameters:

1. Configure your deployment parameters in the Ignition module
2. Set up your network configuration in `hardhat.config.js`
3. Run the deployment command with your desired network

### Gas Reporting

To get detailed gas usage reports:

```bash
REPORT_GAS=true npx hardhat test
```

## Security Considerations

-   The contract includes overflow protection through Solidity 0.8.x's built-in overflow checks
-   Pausable functionality for emergency situations
-   Owner-only access to critical functions
-   Zero address validation
-   ERC20 token recovery function for accidentally sent tokens

## License

This project is licensed under the MIT License - see the LICENSE file for details.
