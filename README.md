# 🏦 KipuBank

**KipuBank** es un contrato inteligente desarrollado como entrega final del **Módulo 2** del curso de desarrollo Web3.  
Permite a los usuarios **depositar y retirar ETH** de una bóveda personal bajo límites definidos, aplicando buenas prácticas de seguridad, documentación y pruebas.

---

## 🚀 Descripción del proyecto

KipuBank actúa como una pequeña bóveda de depósitos en ETH.  
Cada usuario puede:
- **Depositar ETH** mientras el total global no supere el `bankCap`.
- **Retirar ETH** hasta un máximo por transacción (`withdrawCap`).
- Consultar su saldo con `balanceOf(address)`.

El contrato implementa:
- Patrones de seguridad **Checks-Effects-Interactions**.
- Protección contra reentradas (`ReentrancyGuard` de OpenZeppelin).
- **Errores personalizados** en lugar de strings.
- **Eventos** en cada depósito y retiro.
- **Funciones privadas, externas y view** según buenas prácticas.

---

## 🧱 Estructura del proyecto

kipu-bank/
│
├── src/
│ └── KipuBank.sol # Contrato principal
│
├── test/
│ └── KipuBank.t.sol # Tests con Foundry (forge-std)
│
├── script/
│ └── DeployKipuBank.s.sol # Script de despliegue
│
├── foundry.toml # Configuración del proyecto
├── remappings.txt # Mapeo de imports (generado)
└── README.md # Este archivo

yaml
Copiar código

---

## ⚙️ Variables principales del contrato

| Variable | Tipo | Descripción |
|-----------|------|-------------|
| `bankCap` | `uint256 immutable` | Límite global de depósitos |
| `withdrawCap` | `uint256 immutable` | Límite máximo por retiro |
| `totalDeposited` | `uint256` | Total actual depositado en el contrato |
| `balances` | `mapping(address => uint256)` | Balance individual de cada usuario |
| `depositsCount` / `withdrawalsCount` | `uint256` | Contadores de acciones |

---

## 🧠 Errores personalizados

| Error | Descripción |
|--------|--------------|
| `ZeroAmount()` | Monto igual a cero |
| `ExceedsWithdrawCap(requested, cap)` | Retiro mayor al límite |
| `InsufficientBalance(balance, requested)` | Saldo insuficiente |
| `BankCapExceeded(total, cap)` | Depósito supera el límite global |
| `UseDeposit()` | Se intentó enviar ETH directo |
| `NativeTransferFailed()` | Falla al enviar ETH |

---

## ⚖️ Seguridad implementada

- Uso de **ReentrancyGuard** (OZ) → evita ataques de reentrada.  
- Patrón **Checks–Effects–Interactions**.  
- Sin `tx.origin`, sin `delegatecall`, sin `selfdestruct`.  
- Validaciones explícitas y errores personalizados.  
- Eventos `Deposited` y `Withdrawn` para trazabilidad on-chain.  
- Variables `immutable` y `constant` para reducir gas y riesgos.

---

## 🧪 Pruebas automatizadas

Los tests cubren:
- Depósitos y retiros válidos.  
- Reversiones por saldo insuficiente, monto cero o límites superados.  
- Rechazo de envío directo de ETH.

🧑‍💻 Autor

Nombre: Leandro G
Curso:— Módulo 2
Fecha de entrega: 5 de octubre de 2025

🪙 Licencia

ETHKIPU © 2025 — Proyecto académico sin fines comerciales.