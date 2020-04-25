# Command-line Interface Guidelines

Command-line interfaces gives users great power, but can also be hard to use. The design of command-line tools has been greatly influenced by the [Unix programming philosophy](https://en.wikipedia.org/wiki/Unix_philosophy). This is a modern interpretation of those ideas, along with some specific guidelines on how to create powerful, intuitive, and delightful command-line tools.

## Design Principles

### Humans first

Design for human interaction first, computer interaction second, but don't compromise either.

### Make programs work together

Integrating Unix tools with each other is what makes them so powerful. Design the output of commands to become an input in another command.

If this compromises usability, provide a flag for machine-readable output. If there is interactive input, provide a non-interactive way to do it.

### Make functionality discoverable

The best documentation is no documentation. Users should be able to figure out how your tool works without having to read documentation.

Graphical user interfaces can easily guide users to doing things a certain way, or explain how things work. Command-line interfaces don't have this luxury, so we need to overcompensate.

When you type the command with no arguemnts, display some brief help text describing what the tool is with some examples for how to get started. If you miss a required flag, prompt for a value interactively. Suggest other commands to run next in command output.

### Follow existing design patterns, where appropriate

Command-line tools are hardwired into programmers' fingers. Where possible, follow patterns that already exist. That is what makes command-line interface intuitive.

But, balance that with ease of use. Don't follow an existing pattern if it makes life hard for users not familiar with the command-line. For example, UNIX commands historically don't output much information by default, which can be confusing.

### Make it delightful to use

[aanand always said this]

## Architecture

Two types of CLIs: single-command UNIX-style CLIs (`cp`, `grep`), multi-command integrated tools (`git`, `npm`, `docker`).

[explain reason for multi-command tools, departure from UNIX philosophy, etc]

## Subcommands

## Help

## Flags and arguments

## Output

## Interactivity

## Errors

## Automation

## Streams

## Configuration

## Tab completion & shell integration

## Misc

- Make it fast
- Distribute it as a single binary

## Implementations

- https://oclif.io/

## References

- [The Unix Programming Environment](https://en.wikipedia.org/wiki/The_Unix_Programming_Environment) – Brian W. Kernighan, Rob Pike
- [12 Factor CLI Apps](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46) – Jeff Dickey
- https://web.archive.org/web/20130304065335/http://www.antoarts.com/designing-command-line-interfaces/
