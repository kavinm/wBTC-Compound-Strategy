// SPDX-License-Identifier: LGPL-3.0-only
//it was supposed to be redeemAmount as a parameter for redeemUnderlying and uint paramters were made uint256
pragma solidity ^0.6.11;

/**
 * @dev ComptrollerInterface contract interface.
 * The ComptrollerInterface contract is available here
 * github.com/compound-finance/compound-protocol/blob/master/contracts/ComptrollerInterface.sol.
 */
interface Comptroller {

    function claimComp(address) external;

    function claimComp(address, uint) external;

}
