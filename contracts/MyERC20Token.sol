// 业务场景：
// 场景：某Web3企业需要发行ERC20代币用于其应用内交易。
// User Journey：用户在应用内通过钱包连接，与代币进行交易，参与投票或收益分配。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC20 接口
interface IERC20 {
    // 事件：当代币转移时触发
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 事件：当授权额度发生变化时触发
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 查询账户余额
    function balanceOf(address account) external view returns (uint256);

    // 查询代币总供应量
    function totalSupply() external view returns (uint256);

    // 转移代币
    function transfer(address recipient, uint256 amount) external returns (bool);

    // 查询授权额度
    function allowance(address owner, address spender) external view returns (uint256);

    // 授权他人代币转移额度
    function approve(address spender, uint256 amount) external returns (bool);

    // 转移他人授权的代币
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// ERC20 标准实现
contract MyERC20Token is IERC20 {
    // 代币名称
    string public name = "MyERC20Token";
    // 代币符号
    string public symbol = "MET";
    // 代币小数位数（通常为18）
    uint8 public decimals = 18;

    // 代币总供应量
    uint256 private _totalSupply;

    // 每个账户的代币余额
    mapping(address => uint256) private _balances;

    // 授权额度：账户 => (spender => amount)
    mapping(address => mapping(address => uint256)) private _allowances;

    // 构造函数，设置代币总供应量并分配给部署合约的地址
    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply * (10 ** uint256(decimals)); // 乘以10的18次方来适应小数
        _balances[msg.sender] = _totalSupply; // 将所有代币赋予合约的创建者
        emit Transfer(address(0), msg.sender, _totalSupply); // 触发代币创建的事件
    }

    // 查询代币总供应量
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // 查询账户余额
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    // 代币转账
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");

        // 转移代币
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;

        // 触发转账事件
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // 查询授权额度
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    // 授权他人代币转移额度
    function approve(address spender, uint256 amount) public override returns (bool) {
        require(spender != address(0), "ERC20: approve to the zero address");

        // 设置授权额度
        _allowances[msg.sender][spender] = amount;
        
        // 触发授权事件
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 代币授权转移
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
        require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");

        // 转移代币
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        
        // 减少授权额度
        _allowances[sender][msg.sender] -= amount;

        // 触发转账事件
        emit Transfer(sender, recipient, amount);
        return true;
    }
}

