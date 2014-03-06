[grunt-runner](https://atom.io/packages/grunt-runner) (WIP)
================

Build your project using Grunt from Atom.

![in action!](http://i.imgur.com/a8N7y5S.png)

## How to use

 * Open a project that has a `Gruntfile.js` in the root.
 * Run the default task (`ctrl-alt-shift-g`), or specify your own.
 * The output from the grunt task will be shown in bottom toolbar. Toggle
 the log with `ctrl-alt-t`. You can also toggle the entire toolbar with
 `ctrl-alt-shift-t`.
 * If your task doesn't end automatically (e.g. watches files for changes) you
 can force it stop from the toolbar or by pressing `ctrl-alt-shift-g`.

Some [issues still exist](#known-issues).

## Installation

Install Grunt Runner package using the command line

    apm install grunt-runner

Or install it from the Atom Package Manager.

## Known issues

 * The Gruntfile must be in the root of your project directory to successfully
 get the available tasks. Additionally, all `grunt` commands will be called
 in the root directory.

 * Tasks added to a Gruntfile will not be automatically added until the project
 is reloaded or the page gets refreshed. They will still be callable from from
 the toolbar.
