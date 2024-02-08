Stateful Fuzzing : Fuzzing where the final state of your previous run is the starting state of your next run

```sol
uint256 private shouldAlwaysBeZero = 0;

uint256 private hiddenValue = 0;

function doStuff(uint256 data){
    if(data == 142){
        shouldAlwaysBeZero = 1;
    }

    if(hiddenValue == 7){
        shouldAlwaysBeZero = 1;
    }

    hiddenValue = data;
}

```

In this scenario whatever input we give to the `doStuff` function `shouldAlwaysBeZero` should remain as 0.

-   `shouldAlwaysBeZero` is the `INVARIANT`
-   Invariant -> Property of our system that should always hold

Instead of iterating one by one, we can use Fuzz testing.

```sol
function test_ShouldAlwaysRemainZero(uint256 testData) public {
    // when we give input to a test function It becomes stateless fuzzing
    // foundry will throw some random data at it

    doStuff(testData);

    assertEq(shouldAlwaysBeZero, 0);
}
```

By using fuzz testing we are able to catch a one bug

-   Stateless Fuzzing: Where the state of the previous run is discarded for every new run.

---

We were able to catch one bug, but there are more bugs.

For eg: `if(hiddenValue == 7)` then our Invariant should fail

since using stateless fuzz testing our final state of the previous run is discarded, stateless fuzz testing will not catch this bug.

because, everytime our stateless fuzz test starts, hiddenvalue will be 0.

---

When we use stateful fuzz testing we can catch this bug

-   To write a stateful fuzz testing our test should start with Invariant keyword and needs some setup

```sol
uint256 private shouldAlwaysBeZero = 0;

uint256 private hiddenValue = 0;

function doStuff(uint256 data){
    if(data == 142){
        shouldAlwaysBeZero = 1;
    }

    if(hiddenValue == 7){
        shouldAlwaysBeZero = 1;
    }

    hiddenValue = data;
}

```

```sol
function test_ShouldAlwaysRemainZero(uint256 testData) public {
    // when we give input to a test function It becomes stateless fuzzing
    // foundry will throw some random data at it

    doStuff(testData);

    assertEq(shouldAlwaysBeZero, 0);
}
```

---

Invariant Test

-   Let's setup the target contract
-   This target contract will specify which function to call and in which order
-   In this example we have only one function

```
    //setUp
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

    // when data ==7
    // hiddenValue will become 7
    // on next iteration whatever data can be, but hiddenValue will be 7
    // since hiddenvalue is 7
    // test will fail
```
