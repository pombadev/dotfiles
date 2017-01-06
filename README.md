### Personal `bashrc`, `bash_aliases` and some shortcuts.

Requires [incron](http://inotify.aiken.cz/?section=incron&page=about&lang=en) to watch for file events.

    sudo apt-get install incron

Watched files/directories:

- .bashrc
- .bash_aliases

`backup.sh` will be added to a incron job and executed in case watched file(s) are modified.
