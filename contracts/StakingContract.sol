// 业务场景：企业构建的 DeFi 平台，用户通过质押代币获得额外收益，如额外代币或平台奖励。
// User Journey：用户选择想要质押的代币和数量，合约将这些代币锁定，并根据质押的时间和数量给予奖励。用户可以在任何时间解锁并提取代币和奖励。


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingContract is Ownable {
    IERC20 public stakingToken; // 用于质押的ERC20代币
    uint256 public rewardRate; // 奖励比率，每质押1个代币获得的奖励数量
    uint256 public totalStaked; // 合约中质押的代币总量

    struct Stake {
        uint256 amount; // 质押的数量
        uint256 rewardDebt; // 已获得的奖励，防止重复计算
        uint256 lastStakeTime; // 上次质押或领取奖励的时间
    }

    mapping(address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward);

    constructor(IERC20 _stakingToken, uint256 _rewardRate) {
        stakingToken = _stakingToken;
        rewardRate = _rewardRate;
    }

    // 用户质押函数
    function stake(uint256 _amount) external {
        require(_amount > 0, "Cannot stake zero tokens");

        // 如果用户已经有质押，先结算之前的奖励
        if (stakes[msg.sender].amount > 0) {
            uint256 pendingReward = calculateReward(msg.sender);
            stakes[msg.sender].rewardDebt += pendingReward;
        }

        // 用户质押, 更新数据
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        stakes[msg.sender].amount += _amount;
        stakes[msg.sender].lastStakeTime = block.timestamp;

        totalStaked += _amount;
        emit Staked(msg.sender, _amount);
    }

    // 计算用户的奖励
    function calculateReward(address _user) public view returns (uint256) {
        Stake memory stakeData = stakes[_user];
        uint256 stakingDuration = block.timestamp - stakeData.lastStakeTime;
        uint256 reward = (stakeData.amount * rewardRate * stakingDuration) / 1e18;
        return reward;
    }

    // 用户提取质押和奖励
    function withdraw() external {
        uint256 stakedAmount = stakes[msg.sender].amount;
        require(stakedAmount > 0, "Nothing to withdraw");

        uint256 pendingReward = calculateReward(msg.sender);
        uint256 totalReward = pendingReward + stakes[msg.sender].rewardDebt;

        // 更新用户质押数据
        stakes[msg.sender].amount = 0;
        stakes[msg.sender].rewardDebt = 0;

        stakingToken.transfer(msg.sender, stakedAmount);
        stakingToken.transfer(msg.sender, totalReward);

        totalStaked -= stakedAmount;
        emit Withdrawn(msg.sender, stakedAmount, totalReward);
    }

    // 合约所有者设置新的奖励率
    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
    }
}
