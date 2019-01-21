### Personal `bashrc`, `bash_aliases` and some shortcuts.

Requires [incron](http://inotify.aiken.cz/?section=incron&page=about&lang=en) to watch for file events.

    sudo apt-get install incron

Helpful incron guide:
    
    https://www.howtoforge.com/tutorial/trigger-commands-on-file-or-directory-changes-with-incron/

Sample incron job

    $HOME/.bash_aliases IN_MODIFY /bin/bash $HOME/dotfiles/backup.sh $@
    $HOME/.bashrc IN_MODIFY /bin/bash $HOME/dotfiles/backup.sh $@

Watched files/directories:

- .bashrc
- .bash_aliases
- .zshrc
- .vimrc
- .... and more

`backup.sh` will be added to a incron job and executed in case watched file(s) are modified.
