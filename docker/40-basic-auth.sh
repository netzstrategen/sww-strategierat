#!/bin/sh
# Zugangsschutz (HTTP Basic Auth), solange die Seite noch nicht öffentlich ist.
# Aktiv, wenn BASIC_AUTH_USER und BASIC_AUTH_PASSWORD gesetzt sind (in Coolify als Umgebungsvariablen).
# Zum Livegang beide Variablen in Coolify löschen und neu deployen. Zugangsdaten stehen nie im Repository.
set -eu

AUTH_CONF=/etc/nginx/auth.conf

if [ -n "${BASIC_AUTH_USER:-}" ] && [ -n "${BASIC_AUTH_PASSWORD:-}" ]; then
  # -m (APR1): von nginx selbst geprüft, unabhängig von der crypt()-Unterstützung der libc
  htpasswd -bcm /etc/nginx/.htpasswd "$BASIC_AUTH_USER" "$BASIC_AUTH_PASSWORD" >/dev/null 2>&1
  chmod 640 /etc/nginx/.htpasswd
  chown root:nginx /etc/nginx/.htpasswd
  cat > "$AUTH_CONF" <<'CONF'
auth_basic "Strategierat Karlsruhe";
auth_basic_user_file /etc/nginx/.htpasswd;
add_header X-Robots-Tag "noindex, nofollow" always;
CONF
  echo "basic-auth: Zugangsschutz aktiv" >&2
else
  : > "$AUTH_CONF"
  echo "basic-auth: kein Zugangsschutz (Seite öffentlich)" >&2
fi
