# Command Line Interface Guidelines

An open-source guide to help you write better command-line programs, taking traditional UNIX principles and updating them for the modern day.

## Foreword

In the 1980s, if you wanted a personal computer to do something for you, you needed to know what to type when confronted with `C:\>` or `~$`.
Help came in the form of thick, spiral-bound manuals.
Error messages were opaque.
There was no Stack Overflow to save you.
But if you were lucky enough to have internet access, you could get help from Usenet—an early internet community filled with other people who were just as frustrated as you were.
They could either help you solve your problem, or at least provide some moral support and camaraderie.

Forty years later, computers have become so much more accessible to everyone, often at the expense of low-level end user control.
On many devices, there is no command line access at all, in part because it goes against the corporate interests of walled gardens and app stores.

Most people today don’t know what the command line is, much less why they would want to bother with it.
As computing pioneer Alan Kay said in [a 2017 interview](https://www.fastcompany.com/40435064/what-alan-kay-thinks-about-the-iphone-and-technology-now), “Because people don't understand what computing is about, they think they have it in the iPhone, and that illusion is as bad as the illusion that 'Guitar Hero' is the same as a real guitar.”

Kay’s “real guitar” isn’t the CLI—not exactly.
He was talking about ways of programming computers that offer the power of the CLI and that transcend writing software in text files.
There is a belief among Kay’s disciples that we need to break out of a text-based local maxima that we’ve been living in for decades.

It’s exciting to imagine a future where we program computers very differently.
Even today, spreadsheets are by far the most popular programming language, and the no code movement is taking off quickly as it attempts to replace some of the intense demand for talented programmers.

Yet with its creaky, decades-old constraints and inexplicable quirks, the command line is still the most _versatile_ corner of the computer.
It lets you pull back the curtain, see what’s really going on, and creatively interact with the machine at a level of sophistication and depth that GUIs cannot afford.
It’s available on almost any laptop, for anyone who wants to learn it.
It can be used interactively, or it can be automated.
And, it doesn’t change as fast as other parts of the system.
There is creative value in its stability.

So, while we still have it, we should try to maximize its utility and accessibility.

A lot has changed about how we program computers since The Art of UNIX Programming—last published in 2003—laid out standards and best practices for how programs run from the shell should behave.
The command line of the past was _machine-first_: little more than a REPL on top of a scripting platform.
But as general-purpose interpreted languages have flourished, the role of the shell script has shrunk.
Today's command line is _human-first_: a text-based UI that affords access to all kinds of tools, systems and platforms.
In the past, the editor was inside the terminal—today, the terminal is just as often a feature of the editor.
And there’s been a proliferation of `git`-like multi-tool commands.
Commands within commands, and high-level commands that perform entire workflows rather than atomic functions.

Inspired by traditional UNIX philosophy, driven by an interest in encouraging a more delightful and accessible CLI environment, and guided by our experiences as programmers, we decided it was time to revisit the best practices and design principles for building command line programs.

Long live the command line!

## Introduction

This document covers both high-level design philosophy, and concrete guidelines.
It’s heavier on the guidelines because our philosophy as practitioners is not to philosophize too much.
We believe in learning by example, so we’ve provided plenty of those.

This guide doesn’t cover full-screen terminal programs like emacs and vim.
Full-screen programs are niche projects—very few of us will ever be in the position to design one.

This guide is also agnostic about programming languages and tooling in general.

Who is this guide for?
- If you are creating a CLI program and you are looking for principles and concrete best practices for its UI design, this guide is for you.
- If you are a professional “CLI UI designer”, that’s amazing - we’d love to learn from you.
- If you’d like to avoid obvious missteps of the variety that go against 40 years of CLI design conventions, this guide is for you.
- If you want to delight people with your program’s good design and helpful help, this guide is definitely for you.
- If you are creating a GUI program, this guide is not for you - though you may learn some GUI anti-patterns if you decide to read it anyway.
  (Do GUI programmers even read, or do they just look at things?)
- If you are designing an immersive, full-screen CLI port of Minecraft, this guide isn’t for you.
  (But we can’t wait to see it!)

## Philosophy

These are what we consider to be the fundamental principles of good CLI design.

### Human-first design

Traditionally, UNIX commands were written under the assumption they were going to be used primarily by other programs.
They had more in common with functions in a programming language than with graphical applications.

Today, even though many CLI programs are used primarily (or even exclusively) by humans, a lot of their interaction design still carries the baggage of the past.
It’s time to shed some of this baggage: if a command is going to be used primarily by humans, it should be designed for humans first.

### Simple parts that work together

A core tenet of [the original UNIX philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) is the idea that small, simple programs with clean interfaces can be combined to build larger systems.
Rather than stuff more and more features into those programs, you make programs that are modular enough to be recombined as needed.

In the old days, pipes and shell scripts played a crucial role in the process of composing programs together.
Their role might have diminished with the rise of general-purpose interpreted languages, but they certainly haven’t gone away.
What’s more, large-scale automation—in the form of CI/CD, orchestration and configuration management—has flourished.
Making programs composable is just as important as ever.

Fortunately, the long-established conventions of the UNIX environment, designed for this exact purpose, still help us today.
Standard in/out/err, signals, exit codes and other mechanisms ensure that different programs click together nicely.
Plain, line-based text is easy to pipe between commands.
JSON, a much more recent invention, affords us more structure when we need it, and lets us more easily integrate command-line tools with the web.

Whatever software you’re building, you can be absolutely certain that people will use it in ways you didn’t anticipate.
Your software _will_ become a part in a larger system - your only choice is over whether it will be a well-behaved part.

Most importantly, designing for composability does not need to be at odds with designing for humans first.
Much of the advice in this document is about how to achieve both.

### Consistency across programs

The terminal’s conventions are hardwired into our fingers.
We had to pay an upfront cost by learning about command line syntax, flags, environment variables and so on, but it pays off in long-term efficiency… as long as programs are consistent.

Where possible, a CLI should follow patterns that already exist.
That’s what makes CLIs intuitive and guessable; that’s what makes users efficient.

That being said, sometimes consistency conflicts with ease of use.
For example, many long-established UNIX commands don't output much information by default, which can cause confusion or worry for people less familiar with the command line.

When following convention would compromise a program’s usability, it might be time to break with it—but such a decision should be made with care.

### Saying (just) enough

The terminal is a world of pure information.
You could make an argument that information is the interface—and that, just like with any interface, there’s often too much or too little of it.

A command is saying too little when it hangs for several minutes and the user starts to wonder if it’s broken.
A command is saying too much when it dumps pages and pages of debugging output, drowning what’s truly important in an ocean of loose detritus.
The end result is the same: a lack of clarity, leaving the user confused and irritated.

It can be very difficult to get this balance right, but it’s absolutely crucial if software is to empower and serve its users.

### Ease of discovery

When it comes to making functionality discoverable, GUIs have the upper hand.
Everything you can do is laid out in front of you on the screen, so you can find what you need without having to learn anything, and perhaps even discover things you didn’t know were possible.

It is assumed that command-line interfaces are the opposite of this—that you have to remember how to do everything.
The original [Macintosh Human Interface Guidelines](https://www.goodreads.com/book/show/1087110.Macintosh_Human_Interface_Guidelines), published in 1992, recommend “See-and-point (instead of remember-and-type)”, as if you could only choose one or the other.

These things needn’t be mutually exclusive.
The efficiency of using the command-line comes from remembering commands, but there’s no reason the commands can’t help you learn and remember.

Discoverable CLIs have comprehensive help texts, provide lots of examples, suggest what command to run next, suggest what to do when there is an error.
There are lots of ideas that can be stolen from GUIs to make CLIs easier to learn and use, even for power users.

Citation: The Design of Everyday Things (Don Norman), Macintosh Human Interface Guidelines

### Conversation as the norm

GUI design, particularly in its early days, made heavy use of _metaphor_: desktops, files, folders, recycle bins.
It made a lot of sense, because computers were still trying to bootstrap themselves into legitimacy.
The ease of implementation of metaphors was one of the huge advantages GUIs wielded over CLIs.
Ironically, though, the CLI has embodied an accidental metaphor all along: it’s a conversation.

Beyond the most utterly simple commands, running a program usually involves more than one invocation.
Usually, this is because it’s hard to get it right the first time: the user types a command, gets an error, changes the command, gets a different error, and so on, until it works.
This mode of learning through repeated failure is like a conversation the user is having with the program.

Trial-and-error isn’t the only type of conversational interaction, though.
There are others:

- Running one command to set up a tool and then learning what commands to run to actually start using it.
- Running several commands to set up an operation, and then a final command to run it (e.g. multiple `git add`s, followed by a `git commit`).
- Exploring a system—for example, doing a lot of `cd` and `ls` to get a sense of a directory structure, or `git log` and `git show` to explore the history of a file.
- Doing a dry-run of a complex operation before running it for real.

Acknowledging the conversational nature of command-line interaction means you can bring relevant techniques to bear on its design.
You can suggest possible corrections when user input is invalid, you can make the intermediate state clear when the user is going through a multi-step process, you can confirm for them that everything looks good before they do something scary.

The user is conversing with your software, whether you intended it or not.
At worst, it’s a hostile conversation which makes them feel stupid and resentful.
At best, it’s a pleasant exchange that speeds them on their way with newfound knowledge and a feeling of achievement.

_Further reading: [The Anti-Mac User Interface (Don Gentner and Jakob Nielsen)](https://www.nngroup.com/articles/anti-mac-interface/)_

### Robustness

Robustness is both an objective and a subjective property.
Software should _be_ robust, of course: unexpected input should be handled gracefully, operations should be idempotent where possible, and so on.
But it should also _feel_ robust.

You want your software to feel like it isn’t going to fall apart.
You want it to feel immediate and responsive, as if it were a big mechanical machine, not a flimsy plastic “soft switch”.

Subjective robustness requires attention to detail and thinking hard about what can go wrong.
It’s lots of little things: keeping the user informed about what’s happening, explaining what common errors mean, not printing scary-looking stack traces.

As a general rule, robustness can also come from keeping it simple.
Lots of special cases and complex code tend to make a program fragile.

_Further reading: [The Art of UNIX Programming: Robustness](http://www.catb.org/~esr/writings/taoup/html/ch01s06.html#id2878145)_

### Empathy

Command-line tools are a programmer’s creative toolkit, so they should be enjoyable to use.
This doesn’t mean turning them into a video game, or using lots of emoji (though there’s nothing inherently wrong with emoji 😉).
It means giving the user the feeling that you are on their side, that you want them to succeed, that you have thought carefully about their problems and how to solve them.

There’s no list of actions you can take that will ensure they feel this way, although we hope that following our advice will take you some of the way there.
Delighting the user means _exceeding their expectations_ at every turn, and that starts with empathy.

### Chaos

The world of the terminal is a mess.
Inconsistencies are everywhere, slowing us down and making us second-guess ourselves.

Yet it’s undeniable that this chaos has been a source of power.
The terminal, like the UNIX-descended computing environment in general, places very few constraints on what you can build.
In that space, all manner of invention has bloomed.

It’s ironic that this document implores you to follow existing patterns, right alongside advice that contradicts decades of command-line tradition.
We’re just as guilty of breaking the rules as anyone.

The time might come when you, too, have to break the rules.
Do so with intention and clarity of purpose.

> “Abandon a standard when it is demonstrably harmful to productivity or user satisfaction.” — Jef Raskin, [The Humane Interface](https://en.wikipedia.org/wiki/The_Humane_Interface)

## Guidelines

This is a collection of specific things you can do to make your command-line program better.

The first section contains the essential things you need to follow.
Get these wrong, and your program will be either hard to use or a bad CLI citizen.

The rest are nice-to-haves.
If you have the time and energy to add these things, your program will be a lot better than the average program.

The idea is that, if you don’t want to think too hard about the design of your program, you don’t have to: just follow these rules and your program will probably be good.
On the other hand, if you’ve thought about it and determined that a rule is wrong for your program, that’s fine.
(There’s no central authority that will reject your program for not following arbitrary rules.)

Also—these rules aren’t written in stone.
(TK See that edit button below?) If you disagree with a general rule for good reason, we hope you’ll propose a change.

### The Basics

There are a few basic rules you need to follow.
Get these wrong, and your program will be either very hard to use, or flat-out broken.

**Use a command-line argument parsing library where you can.**
Either your language’s built-in one, or a good third-party one.
They will normally handle arguments, flag parsing, help text, and even spelling suggestions in a sensible way.

Here are some that we like:
* Go: [Cobra](https://github.com/spf13/cobra), [cli](https://github.com/urfave/cli)
* Node: [oclif](https://oclif.io/)
* Python: [Click](https://click.palletsprojects.com/), [Typer](https://github.com/tiangolo/typer)
* Ruby: [TTY](https://ttytoolkit.org/)

**Return zero exit code on success, non-zero on failure.**
Exit codes are how scripts determine whether a program succeeded or failed, so you should report this correctly.
Map the non-zero exit codes to the most important failure modes.

**Send output to stdout.**
The primary output for your command should go to stdout.
Anything that is machine readable should also go to stdout—this is where piping sends things by default.

**Send messaging to stderr.**
Log messages, errors, and so on should all be sent to stderr.
This means that when commands are piped together, these messages are displayed to the user and not fed into the next command.

### Help

**Display help text when passed no options, the `-h` flag, or the `--help` flag.**

**Display a concise help text by default.**
If you can, display help by default when `myapp` or `myapp subcommand` is run.
Unless your program is very simple and does something obvious by default (e.g. `ls`), or your program reads input interactively (e.g. `cat`).

The concise help text should only include:

- A description of what your program does.
- One or two example invocations.
- Descriptions of flags, unless there are lots of them.
- An instruction to pass the `--help` flag for more information.

`jq` does this well.
When you type `jq`, it displays an introductory description and an example, then prompts you to pass `jq --help` for the full listing of flags:

```bash
$ jq
jq - commandline JSON processor [version 1.6]

Usage:    jq [options] <jq filter> [file...]
    jq [options] --args <jq filter> [strings...]
    jq [options] --jsonargs <jq filter> [JSON_TEXTS...]

jq is a tool for processing JSON inputs, applying the given filter to
its JSON text inputs and producing the filter's results as JSON on
standard output.

The simplest filter is ., which copies jq's input to its output
unmodified (except for formatting, but note that IEEE754 is used
for number representation internally, with all that that implies).

For more advanced filters see the jq(1) manpage ("man jq")
and/or https://stedolan.github.io/jq

Example:

    $ echo '{"foo": 0}' | jq .
    {
        "foo": 0
    }

For a listing of options, use jq --help.
```

**Show full help when -h and --help is passed.**
All of these should show help:

```
$ myapp
$ myapp --help
$ myapp -h
```

Ignore any other flags and arguments that are passed—you should be able to add `-h` to the end of anything and it should show help.
Don’t overload `-h`.

If your program is a `git`-like, the following should also offer help:

```
$ myapp help
$ myapp help subcommand
$ myapp subcommand --help
$ myapp subcommand -h
```

**Provide a support path for feedback and issues.**
A website or GitHub link in the top-level help text is common.

**In help text, link to the web version of the documentation.**
If you have a specific page or anchor for a subcommand, link directly to that.
This is particularly useful if there is more detailed documentation on the web, or further reading that might explain the behavior of something.

**Lead with examples.**
Users tend to use examples over other forms of documentation, so show them first in the help page, particularly the common complex uses.
If it helps explain what it’s doing and it isn’t too long, show the actual output too.

You can tell a story with a series of examples, building your way toward complex uses.
TK example?

**If you’ve got loads of examples, put them somewhere else,** in a cheat sheet command or a web page.
It’s useful to have exhaustive, advanced examples, but you don’t want to make your help text really long.

**Don’t bother with man pages.**
We believe that if you’re following these guidelines for help and documentation, you won’t need man pages.
Not enough people use man pages, and they don’t work on Windows.
If your CLI framework and package manager make it easy to output man pages, go for it, but otherwise your time is best spent improving web docs and built-in help text.

_Citation: [12 Factor CLI Apps](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46)._

**If your help text is long, pipe it through a pager.**
This is one useful thing that `man` does for you.
See the advice in the “Output” section below.

**Display the most common flags and commands at the start of the help text.**
It’s fine to have lots of flags, but if you’ve got some really common ones, display them first.
For example, the Git command displays the commands for getting started and the most commonly used subcommands first:

```
$ git
usage: git [--version] [--help] [-C <path>] [-c <name>=<value>]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           <command> [<args>]

These are common Git commands used in various situations:

start a working area (see also: git help tutorial)
   clone      Clone a repository into a new directory
   init       Create an empty Git repository or reinitialize an existing one

work on the current change (see also: git help everyday)
   add        Add file contents to the index
   mv         Move or rename a file, a directory, or a symlink
   reset      Reset current HEAD to the specified state
   rm         Remove files from the working tree and from the index

examine the history and state (see also: git help revisions)
   bisect     Use binary search to find the commit that introduced a bug
   grep       Print lines matching a pattern
   log        Show commit logs
   show       Show various types of objects
   status     Show the working tree status
…
```

TK **Write use-case-driven documentation.**
If your help text shows people how to use all of the commands and flags, your documentation should tutorials with end-to-end examples of common flows.

**Use formatting in your help text.**
Bold headings make it much easier to scan.
But, try to do it in a erminal-independent way so that your users aren't staring down a wall of escape characters.

<pre>
<b>$ heroku apps --help</b>
list your apps

<b>USAGE</b>
  $ heroku apps

<b>OPTIONS</b>
  -A, --all          include apps in all teams
  -p, --personal     list apps in personal account when a default team is set
  -s, --space=space  filter by space
  -t, --team=team    team to use
  --json             output in json format

<b>EXAMPLES</b>
  $ heroku apps
  === My Apps
  example
  example2

  === Collaborated Apps
  theirapp   other@owner.name

<b>COMMANDS</b>
  apps:create     creates a new app
  apps:destroy    permanently destroy an app
  apps:errors     view app errors
  apps:favorites  list favorited apps
  apps:info       show detailed app information
  apps:join       add yourself to a team app
  apps:leave      remove yourself from a team app
  apps:lock       prevent team members from joining an app
  apps:open       open the app in a web browser
  apps:rename     rename an app
  apps:stacks     show the list of available stacks
  apps:transfer   transfer applications to another user or team
  apps:unlock     unlock an app so any team member can join
</pre>

Note: When `heroku apps --help` is piped through a pager, the command emits no escape characters.

**If the user did something wrong and you can guess what they meant, suggest it.**
For example, `brew update jq` tells you that you should run `brew upgrade jq`.

You can ask if they want to run the suggested command, but don’t force it on them.
For example:

```
$ heroku pss
 ›   Warning: pss is not a heroku command.
Did you mean ps? [y/n]:
```

Rather than suggesting the corrected syntax, you might be tempted to just run it for them, as if they’d typed it right in the first place.
Sometimes this is the right thing to do, but not always.

Firstly, invalid input doesn’t necessarily imply a simple typo—it can often mean the user has made a logical mistake, or misused a shell variable.
Assuming what they meant can be dangerous, especially if the resulting action modifies state.

Secondly, be aware that if you change what the user typed, they won’t learn the correct syntax.
In effect, you’re ruling that the way they typed it is valid and correct, and you’re committing to supporting that indefinitely.
Be intentional in making that decision, and document both syntaxes.

_Further reading: [“Do What I Mean”](http://www.catb.org/~esr/jargon/html/D/DWIM.html)_

**If your command is expecting to have something piped to it and `stdin` is an interactive terminal, display help immediately and quit.**
This means it doesn’t just hang, like `cat`.
Alternatively, you could print a log message to `stderr`.

### Output

**Human-readable output is paramount.**
Humans come first, machines second.
If `stderr` is an interactive terminal (a TTY), assume you’re talking to a human.
(TK resolve comments)

**Have machine-readable output where it does not impact usability.**
Streams of text is the universal interface in UNIX.
Programs typically output lines of text, and programs typically expect lines of text as input,
therefore you can compose multiple programs together.
This is normally done to make it possible to write scripts,
but it can also help the usability for humans using programs.
For example, a user should be able to pipe output to `grep` and it should do what they expect.

> “Expect the output of every program to become the input to another, as yet unknown, program.”
— [Doug McIlroy](https://homepage.cs.uri.edu/~thenry/resources/unix_art/ch01s06.html)

**If human-readable output breaks machine-readable output, use `--plain` to display output in plain, tabular text format for integration with tools like `grep` or `awk`.**
In some cases, you might need to output information in a different way to make it human-readable.
(TK example with and without --plain) For example, if you are displaying a line-based table, you might choose to split a cell into multiple lines, fitting in more information while keeping it within the width of the screen.
This breaks the expected behavior of there being one piece of data per line, so you should provide a `--plain` flag for scripts, which disables all such manipulation and outputs one record per line.

**Display output as formatted JSON if `--json` is passed.**
JSON allows for more structure than plain text, so it makes it much easier to output and handle complex data structures.
[`jq`](https://stedolan.github.io/jq/) is a common tool for working with JSON on the command-line, and there is now a [whole ecosystem of tools](https://ilya-sher.org/2018/04/10/list-of-json-tools-for-command-line/) that output and manipulate JSON.

It is also widely used on the web, so by using JSON as the input and output of programs, you can pipe directly to and from web services using `curl`.

**Display output on success, but keep it brief.**
Traditionally, when nothing is wrong, UNIX commands display no output to the user.
This makes sense when they’re being used in scripts, but can make commands appear to be hanging or broken when used by humans.
For example, `cp` will not print anything, even if it takes a long time.

It’s rare that printing nothing at all is the best default behaviour, but it’s usually best to err on the side of less.

For instances where you do want no output (for example, when used in shell scripts), to avoid clumsy redirection of `stderr` to `/dev/null`, you can provide a `-q` option to suppress all non-essential output.

**If you change state, tell the user.**
When a command changes the state of a system, it’s especially valuable to explain what has just happened, so the user can model the state of the system in their head—particularly if the result doesn’t directly map to what the user requested.

For example, `git push` tells you exactly what it is doing, and what the new state of the remote branch is:

```
$ git push
Enumerating objects: 18, done.
Counting objects: 100% (18/18), done.
Delta compression using up to 8 threads
Compressing objects: 100% (10/10), done.
Writing objects: 100% (10/10), 2.09 KiB | 2.09 MiB/s, done.
Total 10 (delta 8), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (8/8), completed with 8 local objects.
To github.com:replicate/replicate.git
 + 6c22c90...a2a5217 bfirsh/fix-delete -> bfirsh/fix-delete
```

**Make it easy to see the current state of the system.**
If your program does a lot of complex state changes and it is not immediately visible in the filesystem, make sure you make this easy to view.

For example, `git status` tells you as much information as possible about the current state of your Git repository, and some hints at how to modify the state:

```
$ git status
On branch bfirsh/fix-delete
Your branch is up to date with 'origin/bfirsh/fix-delete'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   cli/pkg/cli/rm.go

no changes added to commit (use "git add" and/or "git commit -a")
```

**Suggest commands the user should run.**
When several commands form a workflow, suggesting to the user commands they can run next helps them learn how to use your program and discover new functionality.
For example, in the `git status` output above, it suggests commands you can run to modify the state you are viewing.

**Actions crossing the boundary of the program’s internal world should usually be explicit.**
This includes things like:

- Reading or writing files that the user didn’t explicitly pass as arguments (unless those files are storing internal program state, such as a cache).
- Talking to a remote server, e.g. to download a file.

**Increase information density—with ASCII art!** (TK edit this)
This way `ls` shows permissions— when you first see it you can ignore it, later when you learn it it becomes really valuable.
Permissions in `ls` are “glanceable” / scannable — you can pick out patterns as you learn it.

```
-rw-r--r-- 1 root root     68 Aug 22 23:20 resolv.conf
lrwxrwxrwx 1 root root     13 Mar 14 20:24 rmt -> /usr/sbin/rmt
drwxr-xr-x 4 root root   4.0K Jul 20 14:51 security
drwxr-xr-x 2 root root   4.0K Jul 20 14:53 selinux
-rw-r----- 1 root shadow  501 Jul 20 14:44 shadow
-rw-r--r-- 1 root root    116 Jul 20 14:43 shells
drwxr-xr-x 2 root root   4.0K Jul 20 14:57 skel
-rw-r--r-- 1 root root      0 Jul 20 14:43 subgid
-rw-r--r-- 1 root root      0 Jul 20 14:43 subuid
```

**Use color with intention.**
For example, you might want to highlight some text so the user notices it, or use red to indicate an error.
Don’t overuse it—if everything is a different color, then the color means nothing and only makes it harder to read.

**Disable color if your program is not in a terminal or the user requested it.**
These things should disable colors:

- `stdout` or `stderr` is not an interactive terminal (a TTY).
  It’s best to individually check -- if you’re piping `stdout` to another program, it’s still useful to get colors on `stderr`.
- The `NO_COLOR` environment variable is set.
- The `TERM` environment variable has the value `dumb`.
- The user passes the option `--no-color`.
- You may also want to add a `MYAPP_NO_COLOR` environment variable in case users want to disable color specifically for your program.

_Further reading: [no-color.org](https://no-color.org/), [12 Factor CLI Apps](https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46)_

**If `stdout` is not an interactive terminal, don’t display any animations.**
This will stop progress bars turning into Christmas trees in CI log output.

**Use symbols and Emoji where it makes things clearer.**
(TK is emoji capitalized or not?) Pictures can be better than words if you need to make several things distinct, catch the user’s attention, or just add a bit of character.
Be careful though -- it can be easy to overdo it and make your program look cluttered or feel like a toy.

For example, [yubikey-agent](https://github.com/FiloSottile/yubikey-agent) uses Emoji to add structure to the output so it isn’t just a wall of text, and a ❌ to draw your attention to an important piece of information:

```shell-session
$ yubikey-agent -setup
🔐 The PIN is up to 8 numbers, letters, or symbols. Not just numbers!
❌ The key will be lost if the PIN and PUK are locked after 3 incorrect tries.

Choose a new PIN/PUK: 
Repeat the PIN/PUK: 

🧪 Retriculating splines …

✅ Done! This YubiKey is secured and ready to go.
🤏 When the YubiKey blinks, touch it to authorize the login.

🔑 Here's your new shiny SSH public key:
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCEJ/
UwlHnUFXgENO3ifPZd8zoSKMxESxxot4tMgvfXjmRp5G3BGrAnonncE7Aj11pn3SSYgEcrrn2sMyLGpVS0=

💭 Remember: everything breaks, have a backup plan for when this YubiKey does.
```

**By default, don’t output information that’s only understandable by the creators of the software.**
If a piece of output serves only to help you (the developer) understand what your software is doing, it almost certainly shouldn’t be displayed to normal users by default—only in verbose mode.

Invite usability feedback from outsiders and people who are new to your project.
They’ll help you see important issues that you are too close to the code to notice.

**Don’t treat stderr like a log file, at least not by default.**
Don’t print log level labels (`ERR`, `WARN`, etc.) or extraneous contextual information, unless in verbose mode.

**Use a pager (e.g. `less`) if you are outputting a lot of text.**
For example, `git diff` does this by default.
Using a pager can be error-prone, so be careful with your implementation such that you don’t make the experience worse for the user.
You shouldn’t use a pager if `stdin` or `stdout` is not an interactive terminal.

A good sensible set of options to use for `less` is `less -FIRX`.
This does not page if the content fills one screen, ignores case when you search, enables color and formatting, and leaves the contents on the screen when `less` quits.

There might be libraries in your language that are more robust than piping to `less`.
For example, [pypager](https://github.com/prompt-toolkit/pypager) in Python.

### Errors

One of the most common reasons to consult documentation is to fix errors.
If you can make errors into documentation, then this will save the user loads of time.

**Catch errors and [rewrite them for humans](https://www.nngroup.com/articles/error-message-guidelines/).**
If you’re expecting an error to happen, catch it and rewrite the error message to be useful.
Think of it like a conversation, where the user has done something wrong and the program is guiding them in the right direction.
Example: “Can’t write to file.txt. You might need to make it writable by running ‘chmod +w file.txt’.”

**Signal-to-noise ratio is crucial.**
The more irrelevant output you produce, the longer it’s going to take the user to figure out what they did wrong.
If your program produces multiple errors of the same type, consider grouping them under a single explanatory header instead of printing many similar-looking lines.

**Consider where the user will look first.**
Put the most important information at the end of the output.
The eye will be drawn to red text, so use it intentionally and sparingly.

**If there is an unexpected or unexplainable error, provide debug and traceback information, and instructions on how to submit a bug.**
That said, don’t forget about the signal-to-noise ratio: you don’t want to overwhelm the user with information they don’t understand.
Consider writing the debug log to a file instead of printing it to the terminal.

**Make it effortless to submit bug reports.**
One nice thing you can do is provide a URL and have it pre-populate as much information as possible.
