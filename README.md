# website-marketing

Static Jekyll marketing site for GitHub Pages deployment, with Tailwind CSS for compiled styling and Alpine.js for lightweight interaction.

## Source file guide

Start with `_data/company.yml` for most business copy: name, phone, email, hero text, stats, included items, reasons, contact text, CTAs, and the disclaimer.

Use the smaller `_data/*.yml` files for repeated content:
- `_data/services.yml` controls service cards and footer service links.
- `_data/faq.yml` controls FAQ accordion rows.
- `_data/process.yml` controls process steps.
- `_data/testimonials.yml` controls testimonial cards.

Page files such as `index.md` and `campaigns/example.md` should stay front-matter-only. Their `layout: landing` setting tells Jekyll to assemble the page from `_layouts/landing.html` and the reusable `_includes/*.html` sections.

Template files contain Liquid comments that explain how the site works. Liquid comments are visible in source code but removed from generated HTML, so they help maintainers without publishing implementation notes.

## Local setup

Local builds are driven by the `Makefile`, which scopes Homebrew Ruby 4.x to this
project only — it does **not** change your global `PATH` and never needs `sudo`.
(`which ruby` on the build host is macOS system Ruby 2.6, which modern Jekyll
cannot use; Homebrew Ruby is installed keg-only.) All Ruby gems install into
`./vendor/bundle` (gitignored). See the header comments in the `Makefile` for the
full rationale.

Requirements:
- Homebrew Ruby 4.x at `/opt/homebrew/opt/ruby` (keg-only is fine)
- Node.js and npm (for the Tailwind CSS build)
- GNU `make`

One-time: install the Ruby toolchain (Jekyll + the GitHub Pages gem set) into
`./vendor/bundle`:

```bash
make install
```

Preview the site locally with live reload at http://127.0.0.1:4000 (Ctrl-C to stop):

```bash
make serve
```

Other targets:

```bash
make build     # build the site into ./_site
make css       # rebuild Tailwind CSS -> assets/css/main.css (runs npm run build:css)
make doctor    # show which ruby/bundler this project resolves to
make clean     # remove _site and .jekyll-cache
```

The Tailwind CSS build still uses Node. Install its dependency once when needed:

```bash
npm install --no-package-lock
```

### How local parity with GitHub Pages works

- `Gemfile` depends on the `github-pages` gem, so the local build uses the same
  Jekyll engine (3.9.x) GitHub Pages runs. Run `bundle` commands through the
  Makefile (or `make`) so the correct Ruby/Bundler is used.
- Because the site targets a Ruby version newer than the GitHub Pages stack, a
  couple of **local-only** shims make the old engine run on Homebrew Ruby 4:
  `tools/ruby4-compat.rb` (loaded via `RUBYOPT` from the Makefile) restores a few
  APIs Ruby removed, and the Makefile forces a UTF-8 locale. GitHub Pages builds
  the site server-side and ignores the Makefile, `tools/`, and `_plugins/`, so
  none of these local shims affect the deployed site.
- `_config.yml` sets `baseurl: ""` and `repository:` so local builds resolve
  asset paths and repository metadata without a GitHub API token.

Remove local dependency artifacts when done if you do not want them left in the
worktree:

```bash
make clean
rm -rf node_modules vendor
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
