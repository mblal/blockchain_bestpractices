
var Test = require('../config/testConfig.js');

contract('ExerciseC6A', async (accounts) => {

  var config;
  before('setup contract', async () => {
    config = await Test.Config(accounts);
  });

  it('contract owner can register new user', async () => {
    
    // ARRANGE
    let caller = accounts[0]; // This should be config.owner or accounts[0] for registering a new user
    let newUser = config.testAddresses[0]; 

    // ACT
    await config.exerciseC6A.registerUser(newUser, false, {from: caller});
    let result = await config.exerciseC6A.isUserRegistered.call(newUser); 

    // ASSERT
    assert.equal(result, true, "Contract owner cannot register new user");

  });

  it.skip('should pause the contract when the caller is the owner', async () => {

    // ARRANGE
    let caller = accounts[0]; // This should be config.owner or accounts[0] for registering a new user
    let newUser = config.testAddresses[1]; 
    let newUser2 = config.testAddresses[2]; 

    // ACT
    await config.exerciseC6A.registerUser(newUser, false, {from: caller});
    await config.exerciseC6A.setOperationgStatus(false, {from: caller});
    
    let result = await config.exerciseC6A.isUserRegistered.call(newUser); 
  });

  it('should pause and reactive contract when two admin at least have consensus', async () => {

    let caller = accounts[0];

    let _admin1 = accounts[1];
    let _admin2 = accounts[2];
    let _admin3 = accounts[3];

    let admin1 = config.testAddresses[4];
    let admin2 = config.testAddresses[5];
    let admin3 = config.testAddresses[6];

    await config.exerciseC6A.registerUser(_admin1, true, {from: config.owner});
    await config.exerciseC6A.registerUser(_admin2, true, {from: config.owner});

    let currentStatus = true;

    let targetStatus = !currentStatus;
    
    await config.exerciseC6A.setOperationgStatus(targetStatus, {from: _admin1});

    let result = await config.exerciseC6A.isOperational.call();

    // ASSERT

    assert.equal(currentStatus, result, "Error");

    await config.exerciseC6A.setOperationgStatus(targetStatus, {from: _admin2});

    result = await config.exerciseC6A.isOperational.call();

    assert.equal(targetStatus, false, "Error");
  })
 
});
