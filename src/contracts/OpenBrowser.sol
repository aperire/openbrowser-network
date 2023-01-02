pragma solidity ^0.8.15;
import "./IERC20.sol";

contract OpenBrowser {
    // File Publickey Array
    string[] public pubkeyArray;

    // File pubkey: DataInfo mapping
    mapping(string => DataInfo) public pubkeyDataMap;

    // Client Fund (ETH) locked as credit
    mapping(address => uint256) public clientCredit;

    // Insurance Fund (ETH) locked by storage providers
    mapping(address => StorageInfo) public storageInfoMap;
    mapping(address => uint256) public storageBalance;
    
    // Validator Stake (OPB)
    mapping(address => uint256) public vaildatorStake;
    uint256 public totalStake;

    // Storage Registration Balance
    uint storageRegistrationFee = 0;

    // Current Vote Epoch
    uint currentVoteEpoch = 0;

    // OPB Token Address
    IERC20 OPB = IERC20(0x87c6eCcD1074108f71843368DE3ccC86274217dF);

    // Data Struct
    struct DataInfo {
        address[] associatedStorageAddress;
        string sha256Data;
        uint price;
        uint validated; // 1 for validated
    }

    // User Struct
    struct UserInfo {
        string[] pubkeyArray;
    }

    // Validator Struct
    struct ValidatorInfo {
        uint opbStake;
        uint commissionRate;
        uint startEpoch;
        uint voteNum;
        uint voteSuccessRate;
        address validatorAddress;
    }


    // Storage Struct
    struct StorageInfo {
        uint pricePerByte;
        string endpoint;
        uint storageLimit;
        uint credibilityScore;
        address storageAddress;
        uint status; //0 if accepting, 1 if offline
    }

    /*
    Global Functions
    */
    // simulateTransaction: Ran by client
    function simulateTransaction(
        uint _byteSize, string memory _pubkey, string memory _sha256data, address[] memory _storageArray, uint[] memory _storageWeight
    ) public {
        // Calculate price
        uint totalPrice = 0;
        for (uint i=0; i<_storageArray.length; i++) {
            address storageAddress = _storageArray[i];
            StorageInfo memory storageInfo = storageInfoMap[storageAddress];
            uint storagePricePerByte = storageInfo.pricePerByte;
            uint weight = _storageWeight[i];
            uint price = storagePricePerByte * weight;
            totalPrice += price;
        }
        require (clientCredit[msg.sender] >= totalPrice, "insufficient credit");
        DataInfo memory dataInfo = DataInfo(_storageArray, _sha256data, totalPrice, 0);
        pubkeyDataMap[_pubkey] = dataInfo;
    }

    // voteInvalidStorage: Ran by validator to validate storage
    function voteInvalidStorage(
        
    ) {

    }

    // voteInvalidPubkey: Ran by validator to validate malicious data posted by client
    function voteInvalidPubkey(

    ) {
        
    }

    /*
    Client Functions
    */
    function clientDepositCredit() public payable {
        address _client = msg.sender;
        clientCredit[_client] += msg.value;
    }

    function clientWithdrawCredit(uint _amount) public payable {
        require(_amount >= clientCredit[msg.sender], "insufficient balance");
        address payable _client = payable(msg.sender);
        clientCredit[msg.sender] -= _amount;

        (bool success, bytes memory data) = _client.call{value: _amount}("");
        require(success, "failed to withdraw balance");
    }

    /*
    Validator Functions
    */
    function registerValidator(
        uint _commissionRate,
        uint _opbStake
    ) public payable {
        require(OPB.allowance(msg.sender, address(this)) == _opbStake, "Insufficient Allowance");
        require(OPB.transferFrom(msg.sender, address(this), _opbStake), "Transfer succesful"); 

        uint startEpoch = currentVoteEpoch;
        uint voteNum = 0;
        uint voteSuccessRate = 0;
        
        ValidatorInfo memory validatorInfo = ValidatorInfo(
            _opbStake, _commissionRate, startEpoch, voteNum, voteSuccessRate, msg.sender
        );


    }

    function unregisterValidator() {

    }

    function validatorWithdrawFund() {

    }

    function delegateStake() {

    }

    /*
    Storage Functions
    */
    function registerStorage(
        uint _pricePerByte, string memory _endpoint, uint _storageLimit, uint _status
    ) public payable {
        // Pay one time register fee (0.1 ETH)
        require(msg.value==100000000000000000);
        storageRegistrationFee += msg.value;

        // Register
        uint defaultCredibilityScore = 50; // 0~100
        StorageInfo memory storageInfo = StorageInfo(
            _pricePerByte, _endpoint, _storageLimit, defaultCredibilityScore, msg.sender, _status
        );
        storageInfoMap[msg.sender] = storageInfo;
    }

    function updateStorageInfo() {
        
    }

    function updateStorageStatus() {

    }

    function storageWithdrawFund() {

    }
}