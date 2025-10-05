// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {KipuBank} from "src/KipuBank.sol";

contract KipuBankTest is Test {
KipuBank bank;
address alice = address(0xA11CE);
address bob = address(0xB0B);

uint256 constant BANK_CAP = 5 ether;
uint256 constant WITHDRAW_CAP = 1 ether;

function setUp() public {
    bank = new KipuBank(BANK_CAP, WITHDRAW_CAP);
    vm.deal(alice, 10 ether);
    vm.deal(bob, 10 ether);
}

function testDepositIncreasesBalanceAndCounters() public {
    vm.prank(alice);
    bank.deposit{value: 0.7 ether}();
    assertEq(bank.balanceOf(alice), 0.7 ether);
    assertEq(bank.totalDeposited(), 0.7 ether);
    assertEq(bank.depositsCount(), 1);
}

function testWithdrawWithinCap() public {
    vm.startPrank(alice);
    bank.deposit{value: 2 ether}();
    bank.withdraw(1 ether);
    vm.stopPrank();

    assertEq(bank.balanceOf(alice), 1 ether);
    assertEq(bank.totalDeposited(), 1 ether);
    assertEq(bank.withdrawalsCount(), 1);
}

function testRevertWithdrawExceedsCap() public {
    vm.prank(alice);
    bank.deposit{value: 2 ether}();

    vm.expectRevert(abi.encodeWithSelector(
        KipuBank.ExceedsWithdrawCap.selector, 2 ether, WITHDRAW_CAP
    ));
    vm.prank(alice);
    bank.withdraw(2 ether);
}

function testRevertWithdrawInsufficientBalance() public {
    vm.expectRevert();
    vm.prank(alice);
    bank.withdraw(1);
}

function testRevertDepositExceedsBankCap() public {
    vm.prank(alice);
    bank.deposit{value: 5 ether - 0.1 ether}();

    vm.expectRevert();
    vm.prank(bob);
    bank.deposit{value: 0.2 ether}();
}

function testReceiveRevertsDirectETH() public {
    (bool ok, ) = address(bank).call{value: 1 wei}("");
    assertTrue(!ok);
} }