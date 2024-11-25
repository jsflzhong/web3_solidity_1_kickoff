/*
业务需求：
NFT 市场平台允许用户买卖独特的数字资产，NFT（Non-Fungible Token）即不可替代代币。
企业可以使用 NFT 平台为艺术家、游戏开发者或内容创作者提供市场，将其作品以数字形式上架并进行买卖。

业务场景：
场景：企业搭建一个 NFT 交易市场，用户可以在平台上购买、出售或拍卖 NFT 作品。

User Journey：
用户在平台上铸造 NFT，并设置售价。
其他用户可以通过支付代币来购买 NFT。所有交易记录链上透明。
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is Ownable {

    constructor() Ownable (msg.sender) {
    }

    struct Listing {
        address seller; //Seller's address
        uint256 price; //Token's price
    }

    //Store the info of saling for each NFT
    //Token address => (TokenId => Listing)
    mapping(address => mapping(uint256 => Listing)) public listings;
    uint256 public listingFee = 0.01 ether;
    //Manuel reentrancy guard
    bool private locked;

    event NFTListed(address indexed seller, address indexed nftContract, uint indexed tokenId, uint256 price);
    event NFTSold(address indexed buyer, address indexed nftContract, uint indexed tokenId, uint256 price);
    event NFTDelisted(address indexed seller, address indexed nftContract, uint indexed tokenId);

    //Define a modifier to protect the function from reEntrant attack.
    modifier nonReentrant() {
        require(!locked, "ReentrantGuard: reentrant call is not allowed for this function");
        locked = true;
        _;
        locked = false;
    }
}