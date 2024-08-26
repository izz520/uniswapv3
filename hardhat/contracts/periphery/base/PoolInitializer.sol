// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.8.18;

import "../../factory/interfaces/IUniswapV3Factory.sol";
import "../../factory/interfaces/IUniswapV3Pool.sol";

import "./PeripheryImmutableState.sol";
import "../interfaces/IPoolInitializer.sol";

/// @title Creates and initializes V3 Pools
import "hardhat/console.sol";

abstract contract PoolInitializer is IPoolInitializer, PeripheryImmutableState {
    /// @inheritdoc IPoolInitializer
    function createAndInitializePoolIfNecessary(
        address token0,
        address token1,
        uint24 fee,
        uint160 sqrtPriceX96
    ) external payable override returns (address pool) {
        require(token0 < token1);
        pool = IUniswapV3Factory(factory).getPool(token0, token1, fee);
        console.log("getPool address: ", pool);
        if (pool == address(0)) {
            console.log(token0, token1, fee, sqrtPriceX96);
            // console.log("don't have pool, create pool: ",token0, token1, fee, sqrtPriceX96);
            pool = IUniswapV3Factory(factory).createPool(token0, token1, fee);
            console.log("createPool address: ", pool);
            IUniswapV3Pool(pool).initialize(sqrtPriceX96);
            console.log("initialize Success");
        } else {
            (uint160 sqrtPriceX96Existing, , , , , , ) = IUniswapV3Pool(pool)
                .slot0();
            if (sqrtPriceX96Existing == 0) {
                IUniswapV3Pool(pool).initialize(sqrtPriceX96);
            }
        }
    }
}
