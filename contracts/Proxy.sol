
//业务场景：Web3企业希望部署智能合约，但担心在未来可能需要对合约进行升级，而不希望改变合约地址。
//User Journey：用户与智能合约交互后，如果合约有重大升级或新功能添加，系统可以无缝升级并保持用户体验不变。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    // 存储实现合约地址
    address public implementation;

    // 事件：当实现合约地址被更改时触发
    event ImplementationChanged(address indexed newImplementation);

    // 构造函数，设置初始的实现合约地址
    constructor(address _initialImplementation) {
        implementation = _initialImplementation;
    }

    // 设置新的实现合约地址（通常只有管理员有权限操作）
    function setImplementation(address _newImplementation) public {
        require(_newImplementation != address(0), "Invalid implementation address");
        implementation = _newImplementation;
        emit ImplementationChanged(_newImplementation);
    }

    // 接收调用并转发到实现合约
    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "Implementation not set");

        // 将调用数据转发给实现合约
        assembly {
            let ptr := mload(0x40) // 获取空闲内存的指针
            calldatacopy(ptr, 0, calldatasize()) // 将调用数据拷贝到ptr所指向的内存
            let result := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0) // 调用实现合约的函数 [MC] 见下面自己的分析.
            let size := returndatasize() // 获取返回数据的大小
            returndatacopy(ptr, 0, size) // 将返回数据拷贝到ptr所指向的内存
            switch result // 根据结果判断是成功还是失败
            case 0 { revert(ptr, size) } // 失败则回滚交易
            default { return(ptr, size) } // 成功则返回数据
        }
    }

    // 回退函数，允许接收以太币
    receive() external payable {}
}
