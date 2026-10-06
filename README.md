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
5. **Proxy-Logs:** Für diese Anwendung keine Zugriffsprotokolle im Coolify-Proxy (Traefik/Caddy) aktivieren. Die Datenschutzerklärung sagt zu, dass keine Server-Protokolle geführt werden.

Keine Umgebungsvariablen nötig.

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
