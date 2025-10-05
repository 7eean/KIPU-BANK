// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**

@title 

@notice Bóveda de ETH 

@dev 
*/
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract KipuBank is ReentrancyGuard {
// ===== Errors =====
error ZeroAmount();
error ExceedsWithdrawCap(uint256 requested, uint256 cap);
error InsufficientBalance(uint256 balance, uint256 requested);
error BankCapExceeded(uint256 attemptedTotal, uint256 cap);
error UseDeposit();
error NativeTransferFailed();
// ===== Events =====
event Deposited(address indexed user, uint256 amount, uint256 newBalance);
event Withdrawn(address indexed user, uint256 amount, uint256 newBalance);

// ===== State =====
uint256 public immutable bankCap;
uint256 public immutable withdrawCap;
uint256 public totalDeposited;
uint256 public depositsCount;
uint256 public withdrawalsCount;
mapping(address => uint256) private _balances;

// ===== Constructor =====
constructor(uint256 _bankCap, uint256 _withdrawCap) {
    if (_bankCap == 0 || _withdrawCap == 0) revert ZeroAmount();
    bankCap = _bankCap;
    withdrawCap = _withdrawCap;
}

// ===== Modifier =====
modifier withinBankCap(uint256 amount) {
    uint256 newTotal = totalDeposited + amount;
    if (newTotal > bankCap) revert BankCapExceeded(newTotal, bankCap);
    _;
}

// ===== External =====
function deposit() external payable withinBankCap(msg.value) {
    if (msg.value == 0) revert ZeroAmount();
    _balances[msg.sender] += msg.value;
    totalDeposited += msg.value;
    _afterDeposit();
    emit Deposited(msg.sender, msg.value, _balances[msg.sender]);
}

function withdraw(uint256 amount) external nonReentrant {
    if (amount == 0) revert ZeroAmount();
    if (amount > withdrawCap) revert ExceedsWithdrawCap(amount, withdrawCap);

    uint256 bal = _balances[msg.sender];
    if (bal < amount) revert InsufficientBalance(bal, amount);

    _balances[msg.sender] = bal - amount;
    totalDeposited -= amount;
    unchecked { withdrawalsCount += 1; }

    (bool ok, ) = msg.sender.call{value: amount}("");
    if (!ok) revert NativeTransferFailed();

    emit Withdrawn(msg.sender, amount, _balances[msg.sender]);
}

function balanceOf(address user) external view returns (uint256) {
    return _balances[user];
}

// ===== Private =====
function _afterDeposit() private {
    unchecked { depositsCount += 1; }
}

// ===== Fallbacks =====
receive() external payable { revert UseDeposit(); }
fallback() external payable { if (msg.value > 0) revert UseDeposit(); }
 }