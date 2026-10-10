# AGENTS.md

Project-level agent instructions for this repo. Every coding-agent session
should read this first.

## What this project is

The public website of the **Strategierat Wirtschaft & Wissenschaft Karlsruhe** (strategierat-karlsruhe.de), an independent advisory council of 27 decision-makers from business, science and civic institutions that advises with the city leadership of Karlsruhe. The site presents the council, its Leitbild, its Satzung and its members and guests. Production tier. Content is German only. The responsible person for content is André Hellmann (stellvertretender Vorsitzender des Präsidiums).

Readers include the city administration, much of it lawyers. Every word and number is read closely. Nothing on the site may be estimated, invented or unsourced.

## Stack

- Astro 7, static output only (`output: static`, `build.format: directory`, trailing slashes)
- `@astrojs/sitemap`
- Self-hosted fonts (Caladea for statements, Carlito for working text) in `public/fonts/`
- Delivered by nginx in Docker (`Dockerfile`, `docker/nginx.conf`), deployed with Coolify on the netzstrategen server in Germany
- No framework UI library, no client-side JS except `public/js/copy-mail.js`

## Hard rules for this site

These come from the published privacy policy and the council's language rules. Breaking them makes the site say something untrue.

1. **No tracking, no cookies, no third-party requests.** No GTM, GA4, LinkedIn Insight, Matomo, embeds, CDN fonts, CDN scripts or external images. Everything is served from this repo. If a change needs any of this, stop and ask; the privacy policy in `src/pages/datenschutz.astro` must change in the same PR.
2. **No access logs.** `access_log off` in `docker/nginx.conf` stays off.
3. **Keep the CSP strict.** `script-src 'self'`. Put scripts in `public/js/` and load them with `<script is:inline src>`; never inline JavaScript.
4. **Beschlossene Texte are fixed.** The Leitbild (`src/pages/leitbild.astro`) and the Satzung (`src/pages/satzung.astro`) reproduce the wording adopted on 28 September 2026. Change them only when the council has adopted a new version (§ 10 Abs. 4 Satzung), and swap the PDF in `public/downloads/` in the same PR.
5. **Members data lives in `src/data/gremium.json` only.** Counts and the quota bar on the start page are computed from it. Update `stand` when the list changes.
6. **Pre-launch password gate only via env vars.** `BASIC_AUTH_USER` and `BASIC_AUTH_PASSWORD` in Coolify switch HTTP basic auth on (`docker/40-basic-auth.sh`). Never commit credentials or an `.htpasswd`.

## Language rules (German copy)

- Responsibility of the council is **„die Stadt“**, never „die Region“ or „TechnologieRegion“ (exception: where members come from, and the TechnologieRegion Karlsruhe e. V. in the Leitbild).
- Advice is always **mutual**: „Rat und Stadt beraten sich gegenseitig“, „gegenseitige Beratung“. Never one-sided „der Rat berät die Stadt“ in new text.
- The group is always „27 Entscheidungsträgerinnen und Entscheidungsträger aus Wirtschaft, Wissenschaft und gesellschaftlichen Institutionen“.
- The vision is quoted verbatim: „Karlsruhe gehört 2035 zu den führenden Wirtschafts- und Wissenschaftsstandorten Deutschlands und zeigt, wie Wirtschaft, Wissenschaft, Gesellschaft und Stadt gemeinsam Transformation gestalten.“
- Role of the city leadership as guests: „Sie bringen Themen der Stadt ein und beraten in den Sitzungen mit.“
- Third member group is „Kammern, Verbände, Zivilgesellschaften“. Never write „Sonstige …“.
- Guest lists start with Oberbürgermeister and Wirtschaftsbürgermeisterin, then alphabetical.
- Do not state who is *not* allowed to do something (e.g. who does not chair). Refer to the Satzung instead.
- No em dashes (—). Use colon, comma, full stop or a new sentence. Sparse spaced en dashes „–“ are fine.
- Never use „Hebel“. „nicht X, sondern Y“ only when Y is concrete.
- Typography: „…“ quotes, non-breaking space in „§ 7“, „55 %“, „Abs. 2“.

## Working in this repo

### Commands

| Purpose | Command |
| ------- | ------- |
| Install | `npm ci` |
| Develop | `npm run dev` |
| Check   | `npm run check` |
| Build   | `npm run build` |
| Preview | `npm run preview` |

### Git workflow

Gitflow. `main` is production; `development` is the integration branch and what staging deploys from.

- **Branch off `development`, PR back into `development`.** Squash-merge those.
- Branch naming: `<type>/<short-desc>-<asana-task-id>-<initials>`, e.g. `feat/update-gremium-1234567890123-ah`. Without an Asana task: `<type>/<short-desc>`.
  Allowed types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `style`, `ci`.
- **`main` takes only two things:** a release PR from `development`, or a `hotfix/`. Tag `main` after a release merges (`v1.0.0`, semantic versioning, annotated tags).
- **After a hotfix lands on `main`, merge `main` back into `development` immediately.** Skip this and the next release silently reverts the hotfix.
- **Do not squash the release PR.** It makes `main` and `development` diverge permanently.
- Conventional Commits: `<type>(<scope>): <imperative summary>`, lowercase, no period.
- Delete branches after merging. Never force-push to `main` or `development`.

### Pull requests

- Open as draft for feedback; mark ready when complete.
- PR title follows Conventional Commits.
- PR description: what changed, why, and a test plan. For copy changes, quote old and new wording.
- Production tier: approval from `@netzstrategen/owners`. Copy changes additionally need André Hellmann's OK.

## Naming conventions

- Files and directories: `kebab-case` (Astro pages map to URLs, so page names are the German slugs).
- Constants: `SCREAMING_SNAKE_CASE`. No type suffixes on identifiers.

## Security

- No secrets in code or history. This site needs no environment variables.
- Keep dependencies up to date; run `npm audit` before each release.
- Keep the security headers in `docker/nginx.conf`. Do not add `add_header` inside a `location` block: nginx then drops the server-level headers for that location.

## Documentation

- Update `README.md` in the same PR as the change. Document the *why*, not the *what*.

## Code review

- Author: one change per PR.
- Reviewer: mark blocking issues `MUST`, suggestions `NIT` or `CONSIDER`. Approve only when all `MUST` items are resolved.

## Tooling

- `.editorconfig` enforces indentation and line endings.
- `npm run check` and `npm run build` must pass before every commit.
- Automation goes to Coolify, not GitHub Actions, unless the job needs the diff, a PR event, a status check or a PR comment.

## AI tooling

- **Modern Web Guidance** ([Chrome](https://developer.chrome.com/docs/modern-web-guidance)): `npx modern-web-guidance@latest install`.
- **Astro Docs MCP** (`https://mcp.docs.astro.build/mcp`) for current Astro APIs.

## Design

The design follows the council's style guide, **SWW Styleguide v1.0 (10 October 2026)**, built after the design review by Michael Wallner (Asana D7, 9 October 2026). The style guide PDF and the logo package live in the project folder outside this repo; the design system „SWW Karlsruhe“ (claude.ai artifact) holds the same rules and tokens. In code, the tokens live at the top of `src/styles/global.css` (light values on `:root`, dark values under `prefers-color-scheme: dark`).

Hard rules:

- Use the tokens. Do not hard-code colours, sizes or spacing.
- Colours: ink `#1C2B33`, which is also the body text colour (`--text`); green `#128275` (`--accent`); green deep `#11796D` (`--accent-deep`) for green text on `--surface` and `--surface-key`; mint `#8FD3CA` (`--mint`, fixed as `--brand-mint` for the badge). Mint is never text on white.
- Green and mint together stay under 10 % of a screen and under 5 % of a printed page.
- Why these values: green has to reach 4.5 : 1 on white and stand out from body text by 3 : 1 (WCAG 1.4.1). With body text `#33424A` no green can do both. With body text in ink there is a narrow window, and `#128275` sits in it (4.7 : 1 on white, 3.1 : 1 to ink, hue 173° like the mint). Green deep keeps 4.8 : 1 on `surface` and 4.6 : 1 on `surface-key`; blocks on those surfaces set `--accent:var(--accent-deep)`.
- Links in running text are always underlined in addition to the colour (`p a, dd a, td a, blockquote a, figcaption a`). Navigation, buttons, tiles, table of contents and footer stay without underline.
- Header: logo 56 px high, below 760 px the compact version 40 px high (199 px wide), bar at least 80 px, navigation 16 px, the menu never wraps next to the logo; if it does not fit, it moves below the logo as a whole.
- Serif (Caladea) for headlines and key statements, sans (Carlito) for everything else. Fonts are not changing.
- Logo is direction C, final since 9 October 2026: badge with the ampersand, „Strategierat“ in Caladea Bold over „WIRTSCHAFT & WISSENSCHAFT“ in Carlito Bold caps. `public/logo-hell.svg` on light, `public/logo-dunkel.svg` on dark, `public/logo-kompakt-hell.svg` and `public/logo-kompakt-dunkel.svg` (badge plus „Strategierat“) on mobile and in the footer, `public/favicon.svg` is the badge (Bildmarke). The files come unchanged from the logo package `2026-10-09_SWW-Logo-C-Paket`: never redraw, recolour or re-set them. Aspect ratio 3.84 : 1 (compact 4.96 : 1). Minimum width 200 px for the full logo, 140 px for the compact one; wherever the full logo would be narrower, use the compact one (decision André, 10 October 2026).
- Focus ring 3px, green on white, mint on ink. Respect `prefers-reduced-motion`.
- Neutral design: no city branding, no member company branding, no netzstrategen CI.

---

> Generated from the `netz-code-standards` skill and extended with the council's content rules. Update when the skill or the council's language rules change.
