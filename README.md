Background
----------

Pulsar (Puppet Unix Lockdown Security Analysis Report) was developed with the
goal of having a tool that could report on and lockdown a Unix machine according
to a security baseline. It is based on CIS and other frameworks. It is also based
on an earlier security audit script I wrote which ran as a shell script (lunar).

It was developed with puppet in mind as a lot of the customers I deal with use
Puppet as a configuration management tool. As I also wanted and need an audit
tool I could run from the command lime (much like lunar), it differs a little
from a standard Puppet module in that it can produce a report without making
changes (much like a Puppet noop run, except that a audit report is generated).

In order to use Puppet as an audit/report custom facts have been created to
determine the current configuration and report whether those configurations
meet the recommended configuration. As the various tests included in the report
come with included documentation a wrapper script has been included which runs
Puppet and cleans up the output so that it is suitable for auditing/reporting
purposes.

This was also driven out of a desire to create abstracted Puppet classes that
were easier and faster to use than the standard ones. Although Puppet has the
obvious benefit of being a commonly used configuration framework, in a lot of
cases I find it far less overhead, system and time wise, to use other tools.
Having said this there are things I like about Puppet, including the change in
approach to IT delivery processes and thinking it has inspired by its wide
adoptance.

License
-------

This software is licensed as CC-BA (Creative Commons By Attrbution)

http://creativecommons.org/licenses/by/4.0/legalcode

Features
--------

- Based on CIS and other security frameworks
- Support for Mac OS X
  - 10.6 or later
- Support for Linux
  - Centos, RHEL, Debian, Ubuntu
- Support for Solaris
  - 2.6 to 11
- Support for AIX
  - 4.x to 6.x
  - Not finished
  - Requires testing
- Includes reporting and lockdown modes
  - Reporting is working well
  - Lockdown needs more testing
  - Recommed using for reporting only until I remove this note
- Includes a wrapper script to run puppet and exclude debug/unwanted output
- Includes a script to create symlink based facts required for operation
- Includes a number of wrapper classes that make coding/using Puppet quicker and easier
- Includes abstracted classes where keywords can be used rather than files speeding up development

Status
------

- Reporting has been reasonably well tested on Mac OS X, Linux and Solaris
  - AIX support is not completed
  - Testing is required on AIX and FreeBSD
- Lockdown testing is in progress
  - Recommed using for reporting only until I remove this note
  - As part of the lockdown mode I hope to have a backup function like I implemented with lunar
- Components nearing completion
  - Xinetd service support
  - Improved file editing module
    - Supports configuration files with stanzas, e.g. [Server]
- Things to add
  - A scoring system like lunar
  - PDF output for report


Documentation
-------------

[Introduction](https://github.com/lateralblast/pulsar/wiki/1.-Introduction)
[Installation](https://github.com/lateralblast/pulsar/wiki/2.-Installation)
[Usage](https://github.com/lateralblast/pulsar/wiki/3.-Usage)
[Examples](https://github.com/lateralblast/pulsar/wiki/4.-Examples)
- [OSX](https://github.com/lateralblast/pulsar/wiki/4.1.-OSX)
- [Linux](https://github.com/lateralblast/pulsar/wiki/4.2.-Linux)
- [Solaris](https://github.com/lateralblast/pulsar/wiki/4.3.-Solaris)
- [AIX](https://github.com/lateralblast/pulsar/wiki/4.4.-AIX)
[Challenges](https://github.com/lateralblast/pulsar/wiki/5.-Challenges)

Examples
--------

Run report for User related tests:

```
$ report/pulsar.rb -r -m user
Notice: Compiled catalog for Red70vm01 in environment production in 22.24 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Auditing user system (pulsar::user::system)
Notice: Secure:  No users with invalid shells
Notice: Auditing user dotfiles (pulsar::user::dotfiles)
Notice: Secure:  No readabledot files need to be fixed
Notice: Auditing user duplicate (pulsar::user::duplicate)
Notice: Secure:  No duplicate uids found
Notice: Secure:  No duplicate users found
Notice: Auditing user netrc (pulsar::user::netrc)
Notice: Secure:  No netrc files need to be fixed
Notice: Auditing user old (pulsar::user::old)
Notice: Secure:  No old inactive user accounts exist
Notice: Auditing user path (pulsar::user::path)
Notice: Secure:  No empty directories in PATH
Notice: Auditing user reserved (pulsar::user::reserved)
Notice: Auditing user rhosts (pulsar::user::rhosts)
Notice: Secure:  No rhost files need to be fixed
Notice: Auditing user super (pulsar::user::super)
Notice: Secure:  No users with invalid ids
Notice: Finishing pulsar run
```

Run reports for Accounting related tests:

```
$ pulsar.rb -r -m accounting
Notice: Compiled catalog for Red70vm01 in environment production in 23.24 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Secure:  Package sysstat is installed
Notice: Auditing accounting system (pulsar::accounting::system)
Notice: Secure:  Package audit is installed
Notice: Warning: File "/etc/audit/audit.rules" does not contain "-f 1"
Notice: Warning: File "/etc/audit/audit.rules" does not contain "-w /var/log/sudo.log -p wa -k actions"
Notice: Warning: Line "-a always,exit -F arch=b64 -S clock_settime -k time-change" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S clock_settime -k time-change" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
Notice: Warning: Service "sysstat" is not enabled
Notice: Fix:     /usr/bin/sudo /sbin/chkconfig sysstat on
Notice: Warning: Line "max_log_file = MB" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "max_log_file = MB" >> /etc/audit/audit.rules
Notice: Warning: Line "-a exit,always -F arch=b64 -S sethostname -S setdomainname -k system-locale" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a exit,always -F arch=b64 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/audit.rules
Notice: Warning: Line "admin_space_left_action = email" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "admin_space_left_action = email" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k export" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k export" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/hosts -p wa -k system-locale" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/hosts -p wa -k system-locale" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/sudoers -p wa -k scope" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/sudoers -p wa -k scope" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
Notice: Warning: Service "auditd" is not enabled
Notice: Fix:     /usr/bin/sudo /sbin/chkconfig auditd on
Notice: Warning: Line "-w /sbin/insmod -p x -k modules" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /sbin/insmod -p x -k modules" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/sysconfig/network -p wa -k system-locale" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/sysconfig/network -p wa -k system-locale" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /var/log/lastlog -p wa -k logins" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /var/log/lastlog -p wa -k logins" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /sbin/rmmod -p x -k modules" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /sbin/rmmod -p x -k modules" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
Notice: Warning: Line "-a exit,always -F arch=b32 -S sethostname -S setdomainname -k system-locale" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a exit,always -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /var/run/utmp -p wa -k session" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /var/run/utmp -p wa -k session" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/localtime -p wa -k time-change" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/security/opasswd -p wa -k identity" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/security/opasswd -p wa -k identity" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/issue -p wa -k system-locale" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/issue -p wa -k system-locale" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/group -p wa -k identity" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/group -p wa -k identity" >> /etc/audit/audit.rules
Notice: Warning: Line "max_log_file_action = keep_logs" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "max_log_file_action = keep_logs" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /var/log/faillog -p wa -k logins" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /var/log/faillog -p wa -k logins" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/shadow -p wa -k identity" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/shadow -p wa -k identity" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/issue.net -p wa -k system-locale" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/issue.net -p wa -k system-locale" >> /etc/audit/audit.rules
Notice: Warning: Line "action_mail_acct = email" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "action_mail_acct = email" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/selinux/ -p wa -k MAC-policy" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/selinux/ -p wa -k MAC-policy" >> /etc/audit/audit.rules
Notice: Warning: Line "space_left_action = email" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "space_left_action = email" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -S stime -k time-change" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /var/log/wtmp -p wa -k session" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /var/log/wtmp -p wa -k session" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /etc/passwd -p wa -k identity" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/passwd -p wa -k identity" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /sbin/modprobe -p x -k modules" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /sbin/modprobe -p x -k modules" >> /etc/audit/audit.rules
Notice: Warning: Line "-w /var/log/btmp -p wa -k session" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /var/log/btmp -p wa -k session" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b32 -S clock_settime -k time-change" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
Notice: Warning: Line "-a always,exit -S init_module -S delete_module -k modules" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-a always,exit -S init_module -S delete_module -k modules" >> /etc/audit/audit.rules
Notice: Finishing pulsar run
Notice: Warning: Line "-w /etc/gshadow -p wa -k identity" in "/etc/audit/audit.rules" is not present (Currently "")
Notice: Fix:     echo "-w /etc/gshadow -p wa -k identity" >> /etc/audit/audit.rules
Notice: Warning: File "/etc/audit/audit.rules" does not contain "-e 2"
Notice: Finished catalog run in 14.72 seconds
```

Run reports for File related tests:

```
$ report/pulsar -r -m file
Notice: Compiled catalog for Red70vm01 in environment production in 24.17 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Auditing file forward (pulsar::file::forward)
Notice: Secure:  No forward files need to be fixed
Notice: Auditing file logs (pulsar::file::logs)
Notice: Finishing pulsar run
Notice: Warning: File permissions for "/var/log/samba" are not correct (Currently: Mode=0700,Owner=root,Group=root)
Notice: Fix:     touch 0600 "/var/log/samba" ; chown root:root "/var/log/samba"
Notice: Warning: File "/var/log/pkgs" does not exist
Notice: Fix:     touch "/var/log/pkgs" chmod 0600 "/var/log/pkgs" ; chown root:root "/var/log/pkgs"
Notice: Warning: File "/var/log/rpm" does not exist
Notice: Fix:     touch "/var/log/rpm" chmod 0600 "/var/log/rpm" ; chown root:root "/var/log/rpm"
Notice: Warning: File permissions for "/var/log/dmesg" are not correct (Currently: Mode=0644,Owner=root,Group=root)
Notice: Fix:     touch 0600 "/var/log/dmesg" ; chown root:root "/var/log/dmesg"
Notice: Warning: File "/var/log/news" does not exist
Notice: Fix:     touch "/var/log/news" chmod 0600 "/var/log/news" ; chown root:root "/var/log/news"
Notice: Warning: File permissions for "/var/log/sa" are not correct (Currently: Mode=0755,Owner=root,Group=root)
Notice: Fix:     touch 0600 "/var/log/sa" ; chown root:root "/var/log/sa"
Notice: Warning: File permissions for "/var/log/lastlog" are not correct (Currently: Mode=0644,Owner=root,Group=root)
Notice: Fix:     touch 0600 "/var/log/lastlog" ; chown root:root "/var/log/lastlog"
Notice: Warning: File "/var/log/mailman" does not exist
Notice: Fix:     touch "/var/log/mailman" chmod 0600 "/var/log/mailman" ; chown root:root "/var/log/mailman"
Notice: Secure:  File permissions for "/var/log/maillog" are correct (Mode=0600,Owner=root,Group=root)
Notice: Warning: File "/var/log/ksyms" does not exist
Notice: Fix:     touch "/var/log/ksyms" chmod 0600 "/var/log/ksyms" ; chown root:root "/var/log/ksyms"
Notice: Warning: File permissions for "/var/log/cron" are not correct (Currently: Mode=0644,Owner=root,Group=root)
Notice: Fix:     touch 0600 "/var/log/cron" ; chown root:root "/var/log/cron"
Notice: Warning: File "/var/log/scrollkeeper.log" does not exist
Notice: Fix:     touch "/var/log/scrollkeeper.log" chmod 0600 "/var/log/scrollkeeper.log" ; chown root:root "/var/log/scrollkeeper.log"
Notice: Secure:  File permissions for "/var/log/messages" are correct (Mode=0600,Owner=root,Group=root)
Notice: Warning: File "/var/log/pgsql" does not exist
Notice: Fix:     touch "/var/log/pgsql" chmod 0600 "/var/log/pgsql" ; chown root:root "/var/log/pgsql"
Notice: Warning: File permissions for "/var/log/boot.log" are not correct (Currently: Mode=0644,Owner=root,Group=root)
Notice: Fix:     touch 0600 "/var/log/boot.log" ; chown root:root "/var/log/boot.log"
Notice: Warning: File "/var/log/btml" does not exist
Notice: Fix:     touch "/var/log/btml" chmod 0600 "/var/log/btml" ; chown root:root "/var/log/btml"
Notice: Warning: File "/var/log/httpd" does not exist
Notice: Fix:     touch "/var/log/httpd" chmod 0600 "/var/log/httpd" ; chown root:root "/var/log/httpd"
Notice: Auditing file rhosts (pulsar::file::rhosts)
Notice: Secure:  No shosts files need to be fixed
Notice: Secure:  No hostequiv files need to be fixed
Notice: Secure:  No rhosts files need to be fixed
Notice: Auditing file stickybit (pulsar::file::stickybit)
Notice: Secure:  No stickybit files need to be fixed
Notice: Finished catalog run in 10.18 seconds
```

Run reports for Firewall related tests:

```
$ report/pulsar.rb -r -m firewall
Notice: Compiled catalog for Red70vm01 in environment production in 18.66 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Finishing pulsar run
Notice: Auditing firewall iptables (pulsar::firewall::iptables)
Notice: Warning: Service "iptables" is not enabled
Notice: Fix:     /usr/bin/sudo /sbin/chkconfig iptables on
Notice: Warning: Service "ip6tables" is not enabled
Notice: Fix:     /usr/bin/sudo /sbin/chkconfig ip6tables on
Notice: Auditing firewall tcpwrappers (pulsar::firewall::tcpwrappers)
Notice: Secure:  Package tcp_wrappers is installed
Notice: Warning: File "/etc/hosts.allow" does not exist
Notice: Fix:     touch "/etc/hosts.allow" chmod 0644 "/etc/hosts.allow" ; chown root: "/etc/hosts.allow"
Notice: Warning: File "/etc/hosts.deny" does not exist
Notice: Fix:     touch "/etc/hosts.deny" chmod 0644 "/etc/hosts.deny" ; chown root: "/etc/hosts.deny"
Notice: Warning: File "/etc/hosts.allow" does not contain "ALL: 127.0.0.1"
Notice: Warning: File "/etc/hosts.allow" does not contain "ALL: localhost"
Notice: Warning: File "/etc/hosts.deny" does not contain "ALL: ALL"
Notice: Finished catalog run in 9.62 seconds
```

Run reports for Filesystem releated tests:

```
$ report/pulsar.rb -r -m fs
Notice: Compiled catalog for Red70vm01 in environment production in 30.99 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Finishing pulsar run
Notice: Auditing fs autofs (pulsar::fs::autofs)
Notice: Secure:  Service "autofs" is disabled
Notice: Auditing fs home owner (pulsar::fs::home::owner)
Notice: Secure:  No home directories with incorrect ownership
Notice: Secure:  No users have invalid home directories
Notice: Auditing fs home perms (pulsar::fs::home::perms)
Notice: Secure:  No home directories with invalid permissions
Notice: Auditing fs mount fdi (pulsar::fs::mount::fdi)
Notice: Auditing fs mount nodev (pulsar::fs::mount::nodev)
Notice: Secure:  File permissions for "/etc/fstab" are correct (Mode=0644,Owner=root,Group=root)
Notice: Auditing fs mount noexec (pulsar::fs::mount::noexec)
Notice: Auditing fs mount setuid (pulsar::fs::mount::setuid)
Notice: Auditing fs partition (pulsar::fs::partition)
Notice: Warning: Filesystem "/home" is not mounted on a separate partition
Notice: Warning: Filesystem "/var" is not mounted on a separate partition
Notice: Secure:  Filesystem "/" is mounted on a separate partition
Notice: Warning: Filesystem "/tmp" is not mounted on a separate partition
Notice: Warning: Filesystem "/var/log" is not mounted on a separate partition
Notice: Finished catalog run in 5.13 seconds
```

Run reports for Group related tests:

```
$ report/pulsar.rb -r -m group
Notice: Compiled catalog for Red70vm01 in environment production in 25.21 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Finishing pulsar run
Notice: Auditing group duplicate (pulsar::group::duplicate)
Notice: Secure:  No duplicate groups found
Notice: Secure:  No duplicate gids found
Notice: Auditing group exist (pulsar::group::exist)
Notice: Secure:  No unused gids
Notice: Secure:  No unused groups
Notice: Auditing group root (pulsar::group::root)
Notice: Secure:  Primary GID for user root is correctly set to 0
Notice: Auditing group shadow (pulsar::group::shadow)
Notice: Secure:  Shadow group does not contain members
Notice: Finished catalog run in 5.09 seconds
```

Run reports for Kernel related tests:

```
$ report/pulsar.rb -r -m kernel
Notice: Compiled catalog for Red70vm01 in environment production in 31.70 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Finishing pulsar run
Notice: Auditing kernel modprobe (pulsar::kernel::modprobe)
Notice: Warning: File "/etc/modprobe.conf" does not contain "install dccp /bin/true"
Notice: Warning: File "/etc/modprobe.conf" does not contain "install tipc /bin/true"
Notice: Warning: File "/etc/modprobe.conf" does not contain "install sctp /bin/true"
Notice: Warning: File "/etc/modprobe.conf" does not contain "install rds /bin/true"
Notice: Auditing kernel sysctl (pulsar::kernel::sysctl)
Notice: Warning: Parameter "net.ipv4.icmp_echo_ignore_broadcasts" in file "/etc/sysctl.conf" is not correctly set to "1" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.default.rp_filter" in file "/etc/sysctl.conf" is not correctly set to "1" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.all.secure_redirects" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv6.conf.default.accept_ra" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.tcp_max_syn_backlog" in file "/etc/sysctl.conf" is not correctly set to "4096" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.default.send_redirects" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.default.accept_redirects" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.default.secure_redirects" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.all.accept_redirects" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.ip_forward" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.icmp_ignore_bogus_error_responses" in file "/etc/sysctl.conf" is not correctly set to "1" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv6.conf.all.accept_ra" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "fs.suid.dumpable" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv6.conf.default.accept_redirects" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.tcp_syncookies" in file "/etc/sysctl.conf" is not correctly set to "1" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.all.log_martians" in file "/etc/sysctl.conf" is not correctly set to "1" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.all.rp_filter" in file "/etc/sysctl.conf" is not correctly set to "1" (Currently it is set to "")
Notice: Warning: Parameter "kernel.exec-shield" in file "/etc/sysctl.conf" is not correctly set to "1" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.tcp_max_orphans" in file "/etc/sysctl.conf" is not correctly set to "256" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.all.send_redirects" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.default.accept_source_route" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv6.route.flush" in file "/etc/sysctl.conf" is not correctly set to "1" (Currently it is set to "")
Notice: Warning: Parameter "net.ipv4.conf.all.accept_source_route" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Warning: Parameter "kernel.randomize_va_space" in file "/etc/sysctl.conf" is not correctly set to "1" (Currently it is set to "")
Notice: Finished catalog run in 6.45 seconds
```

Run reports for Login related tests:

```
$ report/pulsar.rb -r -m login
Notice: Compiled catalog for Red70vm01 in environment production in 28.28 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Finishing pulsar run
Notice: Auditing login console (pulsar::login::console)
Notice: Secure:  No TTYs in /etc/securetty
Notice: Auditing login serial (pulsar::login::serial)
Notice: Secure:  Init entry getty is off
Notice: Auditing login su (pulsar::login::su)
Notice: Warning: Single user mode does not require authentication
Notice: Finished catalog run in 4.80 seconds
```

Run reports for Logout related tests:

```
$ report/pulsar.rb -r -m logout
Notice: Compiled catalog for Red70vm01 in environment production in 25.90 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Finishing pulsar run
Notice: Finished catalog run in 6.87 seconds
```

Run reports for Operating Sytem related tests:

```
$ report/pulsar.rb -r -m os
Notice: Compiled catalog for Red70vm01 in environment production in 27.58 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Finishing pulsar run
Notice: Auditing os core dump (pulsar::os::core::dump)
Notice: Warning: File "/etc/security/limits.conf" does not contain "* hard core 0"
Notice: Warning: Parameter "fs.suid_dumpable" in file "/etc/sysctl.conf" is not correctly set to "0" (Currently it is set to "")
Notice: Secure:  Service "kdump" is disabled
Notice: Auditing os mesgn (pulsar::os::mesgn)
Notice: Warning: File "" does not contain "mesg n"
Notice: Auditing os shells (pulsar::os::shells)
Notice: Secure:  No invalid shells in /etc/shells
Notice: Finished catalog run in 4.10 seconds
```

Run reports for Password related tests:

```
$ report/pulsar.rb -r -m os
Notice: Compiled catalog for Red70vm01 in environment production in 27.59 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Finishing pulsar run
Notice: Auditing password expiry (pulsar::password::expiry)
Notice: Warning: Parameter "PASS_WARN_AGE" in file "/etc/login.conf" is not correctly set to "14" (Currently it is set to "")
Notice: Warning: Parameter "PASS_MIN_LEN" in file "/etc/login.conf" is not correctly set to "9" (Currently it is set to "")
Notice: Warning: Parameter "PASS_MAX_DAYS" in file "/etc/login.conf" is not correctly set to "90" (Currently it is set to "")
Notice: Warning: Parameter "PASS_MIN_DAYS" in file "/etc/login.conf" is not correctly set to "7" (Currently it is set to "")
Notice: Auditing password fields (pulsar::password::fields)
Notice: Secure:  No empty password fields found
Notice: Auditing password perms (pulsar::password::perms)
Notice: Secure:  File/Directory permissions for "/etc/gshadow" are correct (Mode=0000,Owner=root,Group=root)
Notice: Secure:  File/Directory permissions for "/etc/shadow" are correct (Mode=0000,Owner=root,Group=root)
Notice: Secure:  File/Directory permissions for "/etc/passwd" are correct (Mode=0644,Owner=root,Group=root)
Notice: Secure:  File/Directory permissions for "/etc/group" are correct (Mode=0644,Owner=root,Group=root)
Notice: Finished catalog run in 5.08 seconds
```

Run reports for Security related tests:

```
$ report/pulsar.rb -r -m security
Notice: Compiled catalog for Red70vm01 in environment production in 30.60 seconds
Notice: Initialising pulsar (init.pp)
Notice: Running in report mode
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::linux)
Notice: Finishing pulsar run
Notice: Warning: Package aide is not installed
Notice: Fix:     yum install aide
Notice: Auditing security aide (pulsar::security::aide)
Notice: Warning: Crontab entry for user "aide" does not contain "0 5 * * * /usr/sbin/aide --check"
Notice: Fix:     echo "0 5 * * * /usr/sbin/aide --check" >> "/etc/cron.daily/aide"
Notice: Auditing security banner (pulsar::security::banner)
Notice: Warning: File/Directory "/etc/issue" does not exist
Notice: Fix:     touch/mkdir "/etc/issue" chmod 0644 "/etc/issue" ; chown root:root "/etc/issue"
Notice: Warning: File/Directory "/etc/motd" does not exist
Notice: Fix:     touch/mkdir "/etc/motd" chmod 0644 "/etc/motd" ; chown root:root "/etc/motd"
Notice: Auditing security memory (pulsar::security::memory)
Notice: Warning: Parameter "kernel.randomize_va_space" in "/etc/sysctl.conf" is not set to "2" (Currently "")
Notice: Fix:     echo "kernel.randomize_va_space = 2" >> "/etc/sysctl.conf"
Notice: Auditing security daemon umask (pulsar::security::daemon::umask)
Notice: Secure:  File permissions for "/etc/sysconfig/init" are correct (Mode=0644,Owner=root,Group=root)
Notice: Warning: Parameter "umask" in file "/etc/sysconfig/init" is not correctly set to "027" (Currently it is set to "")
Notice: Fix:     echo "umask=027" >> /etc/sysconfig/init
Notice: Auditing security daemon unconfined (pulsar::security::daemon::unconfined)
Notice: Secure:  No unconfined daemons
Notice: Auditing security execshield (pulsar::security::execshield)
Notice: Auditing security grub (pulsar::security::grub)
Notice: Warning: Grub password not set
Notice: Warning: File/Directory "/etc/grub.conf" does not exist
Notice: Fix:     touch/mkdir "/etc/grub.conf" chmod 0600 "/etc/grub.conf" ; chown root:root "/etc/grub.conf"
Notice: Auditing security ipv6 (pulsar::security::ipv6)
Notice: Warning: Parameter "IPV6INIT" in file "/etc/sysconfig/network" is not correctly set to "no" (Currently it is set to "")
Notice: Fix:     echo "IPV6INIT=no" >> /etc/sysconfig/network
Notice: Warning: Parameter "NETWORKING_IPV6" in file "/etc/sysconfig/network" is not correctly set to "no" (Currently it is set to "")
Notice: Fix:     echo "NETWORKING_IPV6=no" >> /etc/sysconfig/network
Notice: Auditing security issue (pulsar::security::issue)
Notice: Warning: File "/etc/issue" does not contain a security banner
Notice: Auditing security rsa (pulsar::security::rsa)
Notice: Auditing Linux (RedHatEnterpriseServer) (pulsar::security::selinux)
Notice: Secure:  Parameter "SELINUXTYPE" in file "/etc/selinux/config" is correctly set to "targeted"
Notice: Secure:  Parameter "SELINUX" in file "/etc/selinux/config" is correctly set to "enforcing"
Notice: Warning: File/Directory "/etc/selinux/config" does not exist
Notice: Fix:     touch/mkdir "/etc/selinux/config" chmod 0400 "/etc/selinux/config" ; chown root:root "/etc/selinux/config"
Notice: Warning: File "/etc/grub.conf" does not contain "enforcing=1"
Notice: Fix:     echo "enforcing=1" >> /etc/grub.conf
Notice: Warning: File "/etc/grub.conf" does not contain "selinux=1"
Notice: Fix:     echo "selinux=1" >> /etc/grub.conf
Notice: Secure:  Package setroubleshoot is uninstalled
Notice: Secure:  Package mctrans is uninstalled
Notice: Auditing security tcp cookies (pulsar::security::tcp::cookies)
Notice: Warning: File "/etc/rc.d/local" does not contain "echo 1 > /proc/sys/net/ipv4/tcp_syncookies"
Notice: Warning: File/Directory "/etc/rc.d/local" does not exist
Notice: Fix:     touch/mkdir "/etc/rc.d/local" chmod 0600 "/etc/rc.d/local" ; chown root:root "/etc/rc.d/local"
Notice: Auditing security umask (pulsar::security::umask)
Notice: Warning: Line "umask 077" in "/etc/login" is not present (Currently "")
Notice: Fix:     echo "umask 077" >> "/etc/login"
Notice: Warning: Line "UMASK = 077" in "/etc/skel/.bashrc" is not present (Currently "")
Notice: Fix:     echo "UMASK = 077" >> "/etc/skel/.bashrc"
Notice: Warning: Line "umask 077" in "/etc/skel/.login" is not present (Currently "")
Notice: Fix:     echo "umask 077" >> "/etc/skel/.login"
Notice: Warning: Line "umask 077" in "/etc/skell/.bash_profile" is not present (Currently "")
Notice: Fix:     echo "umask 077" >> "/etc/skell/.bash_profile"
Notice: Warning: Line "UMASK = 077" in "/etc/bashrc" is not present (Currently "")
Notice: Fix:     echo "UMASK = 077" >> "/etc/bashrc"
Notice: Finished catalog run in 5.93 seconds
```

Run reports for services related tests:

```
$ report/pulsar.rb -r -m services

```
