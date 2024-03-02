// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {FuzzExample} from "../src/FuzzExample.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract StatefulFuzz is StdInvariant, Test {
    FuzzExample fuzzExample;

    function setUp() public {
        fuzzExample = new FuzzExample();
        targetContract(address(fuzzExample));
    }

    function invariant__testShouldAlwaysBeZero_UsingStatefulFuzzing() public {
        uint256 expected = fuzzExample.shouldAlwaysBeZero();
        assertEq(expected, 0);
    }

    // FAIL. Reason: <empty revert data>]
    //     [Sequence]
    //             sender=0x63Be3F25e95CBe1334511596049DF4E958C402C9 addr=[src/FuzzExample.sol:FuzzExample]0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f calldata=doStuff(uint256) args=[7]
    //             sender=0x0000000000000000000000000000000000000Eb3 addr=[src/FuzzExample.sol:FuzzExample]0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f calldata=doStuff(uint256) args=[412]

    // -------

    // when data == 7
    // hiddenValue will become 7
    // on next iteration whatever data can be, but hiddenValue will be 7
    // since hiddenvalue is 7
    // test will fail
}
