pragma solidity ^0.4.21;


import "./EIP20.sol";


contract EIP20Factory {

    mapping(address => address[]) public created;
    mapping(address => bool) public isEIP20; //无需进行字节码检查即可进行验证。
    bytes public EIP20ByteCode; // solhint-disable-line var-name-mixedcase

    constructor() public {
        address verifiedToken = createEIP20(10000, "Verify Token", 3, "VTX");
        EIP20ByteCode = codeAt(verifiedToken);
    }

    function verifyEIP20(address _tokenContract) public view returns (bool) {
        bytes memory fechedTokenByteCode = codeAt(_tokenContract);

        if( fechedTokenByteCode.length != EIP20ByteCode.length ){
            return false;
        }

        for( uint i = 0; i < fechedTokenByteCode.length; i++ ){
            if( fechedTokenByteCode[i] != EIP20ByteCode[i] ){
                return false;
            }
        }

        return true;
    }

    function createEIP20(uint256 _initialAmount, string _name, uint8 _decimals, string _symbol) 
        public 
    returns (address){
        EIP20 newToken = (new EIP20(_initialAmount, _name, _decimals, _symbol));
        created[msg.sender].push(address(newToken));
        newToken.transfer(msg.sender, _initialAmount);
        return address(newToken);
    }

    function codeAt (address _addr) internal view returns(bytes outputCode) {
        assembly {
            let size := extcodesize(_addr)
            outputCode := mload(0x40)
            mstore(0x40, add(outputCode, and( add( add(size, 0x20), 0x1f), not(0x1f) ) ) )
            mstore(outputCode, size)
            extcodecopy(_addr, add(outputCode, 0x20), 0, size)
        }
    }
    
}