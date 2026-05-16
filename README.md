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

The site is hosted on [Cloudflare Pages](https://pages.cloudflare.com/) with
these project settings:

- **Build command:** `hugo`
- **Build output directory:** `public`
- **Environment variable:** `HUGO_VERSION` = `0.160.1`

`assets/_headers` is copied into the build output and makes Cloudflare serve
`/llms.txt` as `text/markdown`.

Requests to `/` that send an `Accept: text/markdown` header are rewritten to
`/llms.txt` by a Cloudflare URL Rewrite Transform Rule. Provision or update
that rule (it is not stored in the Pages project) with:

```
$ CLOUDFLARE_API_TOKEN=... ./scripts/cloudflare-transform-rule.sh
```

## License

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).
