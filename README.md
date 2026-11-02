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

```text
KIPU-BANK/
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
```

---

## ⚙️ Variables principales del contrato

| Variable | Tipo | Descripción |
|-----------|------|-------------|
| `bankCap` | `uint256 immutable` | Límite global de depósitos |
| `withdrawCap` | `uint256 immutable` | Límite máximo por retiro |
| `totalDeposited` | `uint256` | Total actual depositado en el contrato |
| `_balances` | `mapping(address => uint256) private` | Balance individual; se consulta con `balanceOf(address)` |
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

## 🛠️ Desarrollo local con Foundry

Se necesitan Git y [Foundry](https://getfoundry.sh/introduction/installation/).
En Windows, el instalador `foundryup` se ejecuta desde Git Bash o WSL; también
se pueden usar los binarios oficiales de Foundry para Windows.

```sh
git clone https://github.com/7eean/KIPU-BANK.git
cd KIPU-BANK
forge --version
forge install --no-git foundry-rs/forge-std@v1.10.0 OpenZeppelin/openzeppelin-contracts@v5.0.2
forge build --sizes
forge test -vvv
forge fmt --check
```

Las versiones coinciden con `foundry.lock`: forge-std `v1.10.0` y OpenZeppelin
Contracts `v5.0.2`. La carpeta `lib/` está ignorada y el repositorio no registra
submódulos en `.gitmodules`, por lo que una clonación recursiva o `forge install`
sin argumentos no recupera estas dependencias. El comando explícito anterior
las instala localmente sin agregar submódulos. La primera compilación descarga
Solc `0.8.24`, la versión fijada en `foundry.toml`.

Estos comandos compilan y prueban en la EVM local de Foundry; no requieren
clave privada, RPC ni desplegar el contrato en una red.

### Estado de las verificaciones

Sobre el commit `44008fd`, con Forge `1.8.7`, Solc `0.8.24` y las dependencias
anteriores, `forge build --sizes` compila y los 6 tests existentes pasan.
Hay problemas preexistentes que deben tenerse en cuenta:

- `forge fmt --check` falla por formato en los archivos Solidity; el workflow
  de CI se detiene en ese paso antes de compilar o ejecutar los tests.
- El workflow selecciona el perfil `ci`, que no está definido en `foundry.toml`,
  y no instala las dependencias faltantes.
- `forge build --sizes` emite las advertencias de lint `reentrancy-eth` y
  `reentrancy-events` en `withdraw`.

## 🧪 Pruebas automatizadas

Los tests cubren:
- Depósitos y retiros válidos.  
- Reversiones por saldo insuficiente, monto cero o límites superados.  
- Rechazo de envío directo de ETH.

## 📬 Dirección desplegada

**Red:** Sepolia Testnet  
**Contrato:** [`0x30835A2CD4adEC7D9398213e01b6e4DC00664e7C`](https://sepolia.etherscan.io/address/0x30835A2CD4adEC7D9398213e01b6e4DC00664e7C)  
**Verificado:** ✅ (código publicado en Etherscan)


🧑‍💻 Autor

Nombre: Leandro G
Curso:— Módulo 2
Fecha de entrega: 5 de octubre de 2025

🪙 Licencia

ETHKIPU - MIT © 2025 — Proyecto académico sin fines comerciales.
