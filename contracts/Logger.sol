// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// It's a way for designer to say that
// "any child of the abstract contract has to implement specified methods"

abstract contract Logger {

    uint public testNum;

    constructor() {
        testNum = 1000;
    }

    // virtual keyword indicates that function must be implented on the inheritors
    function emitLog() public virtual returns(bytes32);

    function test3() internal pure returns(uint) {
        return 100;
    }
}