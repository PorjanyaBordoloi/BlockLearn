// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearningAnalytics {
    struct Profile {
        string name;
        string[] skills;
        string[] achievements;
    }

    // Mappings for storing profiles
    mapping(address => Profile) public profiles;
    mapping(string => address) private nameToAddress;

    // Create or update a profile, including the student's name
    function createOrUpdateProfile(string memory _name) public {
        // Ensure the name is unique and not already taken by another user
        require(nameToAddress[_name] == address(0) || nameToAddress[_name] == msg.sender, "Name already taken by another user.");

        // If the name is new, map it to the sender's address
        if (bytes(profiles[msg.sender].name).length == 0) {
            nameToAddress[_name] = msg.sender;
        } else {
            // If the user already had a profile with a different name, remove the old name mapping
            nameToAddress[profiles[msg.sender].name] = address(0);
            nameToAddress[_name] = msg.sender;
        }

        profiles[msg.sender].name = _name;
    }

    // Add a skill
    function addSkill(string memory _skill) public {
        require(bytes(profiles[msg.sender].name).length > 0, "Profile not created. Please create a profile first.");
        profiles[msg.sender].skills.push(_skill);
    }

    // Add an achievement
    function addAchievement(string memory _achievement) public {
        require(bytes(profiles[msg.sender].name).length > 0, "Profile not created. Please create a profile first.");
        profiles[msg.sender].achievements.push(_achievement);
    }

    // Retrieve profile information by name
    function getProfileByName(string memory _name) public view returns (
        string memory name,
        string[] memory skills,
        string[] memory achievements
    ) {
        address userAddress = nameToAddress[_name];
        require(userAddress != address(0), "Profile with this name does not exist.");

        Profile storage profile = profiles[userAddress];
        return (
            profile.name,
            profile.skills,
            profile.achievements
        );
    }
}
