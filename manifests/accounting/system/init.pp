# pulsar::accounting::system
#
# System accounting gathers baseline system data (CPU utilization, disk I/O,
# etc.) every 20 minutes. The data may be accessed with the sar command, or by
# reviewing the nightly report files named /var/adm/sa/sar*.
# Note: The sys id must be added to /etc/cron.allow to run the system
# accounting commands..
# Once a normal baseline for the system has been established, abnormalities
# can be investigated to detect unauthorized activity such as CPU-intensive
# jobs and activity outside of normal usage hours.
#
# Configure System Accounting (auditd):
#
# System auditing, through auditd, allows system administrators to monitor
# their systems such that they can detect unauthorized access or modification
# of data. By default, auditd will audit SELinux AVC denials, system logins,
# account modifications, and authentication events. Events will be logged to
# /var/log/audit/audit.log. The recording of these events will use a modest
# amount of disk space on a system. If significantly more events are captured,
# additional on system or off system storage may need to be allocated.
#
# Note: For 64 bit systems that have arch as a rule parameter, you will need
# two rules: one for 64 bit and one for 32 bit systems.
# For 32 bit systems, only one rule is needed.
#
# Configure Data Retention:
#
# When auditing, it is important to carefully configure the storage
# requirements for audit logs.
#
# Configure Audit Log Storage Size
#
# Configure the maximum size of the audit log file. Once the log reaches the
# maximum size, it will be rotated and a new log file will be started.
# It is important that an appropriate size is determined for log files so that
# they do not impact the system and audit data is not lost.
#
# Disable System on Audit Log Full:
#
# The auditd daemon can be configured to halt the system when the audit logs
# are full.
# In high security contexts, the risk of detecting unauthorized access or
# nonrepudiation exceeds the benefit of the system's availability.
# Normally, auditd will hold 4 logs of maximum log file size before deleting
# older log files.
# In high security contexts, the benefits of maintaining a long audit history
# exceed the cost of storing the audit history.
#
# Keep All Auditing Information:
#
# Normally, auditd will hold 4 logs of maximum log file size before deleting
# older log files.
# In high security contexts, the benefits of maintaining a long audit history
# exceed the cost of storing the audit history.
#
# Enable auditd Service:
#
# Turn on the auditd daemon to record system events.
# The capturing of system events provides system administrators with
# information to allow them to determine if unauthorized access to their
# system is occurring.
#
# Enable Auditing for Processes That Start Prior to auditd:
#
# Configure grub so that processes that are capable of being audited can be
# audited even if they start up prior to auditd startup.
# Audit events need to be captured on processes that start up prior to auditd,
# so that potential malicious activity cannot go undetected.
#
# Record Events That Modify Date and Time Information:
#
# Capture events where the system date and/or time has been modified.
# The parameters in this section are set to determine if the adjtimex
# (tune kernel clock), settimeofday (Set time, using timeval and timezone
# structures) stime (using seconds since 1/1/1970) or clock_settime (allows
# for the setting of several internal clocks and timers) system calls have
# been executed and always write an audit record to the /var/log/audit.log
# file upon exit, tagging the records with the identifier "time-change"
# Unexpected changes in system data and/or time could be a sign of malicious
# activity on the system.
#
# Record Events That Modify User/Group Information:
#
# Record events affecting the group, passwd (user IDs), shadow and gshadow
# (passwords) or /etc/security/opasswd (old passwords, based on remember
# parameter in the PAM configuration) files. The parameters in this section
# will watch the files to see if they have been opened for write or have had
# attribute changes (e.g. permissions) and tag them with the identifier
# "identity" in the audit log file.
# Unexpected changes to these files could be an indication that the system has
# been compromised and that an unauthorized user is attempting to hide their
# activities or compromise additional accounts.
#
# Record Events That Modify the System's Network Environment:
#
# Record changes to network environment files or system calls.
# The below parameters monitor the sethostname (set the systems host name) or
# setdomainname (set the systems domainname) system calls, and write an audit
# event on system call exit. The other parameters monitor the /etc/issue and
# /etc/issue.net files (messages displayed pre- login), /etc/hosts (file
# containing host names and associated IP addresses) and /etc/sysconfig/network
# (directory containing network interface scripts and configurations) files.
# Monitoring sethostname and setdomainname will identify potential unauthorized
# changes to host and domainname of a system. The changing of these names could
# potentially break security parameters that are set based on those names.
# The /etc/hosts file is monitored for changes in the file that can indicate
# an unauthorized intruder is trying to change machine associations with IP
# addresses and trick users and processes into connecting to unintended
# machines. Monitoring /etc/issue and /etc/issue.net is important, as intruders
# could put disinformation into those files and trick users into providing
# information to the intruder. Monitoring /etc/sysconfig/network is important
# as it can show if network interfaces or scripts are being modified in a way
# that can lead to the machine becoming unavailable or compromised.
# All audit records will be tagged with the identifier "system-locale."
#
# Record Events That Modify the System's Mandatory Access Controls:
#
# Monitor SELinux mandatory access controls. The parameters below monitor any
# write access (potential additional, deletion or modification of files in the
# directory) or attribute changes to the /etc/selinux directory.
# Changes to files in this directory could indicate that an unauthorized user
# is attempting to modify access controls and change security contexts, leading
# to a compromise of the system.
#
# Collect Login and Logout Events:
#
# Monitor login and logout events. The parameters below track changes to files
# associated with login/logout events. The file /var/log/faillog tracks failed
# events from login. The file /var/log/lastlog maintain records of the last
# time a user successfully logged in. The file /var/log/btmp keeps track of
# failed login attempts and can be read by entering the command:
# /usr/bin/last -f /var/log/btmp.
# All audit records will be tagged with the identifier "logins."
#
# Collect Session Initiation Information:
#
# Monitor session initiation events. The parameters in this section track
# changes to the files associated with session events. The file /var/run/utmp
# file tracks all currently logged in users. The /var/log/wtmp file tracks
# logins, logouts, shutdown and reboot events. All audit records will be tagged
# with the identifier "session."
# Monitoring these files for changes could alert a system administrator to
# logins occurring at unusual hours, which could indicate intruder activity
# (i.e. a user logging in at a time when they do not normally log in).
#
# Collect Discretionary Access Control Permission Modification Events:
#
# Monitor changes to file permissions, attributes, ownership and group.
# The parameters in this section track changes for system calls that affect
# file permissions and attributes. The chmod, fchmod and fchmodat system calls
# affect the permissions associated with a file. The chown, fchown, fchownat
# and lchown system calls affect owner and group attributes on a file.
# The setxattr, lsetxattr, fsetxattr (set extended file attributes) and
# removexattr, lremovexattr, fremovexattr (remove extended file attributes)
# control extended file attributes. In all cases, an audit record will only be
# written for non-system userids (auid >= 500) and will ignore Daemon events
# (auid = 4294967295). All audit records will be tagged with the identifier
# "perm_mod."
#
# Collect Unsuccessful Unauthorized Access Attempts to Files:
#
# Monitor for unsuccessful attempts to access files. The parameters below are
# associated with system calls that control creation (creat), opening (open,
# openat) and truncation (truncate, ftruncate) of files. An audit log record
# will only be written if the user is a non- privileged user (auid > = 500),
# is not a Daemon event (auid=4294967295) and if the system call returned
# EACCES (permission denied to the file) or EPERM (some other permanent error
# associated with the specific system call). All audit records will be tagged
# with the identifier "access."
# Failed attempts to open, create or truncate files could be an indication
# that an individual or process is trying to gain unauthorized access to the
# system.
#
# Collect Use of Privileged Commands:
#
# Monitor privileged programs (thos that have the setuid and/or setgid bit set
# on execution) to determine if unprivileged users are running these commands.
# Execution of privileged commands by non-privileged users could be an
# indication of someone trying to gain unauthorized access to the system.
#
# Collect Successful File System Mounts:
#
# Monitor the use of the mount system call. The mount (and umount) system call
# controls the mounting and unmounting of file systems. The parameters below
# configure the system to create an audit record when the mount system call is
# used by a non-privileged user
# It is highly unusual for a non privileged user to mount file systems to the
# system. While tracking mount commands gives the system administrator evidence
# that external media may have been mounted (based on a review of the source of
# the mount and confirming it's an external media type), it does not
# conclusively indicate that data was exported to the media. System
# administrators who wish to determine if data were exported, would also have
# to track successful open, creat and truncate system calls requiring write
# access to a file under the mount point of the external media file system.
# This could give a fair indication that a write occurred. The only way to
# truly prove it, would be to track successful writes to the external media.
# Tracking write system calls could quickly fill up the audit log and is not
# recommended. Recommendations on configuration options to track data export
# to media is beyond the scope of this document.
#
# Collect File Deletion Events by User:
#
# Monitor the use of system calls associated with the deletion or renaming of
# files and file attributes. This configuration statement sets up monitoring
# for the unlink (remove a file), unlinkat (remove a file attribute), rename
# (rename a file) and renameat (rename a file attribute) system calls and tags
# them with the identifier "delete".
# Monitoring these calls from non-privileged users could provide a system
# administrator with evidence that inappropriate removal of files and file
# attributes associated with protected files is occurring. While this audit
# option will look at all events, system administrators will want to look for
# specific privileged files that are being deleted or altered.
#
# Collect Changes to System Administration Scope (sudoers):
#
# Monitor scope changes for system administrations. If the system has been
# properly configured to force system administrators to log in as themselves
# first and then use the sudo command to execute privileged commands, it is
# possible to monitor changes in scope. The file /etc/sudoers will be written
# to when the file or its attributes have changed. The audit records will be
# tagged with the identifier "scope."
# Changes in the /etc/sudoers file can indicate that an unauthorized change
# has been made to scope of system administrator activity.
#
# Collect Changes to System Administration Scope (sudolog):
#
# Monitor the sudo log file. If the system has been properly configured to
# disable the use of the su command and force all administrators to have to
# log in first and then use sudo to execute privileged commands, then all
# administrator commands will be logged to /var/log/sudo.log.
# Any time a command is executed, an audit event will be triggered as the
# /var/log/sudo.log file will be opened for write and the executed
# administration command will be written to the log.
# Changes in /var/log/sudo.log indicate that an administrator has executed a
# command or the log file itself has been tampered with. Administrators will
# want to correlate the events written to the audit trail with the records
# written to /var/log/sudo.log unauthorized commands have been executed.
#
# Collect Kernel Module Loading and Unloading:
#
# Monitor the loading and unloading of kernel modules. The programs insmod
# (install a kernel module), rmmod (remove a kernel module), and modprobe
# (a more sophisticated program to load and unload modules, as well as some
# other features) control loading and unloading of modules. The init_module
# (load a module) and delete_module (delete a module) system calls control
# loading and unloading of modules. Any execution of the loading and unloading
# module programs and system calls will trigger an audit record with an
# identifier of "modules".
# Monitoring the use of insmod, rmmod and modprobe could provide system
# administrators with evidence that an unauthorized user loaded or unloaded a
# kernel module, possibly compromising the security of the system.
# Monitoring of the init_module and delete_module system calls would reflect
# an unauthorized user attempting to use a different program to load and
# unload modules.
#
# Make the Audit Configuration Immutable:
#
# Set system audit so that audit rules cannot be modified with auditctl.
# Setting the flag "-e 2" forces audit to be put in immutable mode. Audit
# changes can only be made on system reboot.
# In immutable mode, unauthorized users cannot execute changes to the audit
# system to potential hide malicious activity and then put the audit rules
# back. Users would most likely notice a system reboot and that could alert
# administrators of an attempt to make unauthorized audit changes.
#
# Refer to Section(s) 4.2.1.1-18 Page(s) 77-96 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.3.1.1-21 Page(s) 113-136 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 5.2.1.1-18 Page(s) 86-9,100-120 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 8.1.1.1-18 Page(s) 86-106 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.2 Page(s) 18 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.4-5,17 Page(s) 194-5,202 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.8 Page(s) 71-2 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_auditrules
# Requires fact: pulsar_sysstat
# Requires fact: pulsar_installedpackages
# Requires fact: pulsar_perms_var_adm_sa
# Requires fact: pulsar_perms_etc_security_audit
# Requires fact: pulsar_perms_audit
# Requires fact: pulsar_perms_var_adm_sa


class pulsar::accounting::system::init {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel =~ /Linux|SunOS|FreeBSD|AIX/ {
      init_message { "pulsar::accounting::system": }
      if $kernel == "Linux" {
        install_package { "sysstat": }
        install_package { "audit": }
      }
    }
  }
}

class pulsar::accounting::system::pre {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == "Linux" {
      add_line_to_file { "-f 1": path => "auditrules" }
    }
  }
}

class pulsar::accounting::system::post {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel == "Linux" {
      add_line_to_file { "-e 2": path => "auditrules" }
    }
  }
}

class pulsar::accounting::system::main {
  if $pulsar_modules =~ /accounting|full/ {
    if $kernel =~ /Linux|SunOS|FreeBSD|AIX/ {
      if $kernel =~ /AIX/ {
        check_file_perms { "/var/adm/sa":
          owner => "adm",
          group => "adm",
          mode  => "0755",
        }
        check_file_perms { "/etc/security/audit":
          owner => "root",
          group => "audit",
          mode  => "0750",
        }
        check_file_perms { "/audit":
          owner => "root",
          group => "audit",
          mode  => "0750",
        }
      }
      if $kernel == "FreeBSD" {
        check_exists { "/var/account/acct": }
      }
      if $kernel == "Linux" {
        add_line_to_file { "-w /var/log/sudo.log -p wa -k actions": path => "auditrules", }
        if $lsbdistid =~ /Debian|Ubuntu/ {
          add_line_to_file { "ENABLED = true": path => "sysstat", }
        }
        if $architecture =~ /32/ {
          $lines = [
            '-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change',
            '-a always,exit -F arch=b32 -S clock_settime -k time-change',
            '-w /etc/localtime -p wa -k time-change',
            '-w /etc/group -p wa -k identity',
            '-w /etc/passwd -p wa -k identity',
            '-w /etc/gshadow -p wa -k identity',
            '-w /etc/shadow -p wa -k identity',
            '-w /etc/security/opasswd -p wa -k identity',
            '-a exit,always -F arch=b32 -S sethostname -S setdomainname -k system-locale',
            '-w /etc/issue -p wa -k system-locale',
            '-w /etc/issue.net -p wa -k system-locale',
            '-w /etc/hosts -p wa -k system-locale',
            '-w /etc/sysconfig/network -p wa -k system-locale',
            '-w /etc/selinux/ -p wa -k MAC-policy',
            '-w /var/log/faillog -p wa -k logins',
            '-w /var/log/lastlog -p wa -k logins',
            '-w /var/run/utmp -p wa -k session',
            '-w /var/log/btmp -p wa -k session',
            '-w /var/log/wtmp -p wa -k session',
            '-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod',
            '-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod',
            '-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod',
            '-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access',
            '-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access',
            '-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export',
            '-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete',
            '-w /etc/sudoers -p wa -k scope',
            '-w /sbin/insmod -p x -k modules',
            '-w /sbin/rmmod -p x -k modules',
            '-w /sbin/modprobe -p x -k modules',
            '-a always,exit -S init_module -S delete_module -k modules',
            '-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts',
            'space_left_action = email',
            'action_mail_acct = email',
            'admin_space_left_action = email',
            'max_log_file = MB',
            'max_log_file_action = keep_logs'
          ]
        }
        else {
          $lines = [
            '-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change',
            '-a always,exit -F arch=b64 -S adjtimex -S settimeofday -S stime -k time-change',
            '-a always,exit -F arch=b32 -S clock_settime -k time-change',
            '-a always,exit -F arch=b64 -S clock_settime -k time-change',
            '-w /etc/localtime -p wa -k time-change',
            '-w /etc/group -p wa -k identity',
            '-w /etc/passwd -p wa -k identity',
            '-w /etc/gshadow -p wa -k identity',
            '-w /etc/shadow -p wa -k identity',
            '-w /etc/security/opasswd -p wa -k identity',
            '-a exit,always -F arch=b32 -S sethostname -S setdomainname -k system-locale',
            '-a exit,always -F arch=b64 -S sethostname -S setdomainname -k system-locale',
            '-w /etc/issue -p wa -k system-locale',
            '-w /etc/issue.net -p wa -k system-locale',
            '-w /etc/hosts -p wa -k system-locale',
            '-w /etc/sysconfig/network -p wa -k system-locale',
            '-w /etc/selinux/ -p wa -k MAC-policy',
            '-w /var/log/faillog -p wa -k logins',
            '-w /var/log/lastlog -p wa -k logins',
            '-w /var/run/utmp -p wa -k session',
            '-w /var/log/btmp -p wa -k session',
            '-w /var/log/wtmp -p wa -k session',
            '-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod',
            '-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod',
            '-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod',
            '-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod',
            '-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod',
            '-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod',
            '-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access',
            '-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access',
            '-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access',
            '-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access',
            '-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export',
            '-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k export',
            '-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete',
            '-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete',
            '-w /etc/sudoers -p wa -k scope',
            '-w /sbin/insmod -p x -k modules',
            '-w /sbin/rmmod -p x -k modules',
            '-w /sbin/modprobe -p x -k modules',
            '-a always,exit -S init_module -S delete_module -k modules',
            '-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts',
            '-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts',
            'space_left_action = email',
            'action_mail_acct = email',
            'admin_space_left_action = email',
            'max_log_file = MB',
            'max_log_file_action = keep_logs'
          ]
        }
        add_line_to_file { $lines: path => "auditrules" }
        enable_service { "sysstat": }
        enable_service { "auditd": }
      }
    }
  }
}
