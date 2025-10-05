// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import {KipuBank} from "src/KipuBank.sol";

contract DeployKipuBank is Script {
function run() external {
uint256 pk = vm.envUint("PRIVATE_KEY");
uint256 bankCap = vm.envUint("BANK_CAP");
uint256 withdrawCap = vm.envUint("WITHDRAW_CAP");

    vm.startBroadcast(pk);
    KipuBank bank = new KipuBank(bankCap, withdrawCap);
    vm.stopBroadcast();

    console2.log("KipuBank:", address(bank));
    console2.log("bankCap:", bank.bankCap());
    console2.log("withdrawCap:", bank.withdrawCap());
} }