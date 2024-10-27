//业务场景：Web3企业需要发行NFT，允许用户创建、购买和出售唯一的数字艺术品。
//User Journey：用户通过平台铸造NFT，之后可以交易或展示他们的艺术作品。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 引入ERC721标准库
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    // 使用计数器为每个NFT生成唯一ID
    // 使用 uint256 手动管理 tokenId 的递增
    uint256 private _currentTokenId;

    // 铸造NFT事件，便于追踪链上的NFT铸造行为
    event NFTMinted(address recipient, uint256 tokenId, string tokenURI);

    // 构造函数，初始化NFT名称和符号
    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender){
         _currentTokenId = 0; // 初始化 tokenId
    }

    // 铸造NFT的函数
    // 只有合约所有者可以调用此函数，向指定地址铸造NFT并分配tokenURI
    function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
         _currentTokenId++; // 增加tokenId计数器

        uint256 newItemId = _currentTokenId; // 获取当前tokenId

        _mint(recipient, newItemId); // 铸造NFT并将其分配给接收者地址
        _setTokenURI(newItemId, tokenURI); // 为该NFT设置tokenURI

        // 触发NFT铸造事件
        emit NFTMinted(recipient, newItemId, tokenURI);

        return newItemId;
    }

    // 设置NFT的tokenURI，以指向数字资产的元数据
    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal virtual {
        // ERC721标准的扩展实现
    }
}
