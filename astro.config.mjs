// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// Statische Seite ohne Server-Code. Jede Seite wird als /pfad/index.html erzeugt.
export default defineConfig({
  site: 'https://strategierat-karlsruhe.de',
  trailingSlash: 'always',
  build: { format: 'directory' },
  integrations: [sitemap()],
  // Keine Telemetrie, keine Drittanbieter: alles wird lokal gebaut und selbst ausgeliefert.
  devToolbar: { enabled: false },
});
