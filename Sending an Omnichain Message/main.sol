// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@layerzerolabs/solidity-examples/contracts/lzApp/NonblockingLzApp.sol";

contract CrossChainMessenger is NonblockingLzApp {
    string public lastMessage;

    constructor(address _endpoint) NonblockingLzApp(_endpoint) {}

    // 1. Function to send data to another chain
    function sendMessage(
        uint16 _dstChainId, 
        string calldata _message,
        address payable _refundAddress
    ) public payable {
        bytes memory payload = abi.encode(_message);
        
        // _send handles the Oracle and Relayer interaction
        _lzSend(
            _dstChainId, 
            payload, 
            _refundAddress, 
            address(0x0), // ZRO payment address (null for native gas)
            bytes(""),    // Adapter params (default)
            msg.value     // Gas for the destination chain
        );
    }

    // 2. Internal function that catches the message on the destination chain
    function _nonblockingLzReceive(
        uint16 _srcChainId, 
        bytes memory _srcAddress, 
        uint64 _nonce, 
        bytes memory _payload
    ) internal override {
        lastMessage = abi.decode(_payload, (string));
    }
}