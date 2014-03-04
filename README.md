[grunt-runner](https://atom.io/packages/grunt-runner) (WIP)
================

Build your project using Grunt from Atom.

![in action!](http://i.imgur.com/a8N7y5S.png)

## How to use

 * Open a project that has a `Gruntfile.js` in the root.
 * Choose a task to run from `Packages->Grunt->Task: your-task`, or press
 `ctrl-alt-g` to run the `default` task.
 * All output from the grunt process can be found in the bottom tool panel. You
 can toggle it with `ctrl-alt-t`.
 * If your task doesn't end automatically (e.g. watches files for changes) you
 can force it stop from the menu or by pressing `ctrl-alt-shift-g`.

Some [issues still exist](#known-issues).

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

## Known issues

 * Grunt Runner currently only supports one open project at a time. If
 multiple projects with Gruntfiles are open then running a task from
 `Packages->Grunt->` menu will have unexpected results.

 * Tasks added to a Gruntfile will not be reflected in the menu until
 the package reloads, this can forced by reopening your project or
 pressing `ctlr-alt-cmd-L`.

 * `.coffee` files are not currently supported.
