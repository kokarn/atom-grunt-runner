grunt-runner (WIP)
================

Build your project using Grunt from Atom.

Grunt Runner looks for a Gruntfile in your projects root, if it successfully
finds one it will fill the `Packages->Grunt->` menu with all possible tasks.
If an error occurs while grunt runs, the output will appear in the Dev tools
console.

Some [issues still exist](#issues).

![in action!](http://i.imgur.com/QuDJmU0.png)

## Installation

#### For Use
Install Grunt Runner package using the command line

    apm install grunt-runner

Or install it from the Atom Package Manager.

#### For Development
If you want to make changes to this project. Install the package using

    apm develop grunt-runner

Then open Atom in developer mode (Atom command tools must be installed)

    cd path/to/package
    atom --dev

<a href="issues"></a>
## Known issues

 * Grunt Runner currently only supports one open project at a time. If
 multiple projects with Gruntfiles are open then running a task from
 `Packages->Grunt->` menu will have unexpected results.

 * Tasks added to a Gruntfile will not be reflected in the menu until
 the package reloads, this can forced by reopening your project or
 pressing `ctlr-alt-cmd-L`.

 * `.coffee` files are not currently supported.
