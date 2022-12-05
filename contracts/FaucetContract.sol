// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Faucet {
    // this is a special function
    // it's called when you make a tx that doesn't specify
    //  function name to call

    // External function are part of the contract interface
    //  which means they can be called via contracts and other txs

    // external keyword means: can be called from the outside
    // payable keyword means: provide ether in the tx
    receive() external payable {}

    // If you try to use this command on the truffle console:
    // instance.addFunds({value: "2000000000000000000"})
    // if you didn't make the function payable, this will crash
    function addFunds() external payable {}
}

// Block info
// Nonce - a hash that when combined with the minHash proofs that
// the block has gone through proof of work(POW)
// 8 bytes => 64 bits