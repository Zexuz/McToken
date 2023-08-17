// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

interface ISimpleLiquidityPool {
    function addLiquidity(uint256 amountA, uint256 amountB) external;
    function removeLiquidity(uint256 amountA, uint256 amountB) external;
    function swapTokenAForTokenB(uint256 amount) external;
    function swapTokenBForTokenA(uint256 amount) external;

    function addLiquidityCCIP(uint256 amountA, uint256 amountB, address sender) external; //Only ccip can call
    function removeLiquidityCCIP(uint256 amountA, uint256 amountB, address sender) external; //Only ccip can call
    function swapTokenAForTokenBCCIP(uint256 amount, address sender) external; //Only ccip can call
    function swapTokenBForTokenACCIP(uint256 amount, address sender) external; //Only ccip can call
}

contract SimpleLiquidityPool is ISimpleLiquidityPool {
    IERC20 public tokenA;
    IERC20 public tokenB;
    address public ccipRouter;
    address public owner;

    constructor(address _tokenA, address _tokenB, address _ccipRouter) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        ccipRouter = _ccipRouter;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        assert (msg.sender == owner);
        _;
    }

    modifier onlyCCIP() {
        assert (msg.sender == ccipRouter);
        _;
    }

    function setCCIPRouter(address _ccipRouter) external onlyOwner {
        ccipRouter = _ccipRouter;
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external {
        _addLiquidity(amountA, amountB, msg.sender);
    }

    function removeLiquidity(uint256 amountA, uint256 amountB) external {
        _removeLiquidity(amountA, amountB, msg.sender);
    }

    function swapTokenAForTokenB(uint256 amount) external {
        _swapTokenAForTokenB(amount, msg.sender);
    }

    function swapTokenBForTokenA(uint256 amount) external {
        _swapTokenBForTokenA(amount, msg.sender);
    }

    function addLiquidityCCIP(uint256 amountA, uint256 amountB, address sender) external onlyCCIP {
        _addLiquidity(amountA, amountB, sender);
    }

    function removeLiquidityCCIP(uint256 amountA, uint256 amountB, address sender) external onlyCCIP {
        _removeLiquidity(amountA, amountB, sender);
    }

    function swapTokenAForTokenBCCIP(uint256 amount, address sender) external onlyCCIP {
        _swapTokenAForTokenB(amount, sender);
    }

    function swapTokenBForTokenACCIP(uint256 amount, address sender) external onlyCCIP {
        _swapTokenBForTokenA(amount, sender);
    }

    function _addLiquidity(uint256 amountA, uint256 amountB, address sender) private {
        require(tokenA.transferFrom(sender, address(this), amountA), "Transfer of token A failed");
        require(tokenB.transferFrom(sender, address(this), amountB), "Transfer of token B failed");
    }

    function _removeLiquidity(uint256 amountA, uint256 amountB, address sender) private {
        require(tokenA.balanceOf(address(this)) >= amountA, "Insufficient token A in pool");
        require(tokenB.balanceOf(address(this)) >= amountB, "Insufficient token B in pool");

        require(tokenA.transfer(sender, amountA), "Transfer of token A failed");
        require(tokenB.transfer(sender, amountB), "Transfer of token B failed");
    }

    function _swapTokenAForTokenB(uint256 amount, address sender) private {
        require(tokenA.transferFrom(sender, address(this), amount), "Transfer of token A failed");
        require(tokenB.balanceOf(address(this)) >= amount, "Insufficient token B in pool");

        require(tokenB.transfer(sender, amount), "Transfer of token B failed");
    }

    function _swapTokenBForTokenA(uint256 amount, address sender) private {
        require(tokenB.transferFrom(sender, address(this), amount), "Transfer of token B failed");
        require(tokenA.balanceOf(address(this)) >= amount, "Insufficient token A in pool");

        require(tokenA.transfer(sender, amount), "Transfer of token A failed");
    }

}

