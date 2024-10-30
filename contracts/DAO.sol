//业务需求：DAO(去中心化自治组织)作为去中心化管理的一种方式, 常常用于社区治理。
//DAO 的核心功能之一是投票，成员们可以根据自己的投票权对提案进行表决。

//业务场景：企业级 DAO 系统，用户持有代币作为投票权，投票结果决定企业发展方向或项目进展。
//User Journey：用户创建提案，其他持有投票权的用户对提案进行表决，当投票期限结束后根据投票结果执行提案或拒绝。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAO {
    IERC20 public governanceToken; // 治理代币
    uint256 public proposalCount; // 提案计数

    struct Proposal {
        uint256 id;
        string description; // 提案描述
        uint256 deadline; // 提案截止时间
        uint256 votesFor; // 支持票数
        uint256 votesAgainst; // 反对票数
        bool executed; // 是否执行
    }

    mapping(uint256 => Proposal) public proposals; // 存储提案
    mapping(address => mapping(uint256 => bool)) public votes; // 记录用户是否对某个提案投票

    event ProposalCreated(uint256 id, string description, uint256 deadline);
    event Voted(address indexed voter, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 id, bool passed);

    constructor(IERC20 _governanceToken) {
        governanceToken = _governanceToken;
    }

    // 创建提案
    function createProposal(string memory _description, uint256 _duration) external {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: _description,
            deadline: block.timestamp + _duration,
            votesFor: 0,
            votesAgainst: 0,
            executed: false
        });

        emit ProposalCreated(proposalCount, _description, block.timestamp + _duration);
    }

    // 对提案进行投票
    function vote(uint256 _proposalId, bool _support) external {
        Proposal storage proposal = proposals[_proposalId];

        require(block.timestamp < proposal.deadline, "Voting has ended");
        require(!votes[msg.sender][_proposalId], "Already voted");

        uint256 votingPower = governanceToken.balanceOf(msg.sender); // 用户的投票权重

        require(votingPower > 0, "No voting power");

        if (_support) {
            proposal.votesFor += votingPower;
        } else {
            proposal.votesAgainst += votingPower;
        }

        votes[msg.sender][_proposalId] = true;

        emit Voted(msg.sender, _proposalId, _support);
    }

    // 执行提案
    function executeProposal(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];

        require(block.timestamp >= proposal.deadline, "Voting is still ongoing");
        require(!proposal.executed, "Proposal already executed");

        if (proposal.votesFor > proposal.votesAgainst) {
            // 提案通过的逻辑（例如调用某个合约功能）
            proposal.executed = true;
            emit ProposalExecuted(_proposalId, true);
        } else {
            // 提案未通过
            proposal.executed = true;
            emit ProposalExecuted(_proposalId, false);
        }
    }
}
