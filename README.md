[grunt-runner](https://atom.io/packages/grunt-runner)
================

Build your project using Grunt from Atom.

![in action!](http://i.imgur.com/bqn9QQY.png)

## How to use
 * Set a path to your local `grunt-cli` in the settings
 (may not be necessary).
 * Set the relative path of Gruntfile in the settings
 if the Gruntfile.coffe(js) is NOT in the root directory of your project workspace.
>For Exmaple, if Gruntfile.coffee(or .js) is in your project/workspace/path/build,
then type `build/` here.
 * Open a project that has a `Gruntfile.js` or `Gruntfile.coffee` in the root
 * Open the task list (`ctrl-alt-g`) and choose a task to run, or input a new one.
 * The output from the grunt task will be shown in bottom toolbar. Toggle
 the log with `ctrl-alt-t`, toggle the entire toolbar with
 `ctrl-alt-shift-t`. The toolbar will appear automatically if Grunt Runner was able to find and
 parse a `Gruntfile`, otherwise you can toggle it on yourself.
 * If your task doesn't end automatically (e.g. watches files for changes) you
 can force it stop from the toolbar or by pressing `ctrl-alt-shift-g`.

Some [issues still exist](#known-issues).

## Installation

Install Grunt Runner package using the command line

    apm install grunt-runner

Or install it from the Atom Package Manager.

## Known issues

 * Tasks added to a Gruntfile will not be automatically added until the project
 is reloaded or the page gets refreshed. They will still be callable from from
 the toolbar.

 * Currently hard to add tasks that prefix another task. For example, if you
 have a task in the task list called `develop`, it is impossible to add or call
 a task called `dev`
