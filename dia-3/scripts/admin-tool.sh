#!/usr/bin/env bash
# Admin tool — invocations that require the issuer/admin key to sign.
# Run one explicit action at a time; configuration contains public data only.

set -euo pipefail
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/../demo.env" ]]; then
  source "$SCRIPT_DIR/../demo.env"
fi

NETWORK="${NETWORK:-testnet}"
ADMIN_KEY="${ADMIN_KEY:-alice}"
CONTRACT_ID="${CONTRACT_ID:-C...DEPLOYED_LAUNCHPAD_CONTRACT_ID...}"
PAYMENT_TOKEN="${PAYMENT_TOKEN:-C...INSTRUCTOR_PAYMENT_TOKEN_ID...}"
INVESTOR="${INVESTOR:-G...INVESTOR_PUBLIC_KEY...}"
TREASURY="${TREASURY:-G...TREASURY_PUBLIC_KEY...}"

initialize() {
echo "=== initialize (run once after deploy) ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  initialize \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --asset '{"name":"RWAToken","total_supply":1000000,"price_per_unit":100,"payment_token":"'"$PAYMENT_TOKEN"'","paused":false}'
}

whitelist() {
echo "=== set_whitelist ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  set_whitelist \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --investor "$INVESTOR" \
  --approved true
}

mint() {
echo "=== mint (admin-only; optional if using invest) ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  mint \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --to "$INVESTOR" \
  --amount 100
}

withdraw() {
echo "=== withdraw collected payment tokens ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  withdraw \
  --admin "$(stellar keys address "$ADMIN_KEY")" \
  --to "$TREASURY" \
  --amount 500
}

pause() {
echo "=== pause ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  pause \
  --admin "$(stellar keys address "$ADMIN_KEY")"
}

unpause() {
echo "=== unpause ==="
stellar contract invoke \
  --id "$CONTRACT_ID" \
  --source "$ADMIN_KEY" \
  --network "$NETWORK" \
  -- \
  unpause \
  --admin "$(stellar keys address "$ADMIN_KEY")"
}

case "${1:-}" in
  initialize|whitelist|mint|withdraw|pause|unpause) ;;
  *) echo "Uso: bash scripts/admin-tool.sh initialize|whitelist|mint|withdraw|pause|unpause" >&2; exit 1 ;;
esac
[[ "$NETWORK" == testnet ]] || { echo "Solo Testnet para esta actividad" >&2; exit 1; }
[[ "$CONTRACT_ID" =~ ^C[A-Z2-7]{55}$ ]] || { echo "Falta CONTRACT_ID válido" >&2; exit 1; }
case "$1" in
  initialize) [[ "$PAYMENT_TOKEN" =~ ^C[A-Z2-7]{55}$ ]] || { echo "Falta PAYMENT_TOKEN válido" >&2; exit 1; } ;;
  whitelist|mint) [[ "$INVESTOR" =~ ^G[A-Z2-7]{55}$ ]] || { echo "Falta INVESTOR válido" >&2; exit 1; } ;;
  withdraw) [[ "$TREASURY" =~ ^G[A-Z2-7]{55}$ ]] || { echo "Falta TREASURY válido" >&2; exit 1; } ;;
esac
printf 'Red: %s\nContrato: %s\nAcción: %s\n' "$NETWORK" "$CONTRACT_ID" "$1"
"$1"
