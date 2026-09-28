# Actividad 4 — OmarQV

Repositorio: https://github.com/OmarQV/rwa-launchpad-bootcamp

Red: **Testnet**

Contract ID del launchpad:

```text
CC55XTSV75WWZPB7GBWLAEGWANAVX4Z2RVHOZ3UNSIJ7QRUX3L66EZZD
```

[Transacción de despliegue](https://stellar.expert/explorer/testnet/tx/c0d2d7dabc0303a7bc3a177a20b2efbb34c16c4519bc5fe85eebfc903d75ac6f). Este enlace documenta el despliegue; no sustituye la inversión exitosa exigida.

## Cambio y pruebas

`check_variation_gate` rechaza montos positivos menores a 500 con `AmountTooLow = 7`. Cero y negativos mantienen `InvalidAmount`. La firma pública de `invest` se conserva.

El test `test_minimum_investment_100_fails_500_succeeds` comprueba que 100 devuelve el error correcto sin cambiar saldos y que 500 entrega 5 RWA con precio 100. **4 pruebas aprobadas, 0 fallidas**. Formato y sintaxis Bash verificados.

```bash
cargo fmt --check
cargo test --locked
stellar contract build --locked
```

WASM desplegado: `target/wasm32v1-none/release/rwa_launchpad_dia_3.wasm`.
SHA-256: `bd1c7091516ae3cfc3bd297e5d78c3d1d64cbf4dde76e2094af4c2f3922e54a9`.

## Estado de la demostración

**Pendiente:** token de pago del docente, inicialización, whitelist e inversiones en Testnet. Las pruebas locales no sustituyen la demostración en red.

- Token de pago: PENDIENTE.
- Inversionista: `GAZ43MLZDV42LFHI5YTTD7ZT3OGCJHHY37DVMUJ6I5WYHNR7AKD742O5`.
- Hash de inversión exitosa: PENDIENTE.
- Enlace Stellar Expert de inversión exitosa: PENDIENTE.
- Capturas reales: PENDIENTES, carpeta [evidencias](evidencias/).

## Operación

Los scripts cargan automáticamente `demo.env`, que solo contiene configuración pública. Las identidades privadas permanecen en la configuración local de Stellar, fuera del repositorio. Para reproducir en otro equipo se necesitan identidades propias y un despliegue propio.

Desde `dia-3`, después de configurar `PAYMENT_TOKEN` con el ID del docente y fondear al inversionista con ese token:

```bash
bash scripts/admin-tool.sh initialize
bash scripts/admin-tool.sh whitelist
bash scripts/user-tool.sh balance
```

El balance inicial debe ser 0. Ejecutar por separado y tomar las capturas:

```bash
bash scripts/user-tool.sh invest 100
```

Debe fallar con el error de contrato 7. Después:

```bash
bash scripts/user-tool.sh invest 500
bash scripts/user-tool.sh balance
```

La inversión debe confirmarse y el balance debe ser 5. No repetir una inversión ya confirmada para obtener otra captura. Guardar el enlace de la transacción de inversión que imprime la CLI.

Los scripts conservan las acciones opcionales del original, pero ejecutan solo la acción solicitada. No se requiere mint, withdraw ni transfer para esta demostración. El endurecimiento de permisos administrativos del contrato base queda fuera de este cambio.
