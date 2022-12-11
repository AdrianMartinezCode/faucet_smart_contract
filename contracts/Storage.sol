// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Storage {

    mapping(uint => uint) public aa; // slot 0
    mapping(address => uint) public bb; // slot 1

    // keccak256(key . slot)

    uint[] public cc; // slot 2

    uint8 public a = 7; // 1 byte
    uint16 public b = 10; // 2 bytes
    address public c = 0x580B64Fe88ec9f90E570E5030B50c9311139D58a; // 20 bytes
    bool d = true; // 1 byte
    uint64 public e = 15; // 8 bytes
    // 32 bytes, all values will be stored in slot 3
    //  On the storage, if you check the memory, these values are distributed as:
    //    e  d                    c                       b   a
    // '0x0f 01 580b64fe88ec9f90e570e5030b50c9311139d58a 000a 07'


    uint256 public f = 200; // 32 bytes
    // slot 4
    // '0xc8'

    uint8 public g = 40; // 1 byte
    // slot 5
    // '0x28'

    uint256 public h = 789; // 32 bytes
    // slot 6
    // '0x0315'

    /*
    The total virtual memory size are 2^256 - 1

    The memory are splited by chunks of 32 bytes.

     32 bytes
    [[    ],[    ],[    ], ... ]
        0      1      2    ...

    */

    // Called on the deploying of the contract
    constructor() {
        cc.push(1);
        cc.push(10);
        cc.push(100);
        aa[2] = 4;
        aa[3] = 10;
        bb[0x580B64Fe88ec9f90E570E5030B50c9311139D58a] = 100;
    }
}


// First param: smart contract address
// web3.eth.getStorageAt("0xf444e7D7661Ae9eDc392b13390BCFD1F94fF5a9e", 0);

/*
We want to access to the value of aa[2], first of all, calculate the exact address of aa[2]
0x0000000000000000000000000000000000000000000000000000000000000002 
Join the two slots addresses:
0x00000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000 <-- slot 0
Go to keccak256:
and make the hash function of:
00000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000
it will result in:
abbb5caa7dda850e60932de0934eb1f9d0f59695050f761dc64e443e5030a569

and, go to the truffle console and put the result as the second argument:
web3.eth.getStorageAt("0xf444e7D7661Ae9eDc392b13390BCFD1F94fF5a9e", "0xabbb5caa7dda850e60932de0934eb1f9d0f59695050f761dc64e443e5030a569");
and you will receive:
0x04 , the value of aa[2]



We can do the same to get the value of bb[0x580B64Fe88ec9f90E570E5030B50c9311139D58a]:
0x000000000000000000000000580B64Fe88ec9f90E570E5030B50c9311139D58a0000000000000000000000000000000000000000000000000000000000000001 <-- slot 1
the second 64 bytes are the reference to the slot.
keccak result:
450f091aa4bbe3c22c29df49021c571c2ef7db38f0bc429c1f56e8b02a3029f7
web3.eth.getStorageAt("0xf444e7D7661Ae9eDc392b13390BCFD1F94fF5a9e", "0x450f091aa4bbe3c22c29df49021c571c2ef7db38f0bc429c1f56e8b02a3029f7");
and you will receive:
0x64 , the value of bb[0x580B64Fe88ec9f90E570E5030B50c9311139D58a]


To check specific value from the cc array:
keccak256(slot) + index of the item
keccak256(0000000000000000000000000000000000000000000000000000000000000002) + 1
0x405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace + 1
29102676481673041902632991033461445430619272659676223336789171408008386403022 + 1 // we have transformed from hex to dec
29102676481673041902632991033461445430619272659676223336789171408008386403023
0x405787FA12A823E0F2B7631CC41B3BA8828B3321CA811111FA75CD3AA3BB5ACF // turn again into hex (you can skip this transformation making the addition operation directly above the hex base number)

Now, we have to go to the truffle console and put the next two arguments, 
the first the hash of the smart contract and the second the hash + position
web3.eth.getStorageAt("0xc139C9eCe60b1d83082E152BBD53B43AFB09dc5B", "0x405787FA12A823E0F2B7631CC41B3BA8828B3321CA811111FA75CD3AA3BB5ACF")



*/