pragma solidity ^0.4.21;

import "./EIP20Interface.sol";

contract EIP20 is EIP20Interface {

    uint256 constant private MAX_UINT256 = 2 ** 256 - 1;
    mapping(address => uint256) public balances; // 账户余额
    mapping(address => mapping(address => uint256)) public allowed; // 批准可转账余额

    /** 
     * 注意：
     * 以下为可选参数；
     * 可以自定义token信息，不影响核心功能；
     * 有些钱包不会读取这些参数。
     */
    string public name; // token 名称
    uint8 public decimals; // 显示小数点后位数
    string public symbol; // 唯一表示符，例如： SBX
    
    /// @notice 构造函数
    /// @param _initialAmount msg.sender 初始化时账户余额
    /// @param _tokenName token 名称
    /// @param _decimalUints 小数点单位
    /// @param _tokenSymbol token 简称，唯一标识符
    constructor (
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUints,
        string _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount;  // 给创建者初始 token
        totalSupply = _initialAmount;           // 更新总额度
        name = _tokenName;                      // 设置在钱包中的显示名称
        decimals = _decimalUints;               // 设置在钱包中显示小树位数信息
        symbol = _tokenSymbol;                  // 设置token在钱包中的符号
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); // solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        uint256 allowance = allowed[_from][msg.sender];
        require (balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if( allowance < MAX_UINT256 ){
            allowed[_from][msg.sender] -= _value;
        }

        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}