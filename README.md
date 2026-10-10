# strategierat-karlsruhe.de

Website des **Strategierats Wirtschaft & Wissenschaft Karlsruhe**. Die Seite stellt den Rat vor und veröffentlicht Leitbild, Satzung und die Zusammensetzung des Gremiums.

- **Produktion:** https://strategierat-karlsruhe.de
- **Verantwortlich (Inhalt und Impressum):** André Hellmann, stellvertretender Vorsitzender des Präsidiums
- **Hosting:** Coolify auf dem netzstrategen-Server (Deutschland)
- **Tier:** Production

## Stack

| Teil | Wahl | Warum |
| --- | --- | --- |
| Framework | Astro 7, rein statisch (`output: static`) | Keine Server-Logik, keine Datenbank, schnell und sicher |
| Auslieferung | nginx im Docker-Container (`Dockerfile`, `docker/nginx.conf`) | Läuft unverändert in Coolify |
| Schriften | Caladea und Carlito als `woff2` in `public/fonts/` | Selbst gehostet, kein Google-Fonts-Abruf |
| Sitemap | `@astrojs/sitemap` | `sitemap-index.xml` für Suchmaschinen |

Es gibt **kein Tracking, keine Cookies, keine Inhalte von Drittanbietern und keine Zugriffsprotokolle**. Die Datenschutzerklärung (`src/pages/datenschutz.astro`) sagt das ausdrücklich zu. Wer daran etwas ändert, muss die Datenschutzerklärung im selben PR anpassen.

## Voraussetzungen

- Node.js 22 (siehe `.nvmrc`)
- npm

## Lokal starten

```bash
npm ci
npm run dev       # http://localhost:4321
```

## Befehle

| Zweck | Befehl |
| --- | --- |
| Installieren | `npm ci` |
| Entwickeln | `npm run dev` |
| Prüfen (Typen, Astro) | `npm run check` |
| Bauen | `npm run build` (Ergebnis in `dist/`) |
| Build ansehen | `npm run preview` |

## Aufbau

```
src/
  layouts/Base.astro          Kopf, Navigation, Fußzeile, Meta-Tags
  pages/                      eine Datei je Seite: index, leitbild, satzung, gremium, impressum, datenschutz, 404
  components/                 PersonCard (Präsidium, Stadtspitze), Zusammensetzung (Quote-Balken)
  data/gremium.json           Mitglieder, Gäste, Präsidium, Stadtspitze, Stand
  styles/global.css           Design-Tokens (hell und dunkel) und alle Bausteine
public/
  fonts/  logo-*.svg  favicon.svg  downloads/  js/copy-mail.js  robots.txt
docker/nginx.conf             Auslieferung, Sicherheits-Header, keine Access-Logs
```

## Gestaltung

Farben, Schriften und Logo folgen dem Styleguide v1.0 des Rats (10.10.2026) nach dem Design-Review vom 09.10.2026. Die Regeln für Code stehen in `AGENTS.md` unter „Design“, die Werte als Tokens oben in `src/styles/global.css`.

- **Grün `#128275` und Fließtext in Tinte `#1C2B33`:** Grün muss auf Weiß 4,5 : 1 erreichen und sich zugleich mit 3 : 1 vom Fließtext abheben. Mit dem früheren Fließtext `#33424A` war das mit keinem Grün möglich, mit Tinte gibt es ein schmales Fenster.
- **Grün tief `#11796D`** für grüne Schrift auf den hellen Flächen (Karten, Vision, Kontakt), dort hält es 4,5 : 1.
- **Links im Fließtext sind immer unterstrichen**, damit sie nicht nur an der Farbe erkennbar sind.
- **Logo:** Dateien unverändert aus dem Logo-Paket vom 09.10.2026 (`public/logo-hell.svg`, `public/logo-dunkel.svg`, `public/logo-kompakt-*.svg`, `public/favicon.svg`). Im Kopf 56 px hoch; mobil und in der Fußzeile die Kompaktversion, 40 px hoch, weil die Vollversion dort unter ihre Mindestbreite von 200 px fiele.

## Inhalte ändern

- **Mitglieder, Gäste, Präsidium:** nur `src/data/gremium.json` bearbeiten. Zahlen und Quote auf der Startseite rechnen sich daraus selbst. Feld `stand` mitpflegen.
- **Leitbild und Satzung:** stehen als beschlossener Wortlaut in `src/pages/leitbild.astro` und `src/pages/satzung.astro`. Änderungen nur nach Beschluss des Rats (§ 10 Abs. 4 der Satzung). Das PDF in `public/downloads/` gleichzeitig austauschen.
- **Texte der Startseite:** `src/pages/index.astro`. Sprachregelung in `AGENTS.md` beachten.

## Deployment (Coolify)

Einmalige Einrichtung durch die Entwicklung:

1. **Neue Ressource** in Coolify: *Application → Public/Private Repository*, dieses Repository, Branch `main`.
2. **Build Pack:** `Dockerfile` (liegt im Repo-Root). Port `80`.
3. **Domain:** `https://strategierat-karlsruhe.de` und `https://www.strategierat-karlsruhe.de`; www per Redirect auf die Hauptdomain. Let's-Encrypt-Zertifikat über Coolify.
4. **Auto-Deploy** bei Push auf `main` aktivieren. Optional Staging aus `development`.
   Das Repository muss in der GitHub App `netzstrategen-github` freigegeben sein (Organisation → Settings → GitHub Apps → Repository access). Weil es öffentlich ist, baut Coolify es auch ohne diese Freigabe, bekommt dann aber keine Push-Events, und Auto-Deploy greift nie.
5. **Proxy-Logs:** Für diese Anwendung keine Zugriffsprotokolle im Coolify-Proxy (Traefik/Caddy) aktivieren. Die Datenschutzerklärung sagt zu, dass keine Server-Protokolle geführt werden.

### Zugangsschutz bis zum Livegang

Solange die Seite nicht öffentlich sein soll, schützt nginx sie mit HTTP Basic Auth (wie die netzstrategen-Staging-Seiten). Gesteuert wird das ausschließlich über zwei Umgebungsvariablen in Coolify:

| Variable | Wert |
| --- | --- |
| `BASIC_AUTH_USER` | Benutzername |
| `BASIC_AUTH_PASSWORD` | Passwort (in Coolify als *secret* markieren) |

- Sind beide gesetzt, verlangt die Seite beim Aufruf Zugangsdaten und sendet `X-Robots-Tag: noindex, nofollow`.
- Fehlt eine der beiden, ist die Seite öffentlich.
- **Zum Livegang:** beide Variablen in Coolify löschen und neu deployen. Kein Code-Change nötig.
- Zugangsdaten stehen nie im Repository. Erzeugt wird die Passwortdatei beim Containerstart von `docker/40-basic-auth.sh`.

### DNS bei Host Europe

Im KIS von Host Europe für `strategierat-karlsruhe.de`:

| Typ | Name | Wert |
| --- | --- | --- |
| A | `@` | IPv4 des netzstrategen-Coolify-Servers |
| A | `www` | IPv4 des netzstrategen-Coolify-Servers |
| AAAA | `@`, `www` | IPv6 des Servers, falls vorhanden |

**MX-, SPF- und DKIM-Einträge nicht ändern.** Die Adresse `kontakt@strategierat-karlsruhe.de` läuft bereits darüber.

### Abnahme nach dem ersten Deployment

- Alle Seiten laden über HTTPS, `http://` und `www` leiten auf `https://strategierat-karlsruhe.de/` um.
- In den Entwicklertools (Netzwerk) gibt es nur Anfragen an `strategierat-karlsruhe.de`.
- Antwort-Header enthalten `Content-Security-Policy` und `X-Content-Type-Options`.
- `/gibts-nicht/` zeigt die eigene 404-Seite.
- Satzung als PDF lädt unter `/downloads/2026-09-28_SWW-Satzung.pdf`.

## Sensitive features

Keine. Die Seite hat keine Formulare, keine Anmeldung, keine Datenbank und keinen Mailversand. Personenbezogen sind nur die veröffentlichten Namen, Organisationen und Funktionen der Mitglieder und Gäste; sie werden mit deren Einverständnis gezeigt.
