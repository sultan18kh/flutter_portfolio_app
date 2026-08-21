# Deployment Guide — sultankhan.me on Cloudflare Pages

Free, production-grade deployment of this Flutter web app to `sultankhan.me`, with CI/CD,
DNS, and SSL all on Cloudflare's free tier.

## Why Cloudflare Pages (not GitHub Pages)

| | Cloudflare Pages | GitHub Pages |
|---|---|---|
| Bandwidth | Unlimited, free | Soft 100GB/mo limit |
| CDN | Global Anycast, 300+ PoPs | Fastly (fixed) |
| SSL | Free, auto-renewed, TLS 1.3 | Free, auto-renewed |
| Custom domain DNS | Full zone (proxied, WAF, cache rules) | A/CNAME only, no proxy |
| Redirects/headers | `_redirects` / `_headers` files, native | Needs a Jekyll/Actions workaround |
| Build | Git-integrated or direct upload | Actions → `gh-pages` branch |
| Preview deployments | Every branch/PR, free | Not built-in |

Cloudflare Pages wins because you get the CDN, WAF, and DNS zone in one free product, and
`sultankhan.me` gets proxied (hidden origin IP, DDoS protection) instead of just statically hosted.

## Prerequisites

- `sultankhan.me` already purchased (done)
- GitHub repo: `sultan18kh/flutter_portfolio_app` (this repo)
- A free Cloudflare account: https://dash.cloudflare.com/sign-up

---

## Step 1 — Move the domain's DNS to Cloudflare

Cloudflare Pages custom domains work best when Cloudflare *also* manages the DNS zone (free
Universal SSL, proxying, WAF, and Cloudflare auto-creates the right records for you).

1. Cloudflare dashboard → **Add a site** → enter `sultankhan.me` → select the **Free** plan.
2. Cloudflare scans existing DNS records and shows you a summary — review it.
3. Cloudflare gives you two nameservers (e.g. `aria.ns.cloudflare.com`, `bob.ns.cloudflare.com`).
4. Go to your registrar (wherever `sultankhan.me` was bought) → domain settings → **Nameservers**
   → replace the registrar's default nameservers with Cloudflare's two.
5. Propagation takes anywhere from a few minutes to 24h. Cloudflare emails you once active.

**Best practice:** don't touch existing MX/TXT records (email, verification) during this step —
Cloudflare imports them automatically, just confirm they're present after activation.

---

## Step 2 — Create the Cloudflare Pages project

1. Cloudflare dashboard → **Workers & Pages** → **Create** → **Pages** → **Connect to Git**.
2. Authorize Cloudflare's GitHub App, select `sultan18kh/flutter_portfolio_app`.
3. Build settings:
   - **Production branch:** `main`
   - **Build command:** see Step 3 (Flutter isn't preinstalled on Cloudflare's build image)
   - **Build output directory:** `build/web`
4. Don't deploy yet — set the build command first (Step 3), or the first build will fail.

### Build command (installs Flutter, then builds)

Cloudflare's build image is Ubuntu-based but has no Flutter SDK. Use this as the **Build
command**:

```bash
git clone https://github.com/flutter/flutter.git -b stable --depth 1 /tmp/flutter && \
export PATH="$PATH:/tmp/flutter/bin" && \
flutter config --enable-web && \
flutter pub get && \
flutter build web --release
```

This clones stable Flutter fresh on every build (~1-2 min overhead) — reliable, always current,
no maintenance. Pin a version with `-b 3.24.0` instead of `-b stable` if you want reproducible
builds tied to a specific SDK.

---

## Step 3 (recommended alternative) — Build in GitHub Actions, deploy via Wrangler

Cloudflare's git-integrated build re-clones Flutter on every push (slow, and couples your build
to Cloudflare's ephemeral environment). The more robust, industry-standard path: build in GitHub
Actions (where `flutter build web` is fast and cached), then push only the static `build/web`
output to Cloudflare Pages via the `wrangler` CLI.

### 3a. Create a Cloudflare API token

1. Cloudflare dashboard → profile icon → **My Profile** → **API Tokens** → **Create Token**.
2. Use template **"Edit Cloudflare Workers"**, scope it to your account, permission
   **Cloudflare Pages: Edit**.
3. Copy the token — you won't see it again.

### 3b. Add repo secrets

GitHub repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**:

- `CLOUDFLARE_API_TOKEN` — the token from 3a
- `CLOUDFLARE_ACCOUNT_ID` — Cloudflare dashboard → right sidebar of any domain overview page

### 3c. Workflow file

```yaml
# .github/workflows/deploy.yml
name: Deploy to Cloudflare Pages

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      deployments: write
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - run: flutter pub get
      - run: flutter build web --release

      - name: Deploy to Cloudflare Pages
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          command: pages deploy build/web --project-name=portfolio-flutter
```

In the Cloudflare Pages project settings, switch the production branch trigger off (or leave
the project as **Direct Upload** type when creating it in Step 2, instead of Git-connected) so
Cloudflare doesn't also try to build — Actions owns the build, Wrangler owns the upload.

Either Step 2's git-integrated build **or** Step 3's Actions+Wrangler path works standalone —
pick one, don't run both against the same project.

### Required: commit `wrangler.jsonc`

If the deploy step is `npx wrangler deploy` (this project uses Workers static assets, not
classic Pages), Wrangler needs a config file telling it which directory to serve — **without
one committed to the repo, Wrangler interactively generates one on first run and defaults
`assets.directory` to `web` (the unbuilt source template) instead of `build/web` (the compiled
output).** This is exactly what causes a blank screen with `<base href="$FLUTTER_BASE_HREF">`
still literal in the served HTML — the raw template got deployed, not the build.

Fix: commit `wrangler.jsonc` at the repo root (already added):

```jsonc
{
  "name": "flutter-portfolio-app",
  "compatibility_date": "2026-08-20",
  "assets": {
    "directory": "build/web",
    "not_found_handling": "single-page-application"
  }
}
```

With this committed, `wrangler deploy` picks it up automatically — no interactive prompt, no
wrong default. Retrigger the build after committing this file.

---

## Step 4 — Connect the custom domain

1. Cloudflare Pages project → **Custom domains** → **Set up a custom domain**.
2. Enter `sultankhan.me` → Cloudflare auto-creates the CNAME record (flattened at the apex,
   since Cloudflare supports CNAME flattening — no A-record IP juggling needed).
3. Repeat for `www.sultankhan.me`.
4. Decide your canonical host and redirect the other. Recommended: bare domain
   (`sultankhan.me`) is canonical, `www` redirects to it. In **Rules → Redirect Rules**:
   - When hostname equals `www.sultankhan.me` → redirect to `https://sultankhan.me/$1`
     (301, preserve path).

---

## Step 5 — SSL/TLS

Cloudflare issues a free Universal SSL certificate automatically once the domain's proxied
(orange cloud) — usually active within minutes.

1. Cloudflare dashboard → domain → **SSL/TLS** → **Overview** → set mode to **Full (strict)**.
   (Pages origins already terminate TLS correctly, so strict is safe and is the secure default —
   never use "Flexible" for a Pages-hosted site.)
2. **SSL/TLS → Edge Certificates**:
   - **Always Use HTTPS**: on (auto-redirects any `http://` request to `https://`)
   - **Automatic HTTPS Rewrites**: on
   - **Minimum TLS Version**: 1.2
   - **HSTS**: enable, `max-age` 6 months to start (raise to 12 months once confident nothing
     breaks) — tells browsers to always use HTTPS for this domain, closes a downgrade-attack
     window.

---

## Step 6 — Security & caching headers (best practice)

Cloudflare Pages reads a `_headers` file from the build output root. Create:

```
# web/_headers  (copied into build/web/_headers by the build)
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: geolocation=(), microphone=(), camera=()

/assets/*
  Cache-Control: public, max-age=31536000, immutable
```

Flutter's `flutter build web` copies everything under `web/` into `build/web/`, so placing
`_headers` in `web/` ships it automatically on every build.

---

## Step 7 — Verify

- `https://sultankhan.me` loads the portfolio, padlock shows a valid certificate
- `http://sultankhan.me` redirects to `https://`
- `https://www.sultankhan.me` redirects to the bare domain
- SSL Labs check: https://www.ssllabs.com/ssltest/analyze.html?d=sultankhan.me — target grade A
- Push a commit to `main` → confirm Cloudflare Pages (or the Actions workflow) redeploys
  automatically within a couple of minutes

---

## Ongoing

- Every push to `main` auto-deploys — no manual step
- Every PR/branch gets its own preview URL under `*.pages.dev` (git-integrated projects) — useful
  for reviewing changes before merging to `main`
- Rotate the `CLOUDFLARE_API_TOKEN` if it's ever exposed; it only has Pages-edit scope, so blast
  radius is limited to this project
