# SmileScape — Web Deploy Guide (`go.smilescapeclinic.com`)

> The Astro site in `web/` deploys to **Cloudflare Workers (Static Assets)**.
> Worker name: **`eywa-smile-scape`** · Domain: **`go.smilescapeclinic.com`** · Build: `npm run build` (→ `web/dist/`).
> Pattern mirrors **eywa-the-face-hospital** / **eywa-vitality-hospital**.

---

## 0) Safety first — `go.` vs the live WordPress site

- **`go.smilescapeclinic.com`** = the Astro app on a Cloudflare **Worker** (Google-Ads landing pages).
- **`smilescapeclinic.com`** (apex) = the **live WordPress** site, on a separate origin.
- They are **different DNS records / different origins**. Deploying the Worker behind `go.` **cannot touch the WordPress apex.** ✅
- The only thing any `go.` deploy affects is the ads landing page itself — so the real risk is *publishing a broken build to `go.`*, not breaking WordPress.

---

## Mode A — Manual deploy (current, works today)

From `web/`:
```bash
cd "/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape/web"
npm install            # first time only
npm run deploy         # = astro build && npx wrangler deploy
# (wrangler login if prompted; serves ./dist; route in wrangler.jsonc attaches go.)
```
- `wrangler.jsonc` currently contains the `routes: [{ pattern: "go.smilescapeclinic.com", custom_domain: true }]` line → manual deploy keeps the domain attached. **Keep this line while you stay on manual deploy.**
- Full control: nothing goes live until you run the command. Best during the parallel-launch / ads phase.

---

## Mode B — Auto-deploy via Cloudflare Workers Builds + GitHub (recommended)

Push to the connected branch → Cloudflare builds & deploys automatically. No GitHub Actions file needed (this is Cloudflare-native CI, same as the-face-hospital).

### ⚠️ The one gotcha (learned on sister brand vitality-hospital, build #225bc7)
With Workers Builds, **`wrangler.jsonc` must NOT contain a `routes: [{ custom_domain: true }]` line** — it conflicts with dashboard domain management and **fails the build**. The custom domain is attached **via the dashboard** instead.

### Step-by-step (do in this order — keeps `go.` live)

**1. Push the branch to GitHub** (it isn't on the remote yet)
```bash
cd "/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape"
git push -u origin web-skeleton
```

**2. Confirm the CF account + that `go.` already shows as a Custom Domain**
- Cloudflare Dashboard → **Workers & Pages → `eywa-smile-scape` → Settings → Domains & Routes** (a.k.a. Triggers → Custom Domains).
- You should see `go.smilescapeclinic.com` listed (created by the earlier manual deploy). If yes → the domain is already dashboard-managed and will survive the switch. Note the **Account** you're in (the one that owns the `smilescapeclinic.com` zone).

**3. Make `wrangler.jsonc` route-less** (ask Claude, or edit yourself)
- Remove the `routes: [...]` line. Optionally add `"account_id": "<this CF account id>"`.
- ⚠️ **After this change, do NOT run `npm run deploy` (manual)** — a manual route-less deploy can detach the domain. From here on, deploy only via Workers Builds.

**4. Connect the repo in the dashboard**
- Workers & Pages → `eywa-smile-scape` → **Settings → Builds → Connect** (GitHub: `the-gifted-digital/eywa-smile-scape`).
- **Root directory:** `web`
- **Build command:** `npm run build`
- **Deploy command:** `npx wrangler deploy`
- **Branch:** `web-skeleton` (see Branch strategy below)

**5. First build + verify**
- Trigger a build (push a commit or "Retry build"). It deploys to `*.workers.dev` and to `go.` (domain still attached from step 2).
- Open `https://go.smilescapeclinic.com/lp/dental-implant/` → confirm it still loads. If `go.` ever drops, re-attach it in step 2's dashboard page (instant — DNS already on CF).

**6. Done** — every later push to the connected branch auto-deploys.

---

## Branch strategy (important for a live ads page)

Workers Builds deploys **every push to the connected branch**. To avoid pushing a half-done change to the live `go.`:

- **Simplest (now):** connect to **`web-skeleton`** — it already holds the live code, no merge needed. Just be deliberate about what you push there.
- **Safer (later):** make a dedicated **`production`** (or `main`) deploy branch. Do day-to-day work on feature branches → merge into the deploy branch only when you want it live. Cloudflare also auto-creates **preview URLs** for non-production branches, so you can eyeball a branch before merging.
- the-face-hospital deploys from `main`. If you want to match that, merge `web-skeleton` → `main` and point Builds at `main` (bigger one-time merge; do when ready).

---

## Rollback
- Cloudflare Dashboard → `eywa-smile-scape` → **Deployments** → pick a previous good deployment → **Rollback** (instant). Or revert the commit and push.

## Quick reference
| | value |
|---|---|
| Worker | `eywa-smile-scape` |
| Domain | `go.smilescapeclinic.com` |
| Repo | `github.com/the-gifted-digital/eywa-smile-scape` |
| Build root | `web/` · cmd `npm run build` · output `dist/` |
| Manual deploy | `cd web && npm run deploy` |
| Config | `web/wrangler.jsonc` |
