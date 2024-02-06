const ProjectManager = artifacts.require("ProjectManager");
const DonationProject = artifacts.require("DonationProject");

contract("ProjectManager", accounts => {
    console.log("Accounts: ", accounts);

    it('donationProjects Array is Empty at the begining', async () => {
        let instance = await ProjectManager.deployed();
        const _allProjects = await instance.getAllProjects();
        console.log("Projects: ", _allProjects);

        assert.equal(_allProjects.length, 0);
    });

    it('adding a new project and then returns not empty donationsProjects Array and Project properties matches with constructor arguments', async () => {
        let instance = await ProjectManager.deployed();
        
        let owner = accounts[1];
        let targetTokens = 10000;
        let startTime = new Date().getTime();
        let endTime = startTime + (5 * 60 * 1000);
        console.log("Creating a Donation Project with Arguments: Owner='", owner, "', Target=", targetTokens.toString(), ", Start=", startTime.toString(), ", End=", endTime.toString());
        await instance.createDonationProject.sendTransaction(owner, targetTokens, startTime, endTime);

        const _allProjects = await instance.getAllProjects();
        console.log("Projects: ", _allProjects);

        assert.equal(_allProjects.length, 1);

        let createdProject = await DonationProject.at(_allProjects[0]);
        
        let projectOwner = await createdProject.owner();
        let projectTargetTokens = await createdProject.targetTokens();
        let projectStartTime = await createdProject.startTime();
        let projectEndTime = await createdProject.endTime();

        console.log("Get a New Donation Project from getAllProjects() with Params: Owner='", projectOwner, "', Target=", projectTargetTokens.toString(), ", Start=", projectStartTime.toString(), ", End=", projectEndTime.toString());

        assert.equal(projectOwner, accounts[1]);
        assert.equal(projectTargetTokens, targetTokens);
        assert.equal(projectStartTime, startTime);
        assert.equal(projectEndTime, endTime);
    });
});