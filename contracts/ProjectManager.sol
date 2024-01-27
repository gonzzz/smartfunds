// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DonationProject.sol";

contract ProjectManager {
    address[] public donationProjects;
    
    function createDonationProject(
        address _owner,
        uint256 _targetTokens,
        uint256 _startTime,
        uint256 _endTime
    ) external {
        DonationProject newProject = new DonationProject(
            _owner,
            _targetTokens,
            _startTime,
            _endTime
        );
        donationProjects.push(address(newProject));
    }

    function getAllProjects() external view returns (address[] memory) {
        return donationProjects;
    }

    function getOwnerProjects() external view returns (address[] memory) {
        address[] memory ownerProjects = new address[](donationProjects.length);
        uint256 count = 0;
        for (uint256 i = 0; i < donationProjects.length; i++) {
            DonationProject project = DonationProject(donationProjects[i]);
            if (project.owner() == msg.sender) {
                ownerProjects[count] = donationProjects[i];
                count++;
            }
        }
        return ownerProjects;
    }

    function getDonorProjects() external view returns (address[] memory) {
        address[] memory donorProjects = new address[](donationProjects.length);
        uint256 count = 0;
        for (uint256 i = 0; i < donationProjects.length; i++) {
            DonationProject project = DonationProject(donationProjects[i]);
            if (project.isDonor(msg.sender)) {
                donorProjects[count] = donationProjects[i];
                count++;
            }
        }
        return donorProjects;
    }
}