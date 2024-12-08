/*
业务需求描述：
企业可能需要向用户或团队成员分发代币，例如用于奖励、激励或支付服务。
代币分发合约可以自动化这一过程，确保分发的安全性和透明性。

业务场景：
企业希望定期向社区贡献者或员工发放代币，以奖励他们的贡献。

User Journey：
用户能够看到他们的分发记录，并确保及时收到代币奖励。
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenDistribution is Ownable{
    IERC20 public token;

    constructor(IERC20 _token) Ownable(msg.sender){
        token = _token;
    }

    event tokenDistributed(address recipient, uint256 amount);

    //Gas费优化：使用批量转移减少多次调用带来的开销
    function distributeTokens(address[] calldata recipients, uint256[] calldata amounts) external onlyOwner(){
        require(recipients.length == amounts.length, "Mismatch between recipients and amounts");

        for(uint256 i=0; i<recipients.length; i++) {
            require(amounts[i] > 0,"Amount must be greater than zero");
            token.transfer(recipients[i], amounts[i]);
            //透明性：每次代币分发都会触发事件，便于审计和跟踪。
            emit tokenDistributed(recipients[i], amounts[i]);
        }
    }

}