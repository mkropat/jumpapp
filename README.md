# jumpapp

*Jump to another application. Always.*

With **jumpapp**, you can bind a key to switch directly to the window of a particular application.  If there's more than one window, **jumpapp** lets you cycle through them all.  If the application isn't running yet, **jumpapp** is smart enough to start the application for you.

In short, it's probably the fastest way for a keyboard-junkie to switch between applications in a modern desktop environment.  All you have to do is configure the shortcuts you want to use:

![Settings Example](http://i.imgur.com/dAj8NDZ.png "On Ubuntu it's under All Settings → Keyboard → Shortcuts")

If you permit me to wax philosophical, **jumpapp** makes application switching [modeless](https://en.wikipedia.org/wiki/Mode_%28computer_interface%29) — is my application running?  How many times do I have to <kbd>Alt+Tab</kbd> back?  Or do I have to go start it?  All these questions get collapsed into a single key-press.

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
