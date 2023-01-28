pragma solidity ^0.8.15;
import "./IERC20.sol";

contract OpenBrowser {
    /*
    Client Associated Data
    */
    uint public pubkeyArrayLength;
    string[] public pubkeyArray; // [pubkey]
    mapping(string => DataInfo) public dataInfoMap; // pubkey => DataInfo
    mapping(address => uint) public clientBalance; // address => MATIC Credit Balance

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
    address[] public validatorAddressArray;
    mapping(address => ValidatorInfo) public validatorInfoMap;

    struct ValidatorInfo {
        uint opbStakedAmount;
        uint maticFeeBalance;
        uint registeredEpoch;
        uint totalValidVotes;
        address c;
        address validatorAddress;
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
        uint earnedCredit;
    }

    /*
    WhistleBlower Associated Data
    */
    mapping(address => WhistleBlowerInfo) public whistelBlowerInfoMap;

    string[] public whistleBlowerReportArray;
    
    struct WhistleBlowerInfo {
        address whisteBlowerAddress;
        uint collateralOpbAmount;
        uint trueReportNum;
        uint falseReportNum;
    }

    /*
    Block Associated Data
    */
    BlockInfo[] public blockInfoArray; //Store recent one block
    uint currentEpoch;

    struct BlockInfo {
        address client;
        uint paidAmount;
        address storageAddress;
        string pubkey;
    }

    /*
    Party Registration Functions
    */
    function registerValidator() public {
        require(validatorInfoMap[msg.sender].validatorAddress = address(0), "Validator is registered");
        ValidatorInfo memory validatorInfo = ValidatorInfo(
            0, 0, currentEpoch, 0, msg.sender
        );
    }

    function registerStorage(
        uint _pricePerByte, string memory _endpoint, uint _storageByteLimit
    ) public {
        require(storageInfoMap[msg.sender].storageAddress == address(0), "Storage is registered");
        StorageInfo memory storageInfo = StorageInfo(
            _pricePerByte, _endpoint, _storageByteLimit, msg.sender, 1, 0, 0
        );
    }



}