#!/usr/bin/env bash
# User tool — invocations signed by the investor / token holder.
# Run one explicit action at a time; configuration contains public data only.

set -euo pipefail
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/../demo.env" ]]; then
  source "$SCRIPT_DIR/../demo.env"
fi

NETWORK="${NETWORK:-testnet}"
USER_KEY="${USER_KEY:-bob}"
CONTRACT_ID="${CONTRACT_ID:-C...DEPLOYED_LAUNCHPAD_CONTRACT_ID...}"
RECIPIENT="${RECIPIENT:-G...RECIPIENT_PUBLIC_KEY...}"

invest() {
echo "=== invest ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$USER_KEY" \
  --network "$NETWORK" \
  -- \
  invest \
  --investor "$(stellar keys address "$USER_KEY")" \
  --payment_amount "$AMOUNT"
}

balance() {
echo "=== balance ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$USER_KEY" \
  --network "$NETWORK" \
  -- \
  balance \
  --id "$(stellar keys address "$USER_KEY")"
}

transfer() {
echo "=== transfer RWA tokens ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$USER_KEY" \
  --network "$NETWORK" \
  -- \
  transfer \
  --from "$(stellar keys address "$USER_KEY")" \
  --to "$RECIPIENT" \
  --amount 10
}

case "${1:-}" in
  invest|balance|transfer) ;;
  *) echo "Uso: bash scripts/user-tool.sh invest|balance|transfer" >&2; exit 1 ;;
esac
[[ "$NETWORK" == testnet ]] || { echo "Solo Testnet para esta actividad" >&2; exit 1; }
[[ "$CONTRACT_ID" =~ ^C[A-Z2-7]{55}$ ]] || { echo "Falta CONTRACT_ID válido" >&2; exit 1; }
case "$1" in
  invest)
    AMOUNT="${2:-}"
    [[ "$AMOUNT" =~ ^[1-9][0-9]*$ ]] || { echo "Uso: invest MONTO (entero positivo)" >&2; exit 1; }
    ;;
  transfer) [[ "$RECIPIENT" =~ ^G[A-Z2-7]{55}$ ]] || { echo "Falta RECIPIENT válido" >&2; exit 1; } ;;
esac
printf 'Red: %s\nContrato: %s\nAcción: %s\n' "$NETWORK" "$CONTRACT_ID" "$1"
"$1"
