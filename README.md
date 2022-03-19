# jumpapp

*A run-or-raise application switcher for any X11 desktop*

[![Build Status](https://travis-ci.org/mkropat/jumpapp.svg?branch=master)](https://travis-ci.org/mkropat/jumpapp)

The idea is simple — bind a key for any given application that will:

- launch the application, if it's not already running, or
- focus the application's most recently opened window, if it is running

Pressing the key again will cycle to the application's next window, if there's more than one.

In short, **jumpapp** is probably the fastest way for a keyboard-junkie to switch between applications in a modern desktop environment.  Once [installed](#installation), all you have to do is configure the key bindings you want to use:

![Settings Example](http://i.imgur.com/dAj8NDZ.png "On Ubuntu it's under All Settings → Keyboard → Shortcuts")

## Synopsis

    Usage: jumpapp [OPTION]... COMMAND [ARG]...

    Jump to (focus) the existing window for an application, if it's running.
    Otherwise, launch COMMAND (with opitonal ARGs) to start the application.

    Options:
      -r -- cycle through windows in reverse order
      -f -- force COMMAND to launch if process found but no windows found
      -m -- if a single window is already open and in focus - minimize it
      -n -- do not fork into background when launching COMMAND
      -p -- always launch COMMAND when ARGs passed
            (see Argument Passthrough in man page)
      -L -- list matching windows for COMMAND and quit
      -t NAME -- process window has to have NAME as the window title
      -c NAME -- find window using NAME as WM_CLASS (instead of COMMAND)
      -i NAME -- find process using NAME as the command name (instead of COMMAND)
      -w -- only find the applications in the current workspace
      -R -- bring the application to the current workspace when raising
            (the default behaviour is to switch to the workspace that the
            application is currently on)
      -C -- center cursor when raising application

## Installation

### Ubuntu, Debian and Friends

    sudo apt-get install build-essential debhelper git pandoc shunit2
    git clone https://github.com/mkropat/jumpapp.git
    cd jumpapp
    make deb
    sudo dpkg -i jumpapp*all.deb
    # if there were missing dependencies
    sudo apt-get install -f

### Fedora and Friends

    git clone https://github.com/mkropat/jumpapp.git
    cd jumpapp
    make rpm
    sudo yum localinstall jumpapp*.noarch.rpm
    
### Arch linux and Friends
    yaourt -S aur/jumpapp-git

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
[**wmctrl**](http://tripie.sweb.cz/utils/wmctrl/). You must have it installed to
use **jumpapp**.

**jumpapp** was built for the GNOME desktop environment. There's a good chance
though that it'll work on [any window manager supported by
**wmctrl**](http://tripie.sweb.cz/utils/wmctrl/#about).

## XBindKeys

If your desktop environment doesn't offer a way to bind keys to commands — or if it's too limited — take a look at [XBindKeys](http://www.nongnu.org/xbindkeys/xbindkeys.html).

Example `.xbindkeysrc`:

    "jumpapp chromium"
      control + alt + c

    "jumpapp -r chromium"
      shift + control + alt + c

    "jumpapp firefox"
      control + alt + f

    "jumpapp -r firefox"
      shift + control + alt + f

    "jumpapp gnome-terminal"
      control + alt + t

    "jumpapp -r gnome-terminal"
      shift + control + alt + t

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

## Continue On Your Path To Keyboard Nirvana

- [Blazing-Fast Application Switching in Linux](https://vickychijwani.me/blazing-fast-application-switching-in-linux/) — a blog post that talks about the advantages of this style of application switching
- [Saka Key](https://key.saka.io/docs/about/introduction) / [Tridactyl](https://github.com/tridactyl/tridactyl) — navigate the web with your keyboard
- [Vim](https://www.vim.org/) / [Neovim](https://neovim.io/) — the granddaddy of keyboard driven programs

## Uninstall jumpapp

### Ubuntu, Debian and Friends
    sudo apt remove jumpapp
