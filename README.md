# Command-line Interface Guidelines

Command-line interfaces gives users great power, but can also be hard to use. The design of command-line tools has been greatly influenced by the [Unix programming philosophy](https://en.wikipedia.org/wiki/Unix_philosophy). This is a modern interpretation of those ideas, along with some specific guidelines on how to create powerful, intuitive, and delightful command-line tools.

## Contributing to the CLI guide

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
