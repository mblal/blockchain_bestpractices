pragma solidity >=0.4.25;

contract ExerciseC6A {


    bool private operational = true;
    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/
    uint constant M = 2;
    uint counter = 0;
    struct UserProfile {
        bool isRegistered;
        bool isAdmin;
    }

    address private contractOwner;                  // Account used to deploy contract
    mapping(address => UserProfile) userProfiles;   // Mapping for storing user profiles

    address[] multiCallers = new address[](0);

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    // No events

    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
                                (
                                ) 
                                public 
    {
        contractOwner = msg.sender;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireIsOperational()
    {
        require(operational == true, "The contract is paused");
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

   /**
    * @dev Check if a user is registered
    *
    * @return A bool that indicates if the user is registered
    */   
    function isUserRegistered
                            (
                                address account
                            )
                            external
                            view
                            returns(bool)
    {
        require(account != address(0), "'account' must be a valid address.");
        return userProfiles[account].isRegistered;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function registerUser
                                (
                                    address account,
                                    bool isAdmin
                                )
                                external
                                requireContractOwner
                                requireIsOperational
    {
        require(!userProfiles[account].isRegistered, "User is already registered.");

        userProfiles[account] = UserProfile({
                                                isRegistered: true,
                                                isAdmin: isAdmin
                                            });
    }
    function isOperational() public view returns(bool) {
        return operational;
    }
    function setOperationgStatus(bool _operational) external
    //requireContractOwner
    {

        require(operational != _operational, "The State is already in the same value");
        require(userProfiles[msg.sender].isAdmin, "Caller is not an admin");


        bool isIN = false;

        for(uint c = 0; c < multiCallers.length; c++){
            if (multiCallers[c] == msg.sender){
                isIN = true;
                break;
            }
        }
        require(!isIN, "Caller has already called this function.");

        multiCallers.push(msg.sender);
        if (multiCallers.length >= M) {
             operational = _operational;
             multiCallers = new address[](0);
        }


    }
}

