# website-marketing

Static Jekyll marketing site for GitHub Pages deployment, with Tailwind CSS for compiled styling and Alpine.js for lightweight interaction.

## Local setup

Requirements:
- Ruby with `jekyll` available on `PATH`
- Node.js and npm

Install the local CSS build dependency when needed:

```bash
npm install --no-package-lock
```

Run the Tailwind build:

```bash
npm run build:css
```

Build the Jekyll site:

```bash
jekyll build
```

Serve locally during iteration:

```bash
jekyll serve
```

Remove local dependency artifacts when done if you do not want them left in the worktree:

```bash
rm -rf node_modules .jekyll-cache _site
```

## GitHub Pages configuration

This site is GitHub Pages compatible because it builds to static output and does not use unsupported Jekyll plugins.

Recommended deployment flow:
- Keep source on the main branch.
- Run `npm run build:css` before deployment so `assets/css/main.css` is current.
- Configure GitHub Pages to publish from the repository root or from the branch used by your deployment workflow.
- Keep the primary site URL aligned with the `url` value in `_config.yml`.

## Custom domain

Primary canonical domain format is:

```text
https://example-spectra-home.com
```

When replacing the placeholder domain:
- update `url` in `_config.yml`
- update `domain` in `_data/company.yml`
- point the custom domain in GitHub Pages settings
- point DNS records at GitHub Pages through your DNS provider

### Cloudflare DNS

For GitHub Pages on Cloudflare, configure the DNS records in this order:

1. Keep any existing mail-related records in place before changing the web records.
2. Add apex `A` records for the root domain (`example-spectra-home.com`) pointing to:
   - `185.199.108.153`
   - `185.199.109.153`
   - `185.199.110.153`
   - `185.199.111.153`
3. Add a `CNAME` record for `www` that points to your GitHub Pages default host, for example `<user>.github.io` or `<organization>.github.io`.
4. In Cloudflare, set the GitHub Pages web records to `DNS only`, not proxied, while you complete domain setup and HTTPS issuance.

Warnings:
- Preserve existing email records such as `MX`, `TXT` (SPF), `DKIM`, or mail subdomain records. Do not delete or overwrite them when adding the web records.
- Do not use wildcard DNS records for GitHub Pages custom domains.
- The `www` record should point directly to the GitHub Pages host, not to the apex domain.

## Campaign page workflow

Campaign pages are normal Jekyll page files on the main branch, not separate branches.

To add a new campaign page:
1. Copy `campaigns/example.md` to a new file in `campaigns/`.
2. Keep the page front matter only; do not assemble complex section HTML in the Markdown body.
3. Set `layout: landing`.
4. Override only the fields the campaign needs, such as `title`, `description`, `canonical_url`, `hero_heading`, `hero_subheading`, `primary_cta`, `secondary_cta`, or `show_testimonials`.
5. Reuse shared business content from `_data/*.yml`, especially `_data/company.yml` and `_data/process.yml`.
6. Rebuild Tailwind and Jekyll before publishing.

CTA overrides must stay structured:

```yaml
primary_cta:
  label: "Book a Buyer Inspection"
  href: "#contact"
```
