// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Item {
    uint256 public priceInWei;
    uint256 public pricePaid;
    uint256 public index;

    ItemManager parentContract;

    constructor(
        ItemManager _parentContract,
        uint256 _priceInWei,
        uint256 _index
    ) public {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "item is paid already");
        require(priceInWei == msg.value, "only full payments allowed");
        require(pricePaid == 0, "item is paid already");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call{value: msg.value}(
            abi.encodeWithSignature("triggerPayment(uint256)", index)
        );
        require(success, "the transaction wanst sucessful, cancelling");
    }

    fallback() external {}
}
