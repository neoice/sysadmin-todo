basic TODO application inspired by "Time Management for Sysadmins."

the Perl version is the new, shiny version. the shell script version
is included for historical completion.

**Usage**

1) drop the script somewhere. I "git clone" the whole repo into ~/code.

2) symlink (or copy) somewhere in your $PATH  "todo.pl" to "todo" and "newday".
the script behaves differently if you run it with a different name. (this behavior may be changed/supplemented later)

3) start using your new TODO system!



**ideas/todo**

wrap the management of TODO_PATH in `git`
	possibly use branches/tags for projects?
	detect "abandoned" tasks (items removed without completion)

be able to report statistics (# of $TYPE tasks since $DATE)

report list of $TYPE tasks
