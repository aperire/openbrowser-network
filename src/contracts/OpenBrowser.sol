// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract OpenBrowser {
    // File Publickey Array
    string[] public pubkeyArray;

    // File pubkey: DataInfo mapping
    mapping(string => DataInfo) public pubkeyDataMap;

    // Client Fund (DAI) locked as credit
    mapping(address => uint256) public clientCredit;

    // Insurance Fund (DAI) locked by storage providers
    mapping(address => uint256) public storageInsuranceFund;
    
    // Validator Stake (OPB)
    mapping(address => uint256) public vaildatorStake;
    uint256 public totalStake;


    // Data Struct
    struct DataInfo {
        address[] _associatedStorageAddress;
        string _sha256Data;
    }

    // User Struct
    struct UserInfo {
        string[] pubkeyArray;
    }

    // Validator Struct
    struct ValidatorInfo {
        uint _commissionRate;
        uint _voteSuccessRate;
        address _validatorAddress;
    }

    // Storage Struct
    struct StorageInfo {
        uint _pricePerGb;
        string _endpoint;
        uint _storageLimit;
        uint _credibilityScore;
        address _storageAddress;
        uint _status; //0 if accepting, 1 if offline
    }

    


    /*
    Client Functions
    */
    function clientDepositCredit() public payable returns(bool success) {
        address _client = msg.sender;
        clientCredit[_client] += msg.value;
        
        return true;
    }

    function clientWithdrawCredit(uint _amount) public {
        require(_amount >= clientCredit[msg.sender], "insufficient balance");
        address payable _client = payable(msg.sender);
        clientCredit[msg.sender] -= _amount;

        (bool success, bytes memory data) = _client.call{value: _amount}("");
        require(success, "failed to withdraw balance");
    }


    /*
    Validator Functions
    */
    function registerValidator() public payable returns (bool success) {
        
    }

    function unregisterValidator() {

    }

    function validatorWithdrawFund() {

    }

    function validatorReportStorage() {

    }

    function delegateStake() {

    }

    /*
    Storage Functions
    */
    function registerStorage(uint _pricePerGb, string memory _endpoint, uint _storageLimit) public payable {
        
    }

    function unregisterStorage() {

    }

    function storageDepositInsurance() {

    }

    function storageWithdrawFund() {

    }
}