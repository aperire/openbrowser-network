pragma solidity ^0.8.15;
import "./IERC20.sol";

contract OpenBrowser {
    // OPB Token Address
    IERC20 OPB = IERC20(0x87c6eCcD1074108f71843368DE3ccC86274217dF);
    /*
    Client Associated Data
    */
    uint public pubkeyArrayLength;
    string[] public pubkeyArray; // [pubkey]
    string[] public pubkeyMempoolArray;

    mapping(string => DataInfo) public dataInfoMap; // pubkey => DataInfo
    mapping(address => uint) public clientRefundBalance; // address => MATIC Refund Balance

    struct DataInfo {
        uint paidAmount;
        address storageAddress;
        address creator;
        bool isValidated;
    }

    /*
    Validator Associated Data
    */
    uint public totalStakedOpb;
    uint public currentEpochOpbVoted;
    uint public numValidators;
    uint public currentEpochGasRewards;
    address[] public validatorAddressArray;
    string[] public whistleBlowerReportArray;
    mapping(address => ValidatorInfo) public validatorInfoMap;

    struct ValidatorInfo {
        uint opbStakedAmount;
        uint gasRewardAmount;
        uint registeredEpoch;
        uint totalValidVotes;
        address validatorAddress;
        uint whisteBlowerRewardAmount;
    }

    /*
    Storage Associated Data
    */
    uint public numStorage;
    address[] public storageAddressArray;
    mapping(address => StorageInfo) public storageInfoMap;

    struct StorageInfo {
        uint pricePerByte;
        string endpoint;
        uint storageByteLimit;
        address storageAddress;
        uint status; // 0 if online, 1 if offline
        uint collateralOpbAmount;
        uint gasRewardAmount;
    }


    /*
    Block Associated Data
    */
    string[] public blockArray; //Store pubkey of recent one block
    uint currentEpoch;

    /*
    Party Registration Functions
    */
    function registerValidator() public {
        require(validatorInfoMap[msg.sender].validatorAddress == address(0), "Validator is registered");
        ValidatorInfo memory validatorInfo = ValidatorInfo(
            0, 0, currentEpoch, 0, msg.sender, 0
        );
        validatorAddressArray.push(msg.sender);
        validatorInfoMap[msg.sender] = validatorInfo;
    }

    function registerStorage(
        uint _pricePerByte, string memory _endpoint, uint _storageByteLimit
    ) public {
        require(storageInfoMap[msg.sender].storageAddress == address(0), "Storage is registered");
        StorageInfo memory storageInfo = StorageInfo(
            _pricePerByte, _endpoint, _storageByteLimit, msg.sender, 1, 0, 0
        );
    }

    /*
    Account Management Functions
    */
    function validatorDepositStake(uint _amount) public {
        require(validatorInfoMap[msg.sender].validatorAddress == msg.sender, "Create validator account before deposit");
        require(_amount > 0, "Need to be above 0");
        totalStakedOpb += _amount;
        ValidatorInfo memory validatorInfo = validatorInfoMap[msg.sender];
        validatorInfo.opbStakedAmount += _amount;
        require(OPB.transferFrom(msg.sender, address(this), _amount), "Transfer Failed");
    }

    function validatorWithdrawStake(uint _amount) public {
        require(validatorInfoMap[msg.sender].validatorAddress == msg.sender, "Create validator account before deposit");
        require(_amount > 0, "Need to be above 0");
        require(validatorInfoMap[msg.sender].opbStakedAmount >= _amount, "Cannot withdraw more than staked");
        require(_amount <= OPB.balanceOf(address(this)), "Insufficient balance in contract");
        ValidatorInfo memory validatorInfo = validatorInfoMap[msg.sender];
        validatorInfo.opbStakedAmount -= _amount;
        OPB.approve(address(this), _amount);
        require(OPB.transferFrom(address(this), msg.sender, _amount), "Withdraw Failed");
    }

    function validatorWithdrawGasReward(uint _amount) public {
        require(validatorInfoMap[msg.sender].validatorAddress == msg.sender, "Create validator account before deposit");
        require(_amount > 0, "Need to be above 0");
        require(validatorInfoMap[msg.sender].gasRewardAmount >= _amount, "Cannot withdraw");
        address validatorAddress = msg.sender;
    }

    function validatorWithdrawWhistelBlowerReward(){}

    function storageDepositCollateral(){}

    function storageWithdrawGasReward(){}

    /*
    Payment Functions
    */
    function postTransaction(
        uint _byteSize, string memory _pubkey, address _storageAddress
    ) public {
        // Calculate price
        uint uploadPrice = storageInfoMap[_storageAddress].pricePerByte * _byteSize;
        // Check
        require(msg.value == uploadPrice, "Payment amount does not match");
        storageInfoMap[_storageAddress].gasRewardAmount += msg.value * 9 / 10;
        currentEpochGasRewards += msg.value / 10;
        // Add dataInfo to block (not add to pubkeyArray until validated)
        DataInfo memory dataInfo = DataInfo(uploadPrice, _storageAddress, msg.sender, false);
        dataInfoMap[_pubkey] = dataInfo;
        pubkeyMempoolArray.push(_pubkey)
        blockArray.push(_pubkey);
    }

    /*
    Validator Functions
    */
    function voteInvalidPubkeyInLastBlock(string [] memory _invalidPubkeyArray) public {
        require(validatorInfoMap[msg.sender].validatorAddress == msg.sender, "Only Validators can vote");

    }

    function whistleBlowerReportDeletedPubkey()



}