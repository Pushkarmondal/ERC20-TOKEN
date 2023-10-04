// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//Declaring the solidity version.

interface IERC20 {

 // ** Calling the ERC-20 Interface to implement its functions **.

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// ** Actual token contract **.

contract SampleToken is IERC20 {
    using SafeMath for uint256;

    string public constant name = "SampleToken";
    string public constant symbol = "SMT";
    uint8 public constant decimals = 18;
    
    // ** Creating two mapping functions that will grant users the ability to spend these tokens **.

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    // ** Initializing the constructor and total supply value and balances for our token. Declaring the total supply of the token to be equal to your wallet’s balance for this token **.

    constructor(uint256 total) {
         totalSupply_ = total;
         balances[msg.sender] = totalSupply_;
     }
    
    // **Function totalSupply which will govern the total supply of our token **.

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }
    
    // **Function balanceOf which will check the balance of a wallet address **.

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }
    
    // ** Function transfer which will execute the transfer of tokens from the total supply to users **.

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    // ** Function approve which will check if the total supply has the amount of token which needs to be allocated to a user **.

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    // ** Function allowance which will check if a user has enough balance to perform the transfer to another user **.

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    // ** Function transferFrom which will facilitate the transfer of token between users **.

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

// ** Calling the Safe Math interface to use math functions in our contract **.
library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}
