# jumpapp

*Jump to another application. Always.*

**jumpapp** focuses the window of the application you're interested in —
assuming it's already running — otherwise **jumpapp** launches the application
for you.

It the application is running and one of its windows is already focused,
**jumpapp** will switch to the application's next window, if there is more than
one. Running **jumpapp** multiple times for a given COMMAND will cycle you
through all of the application's windows.

## Synopsis

    Usage: jumpapp [OPTION]... COMMAND [ARG]...

    Jump to (focus) the first open window for an application, if it's running.
    Otherwise, launch COMMAND (with opitonal ARGs) to start the application.

    Options:
      -f -- force COMMAND to launch if process found but no windows found
      -n -- do not fork into background when launching COMMAND
      -r -- cycle through windows in reverse order
      -p -- always launch COMMAND when ARGs passed
            (see Argument Passthrough in man page)
      -c NAME -- find window using NAME as WM_CLASS (instead of COMMAND)
      -i NAME -- find process using NAME as the command name (instead of COMMAND)

## Installation

### Ubuntu and Linux Mint

    sudo add-apt-repository ppa:mkropat/ppa
    sudo apt-get update
    sudo apt-get install jumpapp

### Debian and Friends

    git clone https://github.com/mkropat/jumpapp.git
    cd jumpapp
    make deb
    sudo dpkg -i jumpapp*all.deb
    sudo apt-get install -f	# if there were missing dependencies

### Fedora and Friends

    git clone https://github.com/mkropat/jumpapp.git
    cd jumpapp
    make rpm
    sudo yum localinstall jumpapp*.noarch.rpm

### From Source

    git clone https://github.com/mkropat/jumpapp.git
    cd jumpapp
    make && sudo make install

## Argument Passthrough (`-p` option)

Many applications keep track of what windows they have open so that if you run
the command again, it will interact with the existing application window
instead of launching a new instance of the application.

Take Firefox, for example. If you already have a Firefox window open and you
run `firefox https://github.com/`, Firefox won't start a new instance. What it
does is open a new tab in the existing window and browse to the URL you passed.

[Especially in the case of Desktop Entry files](#jumpappify-desktop-entry1), we
want to preserve this behavior. With `jumpapp -p COMMAND [ARGs]...`, when you
include one or more ARGs, COMMAND is always executed in order to pass the ARGs
to the running application. But if no ARGs are included, **jumpapp** will
behave normally.

## A Wrapper Around wmctrl(1)

All the heavy lifting is done by Tomáš Stýblo's powerful
[**wmctrl**](http://tomas.styblo.name/wmctrl/). You must have it installed to
use **jumpapp**.

**jumpapp** was built for the GNOME desktop environment. There's a good chance
though that it'll work on [any window manager supported by
**wmctrl**](http://tomas.styblo.name/wmctrl/#about).

## jumpappify-desktop-entry(1)

**jumpapp** ships with a helper utility:

    Usage: jumpappify-desktop-entry SOMEFILE.desktop

    Given a desktop entry file (*.desktop), output a new desktop entry file that
    wraps the application's `Exec` in a call to jumpapp(1).

    EXAMPLES

        jumpappify-desktop-entry /usr/share/applications/chromium-browser.desktop \
            > ~/.local/share/applications/chromium-browser.desktop

    Or convert multiple in one go:

        for entry in /usr/share/applications/{firefox,gnome-terminal}.desktop; do
            target=~/".local/share/applications/$(basename "$entry")"
            jumpappify-desktop-entry "$entry" >"$target"
        done
