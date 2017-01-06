### Personal `bashrc`, `bash_aliases` and some shortcuts.

Requires [incron](http://inotify.aiken.cz/?section=incron&page=about&lang=en) to watch for file events.

    sudo apt-get install incron

Helpful incron guide:
    
    https://www.howtoforge.com/tutorial/trigger-commands-on-file-or-directory-changes-with-incron/

Sample incron job

    /home/pomba/.bash_aliases IN_MODIFY /bin/bash /home/pomba/Documents/backups/backup.sh $@
    /home/pomba/.bashrc IN_MODIFY /bin/bash /home/pomba/Documents/backups/backup.sh $@

Watched files/directories:

- .bashrc
- .bash_aliases

`backup.sh` will be added to a incron job and executed in case watched file(s) are modified.
