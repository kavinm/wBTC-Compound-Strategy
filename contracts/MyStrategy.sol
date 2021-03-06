// SPDX-License-Identifier: MIT



pragma solidity ^0.6.11;
pragma experimental ABIEncoderV2;



import "../deps/@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "../deps/@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "../deps/@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
import "../deps/@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "../deps/@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";

import "../deps/@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "../deps/@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "../interfaces/badger/IController.sol";

//import "../interfaces/erc20/Erc20.sol";
import "../interfaces/compound/CTokenInterface.sol";
import "../interfaces/compound/Comptroller.sol";
import "../interfaces/uniswap/ISwapRouter.sol";





import {
    BaseStrategy
} from "../deps/BaseStrategy.sol";



// This is a test push

contract MyStrategy is BaseStrategy {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;
    using SafeMathUpgradeable for uint256;
    

    event MyLog(string, uint);

   // address public want; // Inherited from BaseStrategy, the token the strategy wants, swaps into and tries to grow
    address public lpComponent; // Token we provide liquidity with
    address public reward; // Token we farm and swap to want / lpComponent
    CTokenInterface cToken; //cWBTC object
    
    IERC20Upgradeable underlying; // ERC20 compliant wBTC object

    address public constant COMPTROLLER_ADDRESSS = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
    //address public constant COMP_TOKEN = 0xc00e94cb662c3520282e6f5717214004a7f26888;
    address public constant WETH_TOKEN = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address public constant ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    
   
    

    function initialize(
        address _governance,
        address _strategist,
        address _controller,
        address _keeper,
        address _guardian,
        address[3] memory _wantConfig,
        uint256[3] memory _feeConfig
       
       


    ) public initializer {
        __BaseStrategy_init(_governance, _strategist, _controller, _keeper, _guardian);

        /// @dev Add config here
        want = _wantConfig[0];
        lpComponent = _wantConfig[1];
        reward = _wantConfig[2];

        performanceFeeGovernance = _feeConfig[0];
        performanceFeeStrategist = _feeConfig[1];
        withdrawalFee = _feeConfig[2];

        cToken = CTokenInterface(lpComponent); //cToken object for cwBTC

         

        underlying = IERC20Upgradeable(want); //Erc20 object for wBTC

        /// @dev do one off approvals here
        // IERC20Upgradeable(want).safeApprove(gauge, type(uint256).max);
        IERC20Upgradeable(want).safeApprove(lpComponent, type(uint256).max); //approving WBTC for CWBTC contract

        IERC20Upgradeable(lpComponent).safeApprove(lpComponent, type(uint256).max); //approving CWBTC for CWBTC contract

        //CErc20(lpComponent).safeApprove(COMPTROLLER_ADDRESSS, type(uint256).max); //approving CWBTC for COMP

        /// @dev Allowance for Uniswap
        IERC20Upgradeable(reward).safeApprove(ROUTER, type(uint256).max); //approving comp to uniswap
        IERC20Upgradeable(WETH_TOKEN).safeApprove(ROUTER, type(uint256).max); //approving WETH to uniswap

        //IERC20Upgradeable(COMP_TOKEN).safeApprove(ROUTER, type(uint256).max);


    }



    /// ===== View Functions =====

    // @dev Specify the name of the strategy
    function getName() external override pure returns (string memory) {
        return "wBTC Compound Strategy";
    }

    // @dev Specify the version of the Strategy, for upgrades
    function version() external pure returns (string memory) {
        return "1.0";
    }
//comment
    /// @dev Balance of want currently held in strategy positions
    function balanceOfPool() public override view  returns (uint256) {

        uint256 exchangeRateMantissa = cToken.exchangeRateStored(); //exchange rate for cwBTC 
        //return 0;
        uint256 value  = exchangeRateMantissa * IERC20Upgradeable(lpComponent).balanceOf(address(this));
        
                         
                            
        //emit MyLog("what we want to see ", value);

        return value/10^18;

    }
    
    /// @dev Returns true if this strategy requires tending
    function isTendable() public override view returns (bool) {
       // return true;
       return balanceOfWant() > 0 ;
    }

    // @dev These are the tokens that cannot be moved except by the vault
    function getProtectedTokens() public override view returns (address[] memory) {
        address[] memory protectedTokens = new address[](3);
        protectedTokens[0] = want;
        protectedTokens[1] = lpComponent;
        protectedTokens[2] = reward;
        return protectedTokens;
    }

    /// ===== Permissioned Actions: Governance =====
    /// @notice Delete if you don't need!
    function setKeepReward(uint256 _setKeepReward) external {
        _onlyGovernance();
    }

    /// ===== Internal Core Implementations =====

    /// @dev security check to avoid moving tokens that would cause a rugpull, edit based on strat
    function _onlyNotProtectedTokens(address _asset) internal override {
        address[] memory protectedTokens = getProtectedTokens();

        for(uint256 x = 0; x < protectedTokens.length; x++){
            require(address(protectedTokens[x]) != _asset, "Asset is protected");
        }
    }




    /// @dev invest the amount of want
    /// @notice When this function is called, the controller has already sent want to this
    /// @notice Just get the current balance and then invest accordingly
    function _deposit( uint256 _amount) internal override {
         // Create a reference to the underlying asset contract, like DAI.
       

        // Create a reference to the corresponding lpComponent contract, like cDAI


        // Amount of current exchange rate from lpComponent to underlying
       
        // emit MyLog("Exchange Rate (scaled up): ", exchangeRateMantissa);

        

        // Approve transfer on the ERC20 contract
        underlying.approve(lpComponent, _amount);

        // Mint lpComponents
        uint mintResult = cToken.mint(_amount );
        // return mintResult;

        // emit MyLog("This is how much is minted", mintResult);

    }

    /// @dev utility function to withdraw everything for migration
    function _withdrawAll() internal override {
        cToken.redeemUnderlying(balanceOfPool());
        
    }


    /// @dev withdraw the specified amount of want, liquidate from lpComponent to want, paying off any necessary debt for the conversion
    function _withdrawSome(uint256 _amount) internal override returns (uint256) {

        if (_amount > balanceOfPool()) { 
            _amount = balanceOfPool();
        }
        
        cToken.redeemUnderlying(_amount );
        return _amount ;
    }

    /// @dev Harvest from strategy mechanics, realizing increase in underlying position
    function harvest() external whenNotPaused returns (uint256 harvested) {
        _onlyAuthorizedActors();


        uint256 _before = IERC20Upgradeable(want).balanceOf(address(this));

        // Write your code here 


        Comptroller troller = Comptroller(COMPTROLLER_ADDRESSS);
        troller.claimComp(address(this));

        uint256 rewardsAmount = IERC20Upgradeable(reward).balanceOf(address(this)); //how much comp we got

        if(rewardsAmount == 0){
            return 0;
        }
        return 0;

        //we will swap COMP to WETH and then WETH to WBTC to reduce slippage

        // Swap Rewards in UNIV3
        // NOTE: Unoptimized, can be frontrun and most importantly this pool is low liquidity
        ISwapRouter.ExactInputSingleParams memory fromRewardToWETHParams =
            ISwapRouter.ExactInputSingleParams(
                reward,  
                WETH_TOKEN,
                10000,
                address(this),
                now,
                rewardsAmount, // wei
                0,
                0
            );
        ISwapRouter(ROUTER).exactInputSingle(fromRewardToWETHParams);

        // // We now have AAVE tokens, let's get wBTC
        // // bytes memory path =
        // //     abi.encodePacked(
        // //         AAVE_TOKEN,
        // //         uint24(10000),
        // //         WETH_TOKEN,
        // //         uint24(10000),
        // //         want
        // //     );

        ISwapRouter.ExactInputSingleParams memory fromWETHTowBTCParams =
            ISwapRouter.ExactInputSingleParams(     
                WETH_TOKEN,
                want,
                10000,
                address(this),
                now,
                IERC20Upgradeable(WETH_TOKEN).balanceOf(address(this)),
                0,
                0
            );
        ISwapRouter(ROUTER).exactInputSingle(fromWETHTowBTCParams);

        uint256 earned =
            IERC20Upgradeable(want).balanceOf(address(this)).sub(_before);

        /// @notice Keep this in so you get paid!
        (uint256 governancePerformanceFee, uint256 strategistPerformanceFee) =
            _processPerformanceFees(earned);

        /// @dev Harvest event that every strategy MUST have, see BaseStrategy
        emit Harvest(earned, block.number);

        return earned;
    }
    

    //Alternative Harvest with Price received from harvester, used to avoid excessive front-running
    function harvest(uint256 price) external whenNotPaused returns (uint256 harvested) {
            return 0; //no implementation for now
    }

    /// @dev Rebalance, Compound or Pay off debt here
    function tend() external whenNotPaused {
        _onlyAuthorizedActors();

        uint256 toDeposit = balanceOfWant();
        
        if(toDeposit > 0){
            underlying.approve(lpComponent, toDeposit);
            uint mintResult = cToken.mint(toDeposit );


        }

    }


    /// ===== Internal Helper Functions =====
    
    /// @dev used to manage the governance and strategist fee, make sure to use it to get paid!
    function _processPerformanceFees(uint256 _amount) internal returns (uint256 governancePerformanceFee, uint256 strategistPerformanceFee) {
        governancePerformanceFee = _processFee(want, _amount, performanceFeeGovernance, IController(controller).rewards());

        strategistPerformanceFee = _processFee(want, _amount, performanceFeeStrategist, strategist);
    }
}
