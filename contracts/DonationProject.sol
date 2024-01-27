// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract DonationProject {
    using SafeERC20 for IERC20;

    address public owner;
    uint256 public targetTokens;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public totalReceivedTokens;
    bool public transferOnContract;
    bool public fundsReleased;

    mapping(address => uint256) public donorTokens;
    mapping(address => bool) public donors;
    
    event DonationReceived(address indexed donor, uint256 amount);
    event FundsReleased(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier projectActive() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Project not active");        
        _;
    }

    modifier fundsNotReleased() {
        require(!fundsReleased, "Funds already released");
        _;
    }

    constructor(
        address _owner,
        uint256 _targetTokens,
        uint256 _startTime,
        uint256 _endTime
    ) {
        owner = _owner;
        targetTokens = _targetTokens;
        startTime = _startTime;
        endTime = _endTime;
    }

    function donate(uint256 _amount, IERC20 _token) external projectActive fundsNotReleased {
        donorTokens[msg.sender] += _amount;
        totalReceivedTokens += _amount;
        donors[msg.sender] = true;

        emit DonationReceived(msg.sender, _amount);
        
        _token.safeTransferFrom(msg.sender, address(this), _amount);

        if (totalReceivedTokens >= targetTokens || block.timestamp > endTime) {
            releaseFunds(_token);
        }
    }

    function donate(uint256 _amount) external projectActive fundsNotReleased {
        donorTokens[msg.sender] += _amount;
        totalReceivedTokens += _amount;
        donors[msg.sender] = true;

        emit DonationReceived(msg.sender, _amount);
        
        if (totalReceivedTokens >= targetTokens || block.timestamp > endTime) {
            releaseFunds();
        }
    }

    function releaseFunds(IERC20 _token) internal {
        require(totalReceivedTokens > 0, "No funds to release");

        fundsReleased = true;

        _token.safeTransfer(owner, totalReceivedTokens);

        emit FundsReleased(totalReceivedTokens);
    }

    function releaseFunds() internal {
        require(totalReceivedTokens > 0, "No funds to release");

        fundsReleased = true;

        emit FundsReleased(totalReceivedTokens);
    }

    function getDonorTokens(address _donor) external view returns (uint256) {
        return donorTokens[_donor];
    }

    function getTotalReceivedTokens() external view returns (uint256) {
        return totalReceivedTokens;
    }
    
    function isDonor(address _address) external view returns (bool) {
        return donors[_address];
    }
}