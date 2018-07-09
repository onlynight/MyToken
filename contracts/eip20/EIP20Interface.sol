pragma solidity ^0.4.21;

/**
 * ERC20 Token 标准 抽象合约
 */

contract EIP20Interface {

    /**
     * 这里和 ERC20 标准略有不同。
     * 用
     * uint256 public totalSupply;
     * 替换了
     * function totalSupply() constant returns (uint256 supply);
     * public 申明的状态编译后默认会生成 getter 方法。
     */

    // token 的总量
    uint256 public totalSupply;

    /// @notice 获取的余额
    /// @param _owner 想要获取余额的钱包地址
    /// @return 账户余额
    function balanceOf(address _owner) public view returns (uint256 balance);

    /// @notice 转账，不指定发送方，默认使用 msg.sender 做法转账发送发
    /// @param _to 接收转账账户地址
    /// @param _value 转账金额 token
    /// @return 转账是否成功
    function transfer(address _to, uint256 _value) public returns (bool success);

    /// @notice 转账，指定发送方和接收方
    /// @param _from 转账发送方钱包地址
    /// @param _to 转账接收方钱包地址
    /// @param _value 转账金额 token
    /// @return 转账是否成功
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    /// @notice msg.sender 同意 _spender 发送 _value 数量的 token
    /// 转帐前先批准可转账余额。
    /// @param _spender 能够传输 token 的账户地址
    /// @param _value 同意转账的金额 token
    /// @return 是否同意转账
    function approve(address _spender, uint256 _value) public returns (bool success);

    /// @notice 获取可转账的金额 token
    /// @param _owner 的持有者
    /// @param _spender 能够传输 token 的账户地址
    /// @return 剩余可转账的金额 token
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    /// @notice 转账触发事件
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    /// @notice 同意转账触发事件
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}