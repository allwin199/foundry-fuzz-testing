// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract FuzzExample {
    uint256 public shouldAlwaysBeZero = 0;

    uint256 private hiddenValue = 0;

    function doStuff(uint256 data) public {
        if (data == 142) {
            shouldAlwaysBeZero = 1;
        }

        if (hiddenValue == 7) {
            shouldAlwaysBeZero = 1;
        }

        hiddenValue = data;
    }
}
