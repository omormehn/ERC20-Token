// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract Token is ERC20 {
    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
    {
        _mint(msg.sender, 10000000 * 10**18);
    }
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}


contract Bank {
    
    enum Status {
        FAILED, 
        SUCCESSFULL
    }

    struct user {
        string name;
        address _address;
        uint balances; //balance of custom token
    }

    Token public token; // Your custom token contract
    mapping(address => user) public users;
    uint256 public minimumDepositAmount = 10 ether;
    uint256 public maximumWithdrawalAmount = 1 ether;
    Status public status;

    constructor(Token _token) {
        token = _token; // Initialize your token contract
    }

       
    
    function getStatus() public view returns (string memory message) {
        if (status == Status.FAILED) {
            return "Failed";
        } else if (status == Status.SUCCESSFULL) {
            return "Successfull";
        }
    }
    

    modifier onlyUser() {
        require(msg.sender == tx.origin, "Caller should be a user, not a contract");
        _;
    }

    
    // Mint some tokens to the bank's address
    function mintTokens(uint256 _amount) public payable onlyUser  {
        token.mint(address(this), _amount);
    }
    

    //Deposit function
    function deposit(uint256 _amount) public payable {
        require(msg.value >= minimumDepositAmount, "Deposited Amount is less than the minimum required");
        // Transfer the deposited amount from the user's wallet to the bank's wallet
        SafeERC20.safeTransferFrom(token, msg.sender, address(this), _amount);

        // Add the deposited amount to the user's balance
        users[msg.sender].balances += _amount;
        status = Status.SUCCESSFULL;
        
    }

    
    // Withdrawal function
    function withdraw(uint256 _amount) public onlyUser returns (Status) {
        //set withdrawal limit
        require(_amount <= maximumWithdrawalAmount, "Amount exceeds withdrawal limit");

        //check if caller has sufficient amount
        require(users[msg.sender].balances >= _amount, "");

        // Subtract the withdrawn amount from the user's balance
        users[msg.sender].balances -= _amount;

        // Transfer the withdrawn amount to the user's wallet
        SafeERC20.safeTransfer(token, msg.sender, _amount);

        return Status.SUCCESSFULL;

       
    }
}