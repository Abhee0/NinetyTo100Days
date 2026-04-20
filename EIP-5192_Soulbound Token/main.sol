// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ModularSettlement {
    // Represents a root hash of data stored on an external DA layer (e.g., Celestia)
    bytes32 public latestDARoot;
    address public sequencer;

    event StateUpdated(bytes32 indexed daRoot, uint256 timestamp);

    constructor(address _sequencer) {
        sequencer = _sequencer;
    }

    /**
     * @dev Instead of uploading 10MB of habit-tracking data, 
     * the sequencer only uploads a 32-byte hash (the DA Root).
     */
    function updateState(bytes32 _newDARoot) external {
        require(msg.sender == sequencer, "Unauthorized: Only sequencer can update");
        
        latestDARoot = _newDARoot;
        
        emit StateUpdated(_newDARoot, block.timestamp);
    }

    /**
     * @dev A user can prove their specific data exists by providing 
     * a Merkle Proof against this root.
     */
    function verifyInclusion(bytes32 _leaf, bytes32[] calldata _proof) public view returns (bool) {
        // Standard Merkle verification logic would go here
        // to prove the data is available on the external layer.
        return true; 
    }
}