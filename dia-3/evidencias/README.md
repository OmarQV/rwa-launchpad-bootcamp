# Evidencia real de Testnet

Los archivos `.txt` son las salidas originales capturadas al ejecutar los scripts. No son capturas de pantalla; sirven para mostrar el registro real en la terminal y tomar las imágenes solicitadas.

- [Inicialización](01_initialize.txt)
- [Whitelist](02_whitelist.txt)
- [Balance inicial: 0](03_balance_inicial.txt)
- [Inversión 100 rechazada: AmountTooLow, código 7](05_inversion_100_rechazada.txt)
- [Inversión 500 confirmada](06_inversion_500_exitosa.txt)
- [Balance final: 5 RWA](07_balance_final.txt)

## Tomar las dos capturas

Desde `dia-3`, ejecutar por separado y capturar con la herramienta de recortes de Windows:

```bash
cat evidencias/05_inversion_100_rechazada.txt
```

Guardar como `05_inversion_100_rechazada.png`.

```bash
cat evidencias/06_inversion_500_exitosa.txt
cat evidencias/07_balance_final.txt
```

Guardar como `06_inversion_500_exitosa.png`; si no cabe el balance, usar una tercera imagen. Abrir también el enlace de la inversión en Stellar Expert desde ENTREGA.md si se desea capturar la confirmación en el explorador.

No repetir la inversión exitosa. Las imágenes quedan pendientes de ser tomadas por Omar.
