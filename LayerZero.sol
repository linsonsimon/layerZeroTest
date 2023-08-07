// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "https://github.com/LayerZero-Labs/solidity-examples/blob/main/contracts/lzApp/NonblockingLzApp.sol";

/*
    
    LayerZero Goerli
      lzChainId:10121 lzEndpoint:0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23
      contract: 0x9326B12aB2409157170100B3E7bf216CdBA62393

      LayerZero BNB testnet
      lzChainId:10102 lzEndpoint:0x6Fcb97553D41516Cb228ac03FdC8B9a0a9df04A1
    
    LayerZero Sepolia testnet
    chainId: 10161  lzEndpoint: 0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1
    contract:0x8852B5eAB1caa64E1e441171fFb717D2f1fb8084
*/

contract LayerZeroTest is NonblockingLzApp {
    string public data = "Nothing received yet";
    uint16 destChainId;
    
    constructor(address _lzEndpoint) NonblockingLzApp(_lzEndpoint) {
        if (_lzEndpoint == 0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1) destChainId = 10121;
        if (_lzEndpoint == 0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23) destChainId = 10161;
    }

    function _nonblockingLzReceive(uint16, bytes memory, uint64, bytes memory _payload) internal override {
       data = abi.decode(_payload, (string));
    }

    function send(string memory _message) public payable {
        bytes memory payload = abi.encode(_message);
        _lzSend(destChainId, payload, payable(msg.sender), address(0x0), bytes(""), msg.value);
    }

    function trustAddress(address _otherContract) public onlyOwner {
        trustedRemoteLookup[destChainId] = abi.encodePacked(_otherContract, address(this));   
    }
}
