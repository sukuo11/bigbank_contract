// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBank {
        function withdraw() external;
}

contract Ownerable{
    function withdraw(address bbAddress) external {
        IBank(bbAddress).withdraw();
    }

    receive() external payable { }

}

contract Bank{

    mapping(address => uint) public balances;
    address payable public owner;
    uint eth_balance;
    address[3] public top_3;

    constructor() {
    owner = payable(msg.sender);
    }

    receive() external virtual payable { 
        deposit;
    }
    

    function deposit() public virtual payable { 
        balances[msg.sender] = balances[msg.sender] + msg.value;
        eth_balance += msg.value;
        if (balances[top_3[0]] < balances[msg.sender]){
            if (top_3[1] == msg.sender){
                top_3[1] = top_3[0];
                top_3[0] = msg.sender;
            }
            else {
            top_3[2] = top_3[1];
            top_3[1] = top_3[0];
            top_3[0] = msg.sender;
            }
            
        }
        else if (balances[top_3[1]] < balances[msg.sender]){
            top_3[2] = top_3[1];
            top_3[1] = msg.sender;
        }
        else if (balances[top_3[2]] < balances[msg.sender]){
            top_3[2] = msg.sender;
        }

        
    }
    
    function withdraw() public virtual {
        require(msg.sender == owner);
        payable(msg.sender).transfer(eth_balance);
        eth_balance = 0;
    }
}

contract BigBank is Bank{
    modifier minAmount {
        require(msg.value > 1000000000000000, "Min amount require.");
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    function transferOnwer(address newOwner) public onlyOwner {
        owner = payable (newOwner);
    }

    receive() external override payable minAmount{ 
        deposit;
    }

    function deposit() public override payable  minAmount{
        super.deposit();
    } 

}