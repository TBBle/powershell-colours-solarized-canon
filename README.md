# PowerShell Colours: Solarized Canon

This is a pair of scripts that will configure
[PowerShell](https://github.com/PowerShell/PowerShell/) and
[PSReadline](https://github.com/PowerShell/PSReadLine) to
work with a canon [Solarized](https://github.com/altercation/solarized) 16-colour
terminal palette.

## Compatibility

I mainly use PowerShell 7, so I have only lightly/occasionally tested this with Windows
PowerShell.

There's code there to support PSReadLine before 2.0.0, but I haven't tested that code
since updating to 2.0.0.

It is designed to work with [Windows Terminal](https://github.com/microsoft/terminal),
with a canon Solarized colour scheme, either Light or Dark; it overrides the only values
that differ between Light and Dark.

Specifically, it is tested with Windows Terminal 1.2 Preview, but it will work with only
slight, avoidable, issues with cursor colour in Windows Terminal 1.1.

In theory, it ought to work with other terminal emulators, but I haven't tested any. As
long as the terminal emulator is either using ConPTY, or maps the ConHost colours to
ANSI colours the same way that ConPTY does, I expect it to work.

I haven't tested this with PowerShell on platforms other than Windows.

## Usage

To use these scripts, ensure your terminal emulator has the correct colours mapped to
the ANSI codes per Solarized. Note that per [Canon colours VS cmd-colors-solarized](#canon-colours-vs-cmd-colors-solarized), a Windows-based terminal emulator might have
been set up for a brightness-inverted set of ANSI codes.

Specifically, per [Canon Solarized palettes in Windows Terminal](#canon-solarized-palettes-in-windows-terminal), Windows Terminal's built-in Solarized
schemes are incorrect, and need to be overridden.

Then run one of these scripts as part of your profile, e.g., I have the following block
in my [PowerShell Profile](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7):

```PowerShell
# Solarized Light when elevated
# https://serverfault.com/a/97599
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  & (Join-Path -Path (Split-Path -Parent -Path $PROFILE) -ChildPath 'powershell-colours-solarized-canon\Set-SolarizedLightColorDefaultsCanon.ps1')
}
else {
  & (Join-Path -Path (Split-Path -Parent -Path $PROFILE) -ChildPath 'powershell-colours-solarized-canon\Set-SolarizedDarkColorDefaultsCanon.ps1')
}
```

This gives me the effect that if I am running an Administrator PowerShell, I get
Solarized Light, and otherwise I get Solarized Dark.

### Administrator Colours for Bash

You can achieve a similar effect in [MSYS2](https://www.msys2.org/) (but not
[Git Bash](https://gitforwindows.org/)) with the following:

```bash
# Solarized Light when elevated
# If we have the "High Mandatory Level" group, it means we're elevated
# Git4Windows doesn't have `getent`, but you shouldn't be running that elevated anyway.
if [[ -n "$(command -v getent)" ]] && id -G | grep -q "$(getent -w group 'S-1-16-12288' | cut -d: -f2)"
        then echo -e '\e]10;rgb:65/7b/83\e\\\e]11;rgb:fd/f6/e3\e\\\e]12;rgb:00/2b/36\e\'
fi
```

## Canon colours VS cmd-colors-solarized

Historically, using Solarized with Conhost-based programs like PowerShell or CMD
required [cmd-colors-solarized](https://github.com/neilpa/cmd-colors-solarized) which
included a script to configure the Conhost 16-colour palette for Solarized by modifying
the shortcuts to launch tools like PowerShell, paired with scripts that configured
PowerShell, on which these scripts are based.

However, the palette mapping used in cmd-colours-solarized is different from the
mappings given in Solarized itself. All the 'bright' palette entries in Solarized became
'Dark' in cmd-colours-solarized, in effect flipping the 'bold' attribute of the ANSI
code for a given palette entry.

This was not really a problem until recently, when Windows Terminal and related ConPTY
work meant that ANSI colour codes could be expected to do the right thing on both
Windows and non-Windows platforms. Windows Terminal's Solarized colour palette maps the
ANSI codes per Solarized, not cmd-colors-solarized.

The upshot is that using scripts from the cmd-colors-solarized repository under Windows
Terminal, will give you colours where you expect fg/bg tones, and vice-versa. This isn't
visible in PowerShell itself, since Windows Terminal is actually responsible for the
background/foreground/cursor colours; however PS-Readline syntax highlighting and other
line-affecting operations will show the difference.

## Canon Solarized palettes in Windows Terminal

As of Windows Terminal 1.1, the bundled Solarized palettes are actually non-canon, as
they [swap the black and brblack colours](https://github.com/microsoft/terminal/pull/6985)
to better-support users who enable the Solarized palette without the requisite
PowerShell configuration changes.

So to use this configuration, I suggest the following schemes:

```jsonc
  "schemes": [
    {
      "name": "Canon Solarized Dark",
      "foreground": "#839496",
      "background": "#002B36",
      "cursorColor": "#FDF6E3",
      "black": "#073642",
      "red": "#DC322F",
      "green": "#859900",
      "yellow": "#B58900",
      "blue": "#268BD2",
      "purple": "#D33682",
      "cyan": "#2AA198",
      "white": "#EEE8D5",
      "brightBlack": "#002B36",
      "brightRed": "#CB4B16",
      "brightGreen": "#586E75",
      "brightYellow": "#657B83",
      "brightBlue": "#839496",
      "brightPurple": "#6C71C4",
      "brightCyan": "#93A1A1",
      "brightWhite": "#FDF6E3"
    },
    {
      "name": "Canon Solarized Light",
      "foreground": "#657B83",
      "background": "#FDF6E3",
      "cursorColor": "#002B36",
      "black": "#073642",
      "red": "#DC322F",
      "green": "#859900",
      "yellow": "#B58900",
      "blue": "#268BD2",
      "purple": "#D33682",
      "cyan": "#2AA198",
      "white": "#EEE8D5",
      "brightBlack": "#002B36",
      "brightRed": "#CB4B16",
      "brightGreen": "#586E75",
      "brightYellow": "#657B83",
      "brightBlue": "#839496",
      "brightPurple": "#6C71C4",
      "brightCyan": "#93A1A1",
      "brightWhite": "#FDF6E3"
    }
  ],
```

This will ensure that when you use these schemes with, e.g., an ssh session to a Linux
host that is also configured for Solarized, you will get the correct result.

As noted, everything except the `foreground`, `background`, and `cursorColor` are the
same in both schemes. Any tools that support switching between Light and Dark on the
fly will function correctly. So the choice of Light or Dark wil be down to which you
prefer when using applications that don't switch on the fly, e.g., bash.

If using Windows Terminal 1.1, and you want to be able to switch between Light and Dark
dynamically, then you will need to change the `cursorColor` to something that is visible
in both, as the colour-switch ANSI code was unimplemented until Windows Terminal 1.2.
