// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LongsSwap {
    IERC20 public adaToken;
    address public adaTokenOwner;

    IERC20 public web3bridgeToken;
    address public web3bridgeTokenOwner;

    constructor(
        address _adaToken,
        address _adaTokenOwner,
        address _web3bridgeToken,
        address _web3bridgeTokenOwner
    ) {
        adaToken = IERC20(_adaToken);
        adaTokenOwner = _adaTokenOwner;

        web3bridgeToken = IERC20(_web3bridgeToken);
        web3bridgeTokenOwner = _web3bridgeTokenOwner;
    }

    function swapToken(uint _adaTokenAmount, uint _web3bridgeTokenAmount)
        public
    {
        uint adaTokenAmount = _adaTokenAmount * 10e18;
        uint web3bridgeTokenAmount = _web3bridgeTokenAmount * 10e18;

        require(
            msg.sender == adaTokenOwner || msg.sender == web3bridgeTokenOwner,
            "Not authorized"
        );
        require(
            adaToken.allowance(adaTokenOwner, address(this)) >= adaTokenAmount,
            "adaToken allowance is small"
        );
        require(
            web3bridgeToken.allowance(web3bridgeTokenOwner, address(this)) >=
                web3bridgeTokenAmount,
            "web3bridgeToken allowance is small"
        );

        _safeTransferFrom(
            adaToken,
            adaTokenOwner,
            web3bridgeTokenOwner,
            adaTokenAmount
        );
        _safeTransferFrom(
            web3bridgeToken,
            web3bridgeTokenOwner,
            adaTokenOwner,
            web3bridgeTokenAmount
        );
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}

// AdaToken address 0xd9145CCE52D386f254917e481eB44e9943F39138
// AdaToken owner 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

// web3bridge token address 0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95
// web3bridgetoken owner address 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
