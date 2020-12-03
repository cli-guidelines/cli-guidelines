# Command Line Interface Guidelines

An open-source guide to help you write better command-line programs, taking traditional UNIX principles and updating them for the modern day.

This is the source code for the guide. To read it, go to [clig.dev](https://clig.dev/).

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

## License

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).
