---
title: "CLI Guidelines"
type: 'docs'
---

# Command Line Interface Guidelines

> An open-source guide to help you write better command-line programs, taking traditional UNIX principles and updating them for the modern day.

## Foreword

In the 1980s, if you wanted a personal computer to do something for you, you needed to know what to type when confronted with `C:\>` or `~$`. Help came in the form of thick, spiral-bound manuals. Error messages were opaque, and there was no Stack Overflow to save you. It was brutal.

Forty years later, computers have become so much more accessible to everyone, often at the expense of low-level end user control. On many devices, there is no command line access at all, in part because it goes against the corporate interests of walled gardens and app stores.

Most people today don’t know what the command line is, much less why they would want to bother with it. As computing pioneer Alan Kay said in a recent interview, “Because people don't understand what computing is about, they think they have it in the iPhone, and that illusion is as bad as the illusion that 'Guitar Hero' is the same as a real guitar.”

Kay’s “real guitar” isn’t the CLI—not exactly. He was talking about ways of programming computers that offer the power of the CLI and that transcend writing software in text files. There is a belief among Kay’s disciples that we need to break out of a text-based local maxima that we’ve been living in for decades.

It’s exciting to imagine a future where we program computers very differently. Even today, spreadsheets are by far the most popular programming language, and the no code movement is taking off quickly as it attempts to replace some of the intense demand for talented programmers.

Yet with its creaky, decades-old constraints and inexplicable quirks, the command line is still the most versatile corner of the computer. It lets you pull back the curtain, see what’s really going on, and creatively interact with the machine at a level of sophistication and depth that GUIs cannot afford. It’s available on almost any laptop, for anyone who wants to learn it. It can be used interactively, or it can be automated. And, it doesn’t change as fast as other parts of the system. There is creative value in its stability.

So, while we still have it, we should try to maximize its utility and accessibility.

A lot has changed about how we program computers since The Art of UNIX Programming—last published in 2003—laid out standards and best practices for how command line programs should behave. The command line of the past was machine-first: little more than a REPL on top of a scripting platform. But as general-purpose interpreted languages have flourished, the role of the shell script has shrunk. Today's command line is human-first: a text-based UI that affords access to all kinds of tools, systems and platforms. In the past, the editor was inside the terminal—today, the terminal is just as often a feature of the editor. And there’s been a proliferation of `git`-like multi-tool commands. Commands within commands, and high-level commands that perform entire workflows rather than atomic functions.

Inspired by traditional UNIX philosophy, driven by an interest in encouraging a more delightful and accessible CLI environment, and guided by our experiences as programmers, we decided it was time to revisit the best practices and design principles for building command line programs.

Long live the command line!

## Introduction

This document covers both high-level design philosophy, and concrete guidelines. It’s heavier on the guidelines because our philosophy as practitioners is not to philosophize too much. We believe in learning by example, so we’ve provided plenty of those.

This guide doesn’t cover full-screen terminal programs like emacs and vim. Full-screen programs are niche projects—very few of us will ever be in the position to design one.

This guide is also agnostic about programming languages and tooling in general.

### Who is this guide for?
If you are creating a CLI program and you are looking for principles and concrete best practices for its UI design, this guide is for you.
If you are a professional “CLI UI designer”, that’s amazing - we’d love to learn from you.
If you’d like to avoid obvious missteps of the variety that go against 40 years of CLI design conventions, this guide is for you.
If you want to delight people with your program’s good design and helpful help, this guide is definitely for you.
If you are creating a GUI program, this guide is not for you - though you may learn some GUI anti-patterns if you decide to read it anyway. (Do GUI programmers even read, or do they just look at things?)
If you are designing an immersive, full-screen CLI port of Minecraft, this guide isn’t for you. (But we can’t wait to see it!)

## Philosophy
These are what we consider to be the fundamental principles of good CLI design.
Human-first design
Traditionally, UNIX commands were written under the assumption they were going to be used primarily by other programs. They had more in common with functions in a programming language than with graphical applications.

Today, even though many CLI programs are used primarily (or even exclusively) by humans, a lot of their interaction design still carries the baggage of the past. It’s time to shed some of this baggage: if a command is going to be used primarily by humans, it should be designed for humans first.

### Simple parts that work together
A core tenet of the original UNIX philosophy is the idea that small, simple programs with clean interfaces can be combined to build larger systems. Rather than stuff more and more features into those programs, you make programs that are modular enough to be recombined as needed.

In the old days, pipes and shell scripts played a crucial role in the process of composing programs together. Their role might have diminished with the rise of general-purpose interpreted languages, but they certainly haven’t gone away. What’s more, large-scale automation—in the form of CI/CD, orchestration and configuration management—has flourished. Making programs composable is just as important as ever.

Fortunately, the long-established conventions of the UNIX environment, designed for this exact purpose, still help us today. Standard in/out/err, signals, exit codes and other mechanisms ensure that different programs click together nicely. Plain, line-based text is easy to pipe between commands. JSON, a much more recent invention, affords us more structure when we need it, and lets us more easily integrate command-line tools with the web.

Whatever software you’re building, you can be absolutely certain that people will use it in ways you didn’t anticipate. Your software will become a part in a larger system - your only choice is over whether it will be a well-behaved part.

Most importantly, designing for composability does not need to be at odds with designing for humans first. Much of the advice in this document is about how to achieve both.

Citation: The UNIX philosophy

### Consistency across programs
The terminal’s conventions are hardwired into our fingers. We had to pay an upfront cost by learning about command line syntax, flags, environment variables and so on, but it pays off in long-term efficiency… as long as programs are consistent.

Where possible, a CLI should follow patterns that already exist. That’s what makes CLIs intuitive and guessable; that’s what makes users efficient.

That being said, sometimes consistency conflicts with ease of use. For example, many long-established UNIX commands don't output much information by default, which can cause confusion or worry for people less familiar with the command line.

When following convention would compromise a program’s usability, it might be time to break with it—but such a decision should be made with care.

### Saying (just) enough
The terminal is a world of pure information. You could make an argument that information is the interface—and that, just like with any interface, there’s often too much or too little of it.

A command is saying too little when it hangs for several minutes and the user starts to wonder if it’s broken. A command is saying too much when it dumps pages and pages of debugging output, drowning what’s truly important in an ocean of loose detritus. The end result is the same: a lack of clarity, leaving the user confused and irritated.

It can be very difficult to get this balance right, but it’s absolutely crucial if software is to empower and serve its users.

### Ease of discovery
When it comes to making functionality discoverable, GUIs have the upper hand. Everything you can do is laid out in front of you on the screen, so you can find what you need without having to learn anything, and perhaps even discover things you didn’t know were possible.

It is assumed that command-line interfaces are the opposite of this - that you have to remember how to do everything. The original _Macintosh Human Interface Guidelines_ recommend “See-and-point (instead of remember-and-type)”, as if you could only choose one or the other.

These things needn’t be mutually exclusive. The efficiency of using the command-line comes from remembering commands, but there’s no reason the commands can’t help you learn and remember.

Discoverable CLIs have comprehensive help texts, provide lots of examples, suggest what command to run next, suggest what to do when there is an error. There are lots of ideas that can be stolen from GUIs to make CLIs easier to learn and use, even for power users.

Citation: _The Design of Everyday Things_ (Don Norman), _Macintosh Human Interface Guidelines_

### Conversation as the norm

GUI design, particularly in its early days, made heavy use of metaphor: desktops, files, folders, recycle bins. The ease of implementation of metaphors was one of the huge advantages GUIs wielded over CLIs. Ironically, though, the CLI has embodied an accidental metaphor all along: it’s a conversation.

Beyond the most utterly simple commands, running a program usually involves more than one invocation. Usually, this is because it’s hard to get it right the first time: the user types a command, gets an error, changes the command, gets a different error, and so on, until it works. This mode of learning through repeated failure is like a conversation the user is having with the program.

Trial-and-error isn’t the only type of conversational interaction, though. There are others:

Running one command to set up a tool and then learning what commands to run to actually start using it.
Running several commands to set up an operation, and then a final command to run it (e.g. multiple `git add`s, followed by a `git commit`).
Exploring a system—for example, doing a lot of `cd` and `ls` to get a sense of a directory structure, or `git log` and `git show` to explore the history of a file.
Doing a dry-run of a complex operation before running it for real.

Acknowledging the conversational nature of command-line interaction means you can bring relevant techniques to bear on its design. You can suggest possible corrections when user input is invalid, you can make the intermediate state clear when the user is going through a multi-step process, you can confirm for them that everything looks good before they do something scary.

The user is conversing with your software, whether you intended it or not. At worst, it’s a hostile conversation which makes them feel stupid and resentful. At best, it’s a pleasant exchange that speeds them on their way with newfound knowledge and a feeling of achievement.

Citation: [_The Anti-Mac User Interface_](https://www.nngroup.com/articles/anti-mac-interface/) (Don Gentner and Jakob Nielsen) 

### Robustness
Robustness is both an objective and a subjective property. Software should be robust, of course: unexpected input should be handled gracefully, operations should be idempotent where possible, and so on. But it should also feel robust.

You want your software to feel like it isn’t going to fall apart. You want it to feel immediate and responsive, as if it were a big mechanical machine, not a flimsy plastic “soft switch”.

Subjective robustness requires attention to detail and thinking hard about what can go wrong. It’s lots of little things: keeping the user informed about what’s happening, explaining what common errors mean, not printing scary-looking stack traces.

As a general rule, robustness can also come from keeping it simple. Lots of special cases and complex code tend to make a program fragile.

Citations: The Art Of UNIX Programming

### Empathy
Command-line tools are a programmer’s creative toolkit, so they should be enjoyable to use. This doesn’t mean turning them into a video game, or using lots of emoji (though there’s nothing inherently wrong with emoji). It means giving the user the feeling that you are on their side, that you want them to succeed, that you have thought carefully about their problems and how to solve them.

There’s no list of actions you can take that will ensure they feel this way, although we hope that following our advice will take you some of the way there. Delighting the user means exceeding their expectations at every turn, and that starts with empathy.

### Chaos
The world of the terminal is a mess. Inconsistencies are everywhere, slowing us down and making us second-guess ourselves.

Yet it’s undeniable that this chaos has been a source of power. The terminal, like the UNIX-descended computing environment in general, places very few constraints on what you can build. In that space, all manner of invention has bloomed.

It’s ironic that this document implores you to follow existing patterns, right alongside advice that contradicts decades of command-line tradition. We’re just as guilty of breaking the rules as anyone.

The time might come when you, too, have to break the rules. Do so with intention and clarity of purpose.

> "Abandon a standard when it is demonstrably harmful to productivity or user satisfaction."
— Jeff Raskin, The Humane Interface

## Guidelines

This is a collection of specific things you can do to make your command-line program better.

The first section contains the essential things you need to follow. Get these wrong, and your program will be either hard to use or a bad CLI citizen.

The rest are nice-to-haves. If you have the time and energy to add these things, your program will be a lot better than the average program.

The idea is that, if you don’t want to think too hard about the design of your program, you don’t have to: just follow these rules and your program will probably be good. On the other hand, if you’ve thought about it and determined that a rule is wrong for your program, that’s fine. (There’s no central authority that will reject your program for not following arbitrary rules.)

Also—these rules aren’t written in stone. (See that edit button below?) If you disagree with a general rule for good reason, we hope you’ll propose a change.

### The Basics
There are a few basic rules you need to follow. Get these wrong, and your program will be either very hard to use, or flat-out broken.

#### Use a command-line library where you can.

Either your language’s built-in one, or a good third-party one. They will normally handle arguments, flag parsing, help text, etc, in a sensible way.

Here are some that we like:  
Go: Cobra  
Node: oclif  
Python: Click, Typer  
Ruby: TTY  

** Return zero exit code on success, non-zero on failure.** Exit codes are how scripts determine whether a program succeeded or failed, so you should report this correctly.

#### Send output to `stdout`.
The primary output for your command should go to stdout. Anything that is machine readable should also go to stdout—this is where piping sends things by default.

#### Send messaging to `stderr`.
Log messages, error messages, and so on should all be sent to stderr. This means that when commands are piped together, these messages are displayed to the user and not fed into the next command.

#### Display help text when passed no options, the `-h` flag, or the `--help` flag.
See the [help section](#help) for more advice.



### Help

#### Display a concise help text by default.
If you type `myapp` or `myapp subcommand`, display the help, unless your program is very simple and does something obvious by default. (E.g. `ls`.)

The concise help text should only include:

A description of what your program does.
One or two example invocations.
Descriptions of flags, unless there are lots of them.
An instruction to pass the `--help` flag for more information.

`jq` does this well. When you type `jq`, it displays a short description and an example, then prompts you to pass `jq --help` for the full listing of flags:

```
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

#### Show full help when `-h` and `--help` is passed.
All of these should show help:

```
$ myapp
$ myapp --help
$ myapp help
$ myapp help subcommand
$ myapp -h
$ myapp subcommand --help
$ myapp subcommand -h
```

Ignore any other flags and arguments that are passed -- you should be able to add `-h` to the end of anything and it should show help. Don’t use `-h` for anything else. 


