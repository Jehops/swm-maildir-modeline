# `swm-freebsd-zfs-modeline`

Put %m in your StumpWM mode-line format string (*screen-mode-line-format*) to
show the number of new messages in a mailder folder.  You need ssh access to the
remote host with key-based authentication setup.

In addition to the lisp code, there is a small Bourne shell script, ml_mail.sh.
Make sure this script is executable by the user running StumpWM and within the
user's $PATH.  You need to customize the variables at the top to the script.

FAQ

Q: What do I need to put in my ~/.stumpwmrc to get this working?

A: First, make sure the source is in your load-path.  To add it, use something
like
```lisp
    (add-to-load-path "/usr/home/jrm/scm/swm-freebsd-mail-modeline")
```
Next, load the module with
```lisp
    (load-module "swm-freebsd-mail-modeline")
```

Finally create a mode-line format string with %m in it, e.g.,
```lisp
    (setf *screen-mode-line-format* "^[^B^4*%m^]")
```

Q: So, why use a separate script?  Couldn't all the code be contained within the
module?

A: Yes, it could.  I tried doing that with and without threads.  I found StumpWM
became less responsive in both cases.  Don't you prefer a snappy StumpWM?

Q: Will this only run on FreeBSD?

A: By default, yes, but it should be quite simple to modify ml_mail.sh to get it
working on your OS.