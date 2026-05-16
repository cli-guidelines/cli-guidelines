# Command Line Interface Guidelines

An open-source guide to help you write better command-line programs, taking traditional UNIX principles and updating them for the modern day.

This is the source code for the guide. To read it, go to [clig.dev](https://clig.dev/).

[Join us on Discord](https://discord.gg/EbAW5rUCkE) if you want to discuss the guide, or just chat about CLI design.

## Contributing

The content of the guide lives in a single Markdown file, [content/_index.md](content/_index.md).
The website is built using [Hugo](https://gohugo.io/).

To run Hugo locally to see your changes, run:

```
$ brew install hugo
$ cd <path>/<to>/cli-guidelines/
$ hugo server
```

To view the site on an external mobile device, run:

```
hugo server --bind 0.0.0.0 --baseURL http://$(hostname -f):1313
```

<!-- TODO: add contact info (how to reach the CLIG creators with questions) -->

## Deployment

The site is hosted on [Cloudflare Workers](https://workers.cloudflare.com/) as
a static-assets project, built and deployed from this repo:

- `build.sh` installs a pinned Hugo and builds the site into `public/`.
- `wrangler.toml` runs `build.sh` and uploads `public/` as the Worker's static
  assets. The Cloudflare deploy command is `npx wrangler deploy`.
- `public/_headers` (from `assets/_headers`) makes Cloudflare serve
  `/llms.txt` as `text/markdown`.

Two zone-level Cloudflare Rules support the site (these are not part of the
deploy):

- a **URL Rewrite** rule that serves `/llms.txt` for requests to `/` sending
  an `Accept: text/markdown` header;
- a **Redirect** rule from `www.clig.dev` to the apex `clig.dev`.

Provision or update both (idempotent) with:

```
$ CLOUDFLARE_API_TOKEN=... ./scripts/cloudflare-transform-rule.sh
```

## License

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).
