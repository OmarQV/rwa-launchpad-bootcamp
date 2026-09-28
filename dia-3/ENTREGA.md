# Actividad 4 — OmarQV

## Entregables

- Repositorio: https://github.com/OmarQV/rwa-launchpad-bootcamp
- Red: **Testnet**.
- Contract ID: `CC55XTSV75WWZPB7GBWLAEGWANAVX4Z2RVHOZ3UNSIJ7QRUX3L66EZZD`.
- [Inversión exitosa de 500 en Stellar Expert](https://stellar.expert/explorer/testnet/tx/0b32567b5757da874056bcfa3ea782681e25ae93ceceff8c0d62ede1389ad7e3).
- [Salidas reales para las capturas](evidencias/README.md).

## Resultado verificado

Se inicializó el contrato con precio 100 y se agregó el inversionista a la whitelist usando `admin-tool.sh`. Después se utilizó `user-tool.sh` para el flujo:

| Operación | Resultado |
|---|---|
| Balance inicial | 0 RWA |
| Invertir 100 | Rechazo en simulación: `Error(Contract, #7)` = `AmountTooLow` |
| Invertir 500 | Transacción confirmada; 5 RWA emitidos |
| Balance final | 5 RWA |

El rechazo ocurrió en simulación y no tiene hash de transacción en la red. La inversión exitosa tiene hash `0b32567b5757da874056bcfa3ea782681e25ae93ceceff8c0d62ede1389ad7e3`.

## Token de pago utilizado

Ante la falta de un token proporcionado por el docente, Omar autorizó usar **XLM nativo de Testnet mediante Stellar Asset Contract**:

`CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC`.

Se mantienen los enteros del ejercicio: 500 unidades mínimas de XLM (stroops) equivalen a 0.00005 XLM, no a 500 XLM. El precio es 100 unidades mínimas por RWA. Las comisiones se cobran aparte. Esta elección se documenta expresamente porque el README base esperaba un token del docente.

Inversionista: `GAZ43MLZDV42LFHI5YTTD7ZT3OGCJHHY37DVMUJ6I5WYHNR7AKD742O5`.

## Código y validación

`check_variation_gate` rechaza montos positivos menores a 500 con `AmountTooLow = 7`. Cero y negativos conservan `InvalidAmount`. El test nuevo comprueba el rechazo de 100 sin cambios de saldos y la aceptación de 500. **4 pruebas aprobadas, 0 fallidas**; formato Rust y sintaxis Bash verificados.

```bash
cargo fmt --check
cargo test --locked
stellar contract build --locked
```

WASM desplegado: `target/wasm32v1-none/release/rwa_launchpad_dia_3.wasm`.
SHA-256: `bd1c7091516ae3cfc3bd297e5d78c3d1d64cbf4dde76e2094af4c2f3922e54a9`.

Los scripts cargan `demo.env` con configuración pública y ejecutan una acción por llamada. Las identidades privadas permanecen fuera del repositorio. El endurecimiento de permisos administrativos del contrato base no forma parte de este cambio.

## Capturas sin repetir inversiones

Desde `dia-3`, mostrar los registros reales guardados y tomar las capturas de pantalla:

```bash
cat evidencias/05_inversion_100_rechazada.txt
```

```bash
cat evidencias/06_inversion_500_exitosa.txt
cat evidencias/07_balance_final.txt
```

Estos archivos son registros de las ejecuciones realizadas, no nuevas operaciones. **No volver a invertir 500 para una captura**, porque añadiría otros 5 RWA. Las imágenes de pantalla serán tomadas por Omar; los registros de texto ya están publicados.
