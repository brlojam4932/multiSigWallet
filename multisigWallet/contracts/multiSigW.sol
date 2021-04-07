// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;
pragma abicoder v2;

// Philip/Intructor code
// https://github.com/filipmartinsson/solidity-0.7.5

contract Wallet {
    
    address[] public owners;
    uint limit;
    
    mapping(address => mapping(uint => bool)) approvals;
    mapping(address => uint) balance;
    
    struct Transfer{
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }
    
    // ownly users in owners list cn approve and execute Transfers       
   modifier onlyOwners() {
       bool owner = false;
       for(uint i = 0; i < owners.length; i++) {
           if(owners[i] == msg.sender) {
               owner = true;
           }
       }
       require(owner == true, "Not an owner");
       _;
   }
   
   event transferRequestsCreated(uint _id, uint _amount, address _initiator, address _receiver);
   event ApprovalReceived(uint _id, uint _approvals, address _approver);
   event TransferApproved(uint _id);
    
    
    Transfer[] transferRequests;
    
    // initialize owners list and the number of confirmations required to authorize transfer requests
    constructor(address[] memory _owners, uint _limit) {
        owners = _owners;
        limit = _limit;
    }
    
    // ["0xdc6bbc41d7ff0accd096969921067c07cd3b0d37", "0xe8b2ef888b7059907fe4eeed19892aac95c7e961", "0x87710DfA8D5210d21A44bCB9947755DA22f3A707"]
    
    // limit 2 votes 
    // 6000000000000000000 wei (18 zeros)
    
    //----------------transfers--------------------------
    
    function deposit() public payable returns(uint) {
        balance[msg.sender] += msg.value;
        return balance[msg.sender];
    }
    
    function getBalance() public view returns(uint) {
        return (msg.sender).balance;
    }
    
    function getWalletBalance() public view returns(uint) {
        return balance[msg.sender];
        
    }
    
    // create an instance of the transfer struct and add it to the transferRequests array
    function createTransfer(uint _amount, address payable _receiver) public onlyOwners {
        emit transferRequestsCreated(transferRequests.length, _amount, msg.sender, _receiver);
        transferRequests.push(
            Transfer(_amount, _receiver, 0, false, transferRequests.length)
        );
        
    }
    
    //----------------approve--------------------------   
    
    // set approval for one of the transfer requests
    // update Transfer Object
    // update mapping and record the aproval for msg.sender
    // once min amount of approvals are met, send amount to recipient
    // owners cannot vote twice
    // owners cannot vote for completed transfers 
    
     // approve which transaction - 0,1,2,...etc
    function approve(uint _id) public onlyOwners {
        require(approvals[msg.sender][_id] == false, "cannot vote twice");
        require(transferRequests[_id].hasBeenSent == false, "cannot vote for completed transfers");
        
        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals++;
        
        emit ApprovalReceived(_id, transferRequests[_id].approvals, msg.sender);
        
        if(transferRequests[_id].approvals >= limit) {
            transferRequests[_id].hasBeenSent = true;
            transferRequests[_id].receiver.transfer( transferRequests[_id].amount);
            emit TransferApproved(_id);
        }
        
    }
    
     function getTransferRequests() public view returns(Transfer[] memory) {
        //return transferRequests[_address].amount;
        return transferRequests;
    }
    

}

