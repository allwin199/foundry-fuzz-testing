// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {FuzzExample} from "../src/FuzzExample.sol";

contract StatelessFuzz is Test {
    FuzzExample fuzzExample;

    function setUp() public {
        fuzzExample = new FuzzExample();
    }

    // uint testing
    function test_ShouldAlwaysBeZero() public {
        uint256 data = 2;
        fuzzExample.doStuff(data);
        uint256 expected = fuzzExample.shouldAlwaysBeZero();
        assertEq(expected, 0);
    }

    // Stateless Fuzzing
    function test_ShouldAlwaysBeZeroUsing_StatelessFuzzing(uint256 data) public {
        // Fuzzing will try some randome big numbers.
        // we can set the bound.

        data = bound(data, 0, 500);
        fuzzExample.doStuff(data);

        uint256 expected = fuzzExample.shouldAlwaysBeZero();
        assertEq(expected, 0);
    }
}
