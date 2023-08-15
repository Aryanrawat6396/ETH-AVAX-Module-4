// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenGamingToken is ERC20, Ownable {
    constructor() ERC20("DegenGamingToken", "DGT") {}

    // Mint new tokens and distribute them to players as rewards. Only the owner can do this.
    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Transfer tokens from the sender's account to another account.
    function transferTokens(address to, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _transfer(msg.sender, to, amount);
    }

    // Redeem tokens for items in the in-game store.
    event RedeemItem(address indexed player, string itemName, uint256 price);

    struct StoreItem {
        string itemName;
        uint256 price;
    }

    StoreItem[] public storeItems;

    function addStoreItem(string memory itemName, uint256 price) external onlyOwner {
        storeItems.push(StoreItem(itemName, price));
    }

    function redeem(uint256 itemIndex) public {
        require(itemIndex < storeItems.length, "Invalid item index");
        uint256 price = storeItems[itemIndex].price;
        require(balanceOf(msg.sender) >= price, "Insufficient balance for redemption");

        _burn(msg.sender, price);
        emit RedeemItem(msg.sender, storeItems[itemIndex].itemName, price);
    }

    // Anyone can burn their own tokens that are no longer needed.
    function burnTokens(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }
}
