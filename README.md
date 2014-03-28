# jumpapp

*Jump to another application. Always.*

**jumpapp** focuses the window of the application you're interested in —
assuming it's already running — otherwise **jumpapp** launches the application
for you.

## Synopsis

    Usage: jumpapp [OPTION]... COMMAND [ARG]...

    Jump to (focus) the first open window for an application, if it's running.
    Otherwise, launch COMMAND (with opitonal ARGs) to start the application.

    Options:
      -c NAME -- find window using NAME as WM_CLASS (instead of COMMAND)
      -f      -- force COMMAND to launch if process found but no windows found
      -i NAME -- find process using NAME as the command name (instead of COMMAND)
      -n      -- do not fork into background when launching COMMAND

## Installation

### Ubuntu, Mint, Debian and Friends

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
    sudo make install

## A Wrapper Around wmctrl(1)

All the heavy lifting is done by Tomáš Stýblo's powerful
[**wmctrl**](http://tomas.styblo.name/wmctrl/). You must have it installed to
use **jumpapp**.

**jumpapp** was built for the GNOME desktop environment. There's a good chance
though that it'll work on [any window manager supported by
**wmctrl**](http://tomas.styblo.name/wmctrl/#about).

## jumpify-desktop-entry(1)

**jumpapp** ships with a helper utility:

    Usage: jumpify-desktop-entry SOMEFILE.desktop

    Given a desktop entry file (*.desktop), output a new desktop entry file that
    wraps the application's `Exec` in a call to jumpapp(1).

    EXAMPLES

        jumpify-desktop-entry /usr/share/applications/chromium-browser.desktop \
            > ~/.local/share/applications/chromium-browser.desktop

    Or convert multiple in one go:

        for entry in /usr/share/applications/{firefox,gnome-terminal}.desktop; do
            target=~/".local/share/applications/$(basename "$entry")"
            jumpify-desktop-entry "$entry" >"$target"
        done

## Feature Ideas

### Cycle Through Application Windows

When invoked, if the specified application is already the focused window, try
switching to the next window of the same application.
