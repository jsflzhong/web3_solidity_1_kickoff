//业务需求描述：ERC20 是以太坊上最常用的代币标准之一。
//企业可能需要发行自己的代币，用于奖励、支付或生态系统内部流通。
//这个合约展示了如何发行 ERC20 代币。

//业务场景：企业希望发行自己的代币，用于奖励生态系统中的用户，并允许代币持有者在系统内支付或进行投票。
//User Journey：企业发行代币，用户可以通过平台获取代币，并在平台中使用代币进行支付或投票。

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//Extend from 2 father Contract, which are ERC20 and Ownable 
contract CustomToken is ERC20, Ownable {
    
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) Ownable(msg.sender){
        _mint(msg.sender, initialSupply*(10**decimals()));
    }

    // Mint new token, can be only called by the owner
    function mint(address to, uint256 amount) external onlyOwner{
        _mint(to, amount);
    }

    // Burn token, can be only called by the owner
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}