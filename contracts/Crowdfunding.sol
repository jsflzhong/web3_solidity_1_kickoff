/*
业务需求描述：
众筹合约
众筹合约允许用户通过向合约发送资金来为特定项目筹集资金。
企业可以使用众筹机制来支持产品开发或项目启动，参与者可以以代币形式获得项目的部分权益或奖励。

业务场景：
企业希望为其新产品开发进行众筹，用户可以通过购买代币来支持项目，代币可以在项目成功后兑换为产品。

User Journey：
用户查看项目详情，决定支持项目并购买代币以换取未来的产品或权益。
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Crowdfunding is Ownable{

    IERC20 public token;
    //Target amount
    uint256 public goal;
    //Crowdfunded amount
    uint256 public totalRised;
    //The deadline for crowdfunding 
    uint256 public deadline;

    //Record each one's contributios
    mapping(address => uint256) public contributions;

    event ContributionReceived(address contributor, uint256 amount);
    event FundRaiserSuccessful(uint256 totalRaisedAmount);
    event FundRaiseFailed();

}