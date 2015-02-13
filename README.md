[grunt-runner](https://atom.io/packages/grunt-runner)
================

Build your project using Grunt from Atom.

![in action!](http://i.imgur.com/bqn9QQY.png)

## How to use
 1. Open a project with a Gruntfile in the project root.
 2. Open the task list (`ctrl-alt-g`) and choose a task to run, or input a new one.
 3. The output from the grunt task will be shown in bottom toolbar. Toggle
 the log with `ctrl-alt-t`, toggle the entire toolbar with
 `ctrl-alt-shift-t`. The toolbar will appear automatically if Grunt Runner was able to find and
 parse a `Gruntfile`, otherwise you can toggle it on yourself.
 4. If your task doesn't end automatically (e.g. watches files for changes) you
 can force it stop from the toolbar or by pressing `ctrl-alt-shift-g`.

 ## Notes
 1. By default this package will try to use the the grunt module in your `[projectDir]/node_modules`
 directory. If for some reason that doesn't work, you can choose a path to look for the grunt module
 in by going to the settings. (e.g. `/usr/bin` or `~/path-to-global/node_modules`)
