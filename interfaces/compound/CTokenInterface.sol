// Copyright (C) 2020 Zerion Inc. <https://zerion.io>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
//
// SPDX-License-Identifier: LGPL-3.0-only
//it was supposed to be redeemAmount as a parameter for redeemUnderlying and uint paramters were made uint256
pragma solidity ^0.6.11;

/**
 * @dev CErc20 contract interface.
 * The CErc20 contract is available here
 * github.com/compound-finance/compound-protocol/blob/master/contracts/CErc20.sol.
 */
interface CTokenInterface {

    // function borrowBalanceCurrent(address) external returns (uint256);

    // function exchangeRateCurrent() external returns (uint256);

    // function exchangeRateStored() external view returns (uint256);

    // function mint(uint256) external returns (uint256);

    // function redeem(uint256) external returns (uint256);

    // function redeemUnderlying(uint256 ) external returns (uint256); 

    // function borrowBalanceStored(address) external view returns (uint256);

    // function underlying() external view returns (address);

    // function borrowIndex() external view returns (uint256);
    //  function transfer(address dst, uint amount) external returns (bool);
    // function transferFrom(address src, address dst, uint amount) external returns (bool);
    // function approve(address spender, uint amount) external returns (bool);
    // function allowance(address owner, address spender) external view returns (uint);
    // function balanceOf(address owner) external view returns (uint);
    // function balanceOfUnderlying(address owner) external returns (uint);
    // function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
    // function borrowRatePerBlock() external view returns (uint);
    // function supplyRatePerBlock() external view returns (uint);
    // function totalBorrowsCurrent() external returns (uint);
    // function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);


     function transfer(address dst, uint amount) external returns (bool);
    function transferFrom(address src, address dst, uint amount) external returns (bool);
    function approve(address spender, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function balanceOfUnderlying(address owner) external returns (uint);
    function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
    function borrowRatePerBlock() external view returns (uint);
    function supplyRatePerBlock() external view returns (uint);
    function totalBorrowsCurrent() external returns (uint);
    function borrowBalanceCurrent(address account) external returns (uint);
    function borrowBalanceStored(address account) external view returns (uint);
    function exchangeRateCurrent() external returns (uint);
    function exchangeRateStored() external view returns (uint);
    function getCash() external view returns (uint);
    function accrueInterest() external returns (uint);
    function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);

     function mint(uint mintAmount) external returns (uint);
    function redeem(uint redeemTokens) external returns (uint);
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function repayBorrow(uint repayAmount) external returns (uint);
    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
    function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) external returns (uint);






}
