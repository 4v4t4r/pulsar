# Name:         pulsar (Puppet Unix Lockdown Security Analysis Report)
# Version:      2.3.6
# Release:      1
# License:      Open Source
# Group:        System
# Source:       N/A
# URL:          http://lateralblast.com.au/
# Distribution: Solaris, Red Hat Linux, SuSE Linux, Debian Linux,
#               Ubuntu Linux, Mac OS X, AIX, FreeBSD
# Vendor:       UNIX
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Audit puppet module based on various benchmarks
#               Addition improvements added
#

# Create some functions

# Verbose output

define verbose_message () {
  if $pulsar_mode =~ /report/ {
    notify { "${name}": }
  }
}

# Init message

define init_message ($info = "") {
  if $name =~ /darwin$|aix$|sunos$|linux$/ {
    if $name =~ /darwin/ {
      $message = "Darwin (${sp_os_version})"
    }
    if $name =~ /aix/ {
      $message = "AIX"
    }
    if $name =~ /sunos/ {
      $message = "SunOS (${kernelrelease})"
    }
    if $name =~ /linux/ {
      $message = "Linux (${lsbdistid})"
    }
  }
  else {
    $suffix  = regsubst($name,'pulsar::','','G')
    $message = regsubst($suffix,'::',' ','G')
  }
  verbose_message { "Auditing ${message} (${name})": }
  if $pulsar_mode =~ /detailedreport/ and $name !~ /darwin$|aix$|sunos$|linux$/ {
    if $info {
      notify { $info: }
    }
  }
}

# Check line

define check_line () {
  if $line in $fact {

  }
  else {

  }
}

# Module message

define module_message () {
  notify { "Module(s): ${name}": }
}

# Secure message

define secure_message () {
  if $pulsar_mode =~ /report/ {
    notify { "Secure:  ${name}": }
  }
}

# Warning output

define warning_message ($fix = "") {
  if $pulsar_mode =~ /report/ {
    if $pulsar_mode =~ /detailed/ {
      if $fix =~ /[A-z]/ {
        notify { "Warning: ${name}\nNotice: Fix:     ${fix}": }
      }
      else {
        notify { "Warning: ${name}": }
      }
    }
    else {
      notify { "Warning: ${name}": }
    }
  }
}

# Add content to file

define create_file ($content) {
  file { $name:
    content => $content,
    ensure  => present,
  }
}

# Handle issue

define check_issue () {
  $fact   = $pulsar_issue
  $banner = "
                             NOTICE TO USERS
                             ---------------
This computer system is the private property of $company_name, whether
individual, corporate or government. It is for authorized use only. users
(authorized & unauthorized) have no explicit/implicit expectation of privacy

Any or all uses of this system and all files on this system may be
intercepted, monitored, recorded, copied, audited, inspected, and disclosed
to your employer, to authorized site, government, and/or law enforcement
domestic and foreign.

By using this system, the user expressly consents to such interception,
monitoring, recording, copying, auditing, inspection, and disclosure at the
discretion of such officials. Unauthorized or improper use of this system
may result in civil and criminal penalties and administrative or disciplinary
action, as appropriate. By continuing to use this system you indicate your
awareness of and consent to these terms and conditions of use.

LOG OFF IMMEDIATELY if you do not agree to the conditions stated in this warning.
"
  $secure = "File \"/etc/issue\" contains security banner "
  if $banner in $fact {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      $warning = "File \"/etc/issue\" does not contain a security banner"
      warning_message { $warning: }
    }
    else {
      create_file { "/etc/issue": content => $banner }
    }
  }
}

# Disable inetd.conf entry

define disable_inet () {
  remove_line_from_file { $name:
    match  => $name,
    ensure => "absent",
  }
}

# Disable init.d entry

define disable_init () {
  disable_file { $name: }
}


# Check RSA SecurID

define check_rsa_securid () {

}

# CDE routinges

define add_cde_banner () {
  add_line_to_file { "Dtlogin*greeting.persLabelString: Authorized uses only": path => $name }
}

define add_cde_saver () {
  add_line_to_file { "dtsession*saverTimeout: 10": path => $name }
}

define add_cde_lock () {
  add_line_to_file { "dtsession*lockTimeout: 10": path => $name }
}

define add_line_to_files ($line) {
  $info = "${file}:${line}"
  check_value { $info:
    path => $name,
    line => $line,
  }
}

# Add a line to a file

define add_line_to_file ($fact = "", $path) {
  if $name =~ /%/ {
    $line = regsubst($name,'%','',G)
  }
  else {
    $line = $name
  }
  check_value { $name:
    path => $path,
    line => $line,
    fact => $fact,
  }
}

# Check value

define check_value ($path = "", $fact = "", $param = "", $value = "", $line = "", $ensure = "present", $match = "", $after = "", $remove = "") {
  if $path !~ /\// {
    case $path {
      "apache":                     { $file = "/etc/apache2/httpd.conf" }
      "auditclass":                 { $file = "/etc/security/audit_class" }
      "auditcontrol":               { $file = "/etc/security/audit_control" }
      "auditevent":                 { $file = "/etc/security/audit_event" }
      "auditrules": {
        if $kernel == "SunOS" {
          $file = "/etc/security/audit_rules"
        }
        else {
          $file = "/etc/audit/audit.rules"
        }
      }
      "audituser":                  { $file = "/etc/security/audit_user" }
      "avahid":                     { $file = "/etc/avahi/avahi-daemon.conf" }
      "cron":                       { $file = "/etc/default/cron" }
      "cups":                       { $file = "/etc/cups/client.conf" }
      "cupsd":                      { $file = "/etc/cups/cupsd.conf" }
      "defadduser":                 { $file = "/usr/sadm/defadduser" }
      "floppycdromfdi":             { $file = "/usr/share/hal/fdi/95userpolicy/floppycdrom.fdi" }
      "fstab":  {
        if $kernel == "SunOS" {
          $file = "/etc/vfstab"
        }
        else {
          $file = "/etc/fstab"
        }
      }
      "ftpdaccess": {
        if $kernel == "SunOS" and $kernelrelease != "5.11" {
          $file = "/etc/ftpd/ftpaccess"
        }
        else {
          $file = "/etc/proftpd.conf"
        }
      }
      /ftpdissue|ftpdbanner/: {
        if $kernel == "SunOS" and $kernelrelease != "5.11" {
          $file = "/etc/ftpd/banner.msg"
        }
        else {
          $file = "/etc/proftpd.conf"
        }
      }
      "gdm":                        { $file = "/etc/X11/gdm.conf" }
      "gdmbanner":                  { $file = "/etc/X11/gdm.conf" }
      "gdminit":                    { $file = "/etc/gdm/Init/Default" }
      "grub":                       { $file = "/etc/grub.conf" }
      "hostconfig":                 { $file = "/private/etc/hostconfig" }
      "hostsallow":                 { $file = "/etc/hosts.allow" }
      "hostsdeny":                  { $file = "/etc/hosts.deny" }
      "inet":                       { $file = "/etc/inetd.conf" }
      "inetd":                      { $file = "/etc/default/inetd" }
      "inetinit":                   { $file = "/etc/default/inetinit" }
      "keyserv":                    { $file = "/etc/default/keyserv" }
      "login":                      { $file = "/etc/default/login" }
      "limits":                     { $file = "/etc/security/limits.conf" }
      "mail":                       { $file = "/etc/sysconfig/mail" }
      "modprobe":                   { $file = "/etc/modprobe.conf" }
      "nddnetwork":                 { $file = "/etc/init.d/nddnetwork" }
      "network":                    { $file = "/etc/sysconfig/network" }
      "newsyslog":                  { $file = "/etc/newsyslog.conf" }
      "ntp":                        { $file = "/etc/ntp.conf" }
      "pam":                        { $file = "/etc/pam.conf" }
      "pamcommonauth":              { $file = "/etc/pam.d/common-auth" }
      "pamgdmautologin":            { $file = "/etc/pam.d/gdm-autologin" }
      "pamsshd":                    { $file = "/etc/pam.d/sshd" }
      "pamsu":                      { $file = "/etc/pam.d/su" }
      "pamsystemauth":              { $file = "/etc/pam.d/system-auth" }
      "passwd":                     { $file = "/etc/default/passwd" }
      "policy":                     { $file = "/etc/security/policy.conf" }
      "postfix":                    { $file = "/etc/postfix/main.cf" }
      "power":                      { $file = "/etc/default/power" }
      "prelink":                    { $file = "/etc/prelink.conf" }
      "proftpd":                    { $file = "/etc/proftpd.conf" }
      /^rc$|rcconf/:                { $file = "/etc/rc.conf" }
      "rclocal":                    { $file = "/etc/rc.d/local" }
      "rmmount":                    { $file = "/etc/rmmount" }
      "selinux":                    { $file = "/etc/selinux/config" }
      "sendmail":                   { $file = "/etc/default/sendmail" }
      "sendmailcf":                 { $file = "/etc/mail/sendmail.cf" }
      /smb|samba/:                  { $file = "/etc/samba/smb.conf" }
      "ssh":                        { $file = "/etc/ssh/ssh_config" }
      "sshd":                       { $file = "/etc/ssh/sshd_config" }
      "su":                         { $file = "/etc/default/su" }
      "sudoers":                    { $file = "/etc/sudoers" }
      "sudoerswheel":               { $file = "/etc/sudoers.d/wheel" }
      "sysctl":                     { $file = "/etc/sysctl.conf" }
      "syslog":   {
        if $kernel == "Darwin" {
          $file = "/etc/newsyslog.conf"
        }
        else {
          $file = "/etc/syslog.conf"
        }
      }
      "syslogd":                    { $file = "/etc/default/syslogd" }
      "sysstat":                    { $file = "/etc/default/sysstat" }
      "syssuspend":                 { $file = "/etc/default/sys-suspend" }
      "system":                     { $file = "/etc/system" }
      "telnetd":                    { $file = "/etc/default/telnetd" }
      "umask":                      { $file = "/etc/init.d/umask" }
      "user":                       { $file = "/etc/security/user" }
      "vsftpd":                     { $file = "/etc/vsftpd.conf" }
      "yum":                        { $file = "/etc/yum.conf" }
      /xscreensaver|XScreenSaver/:  { $file = "/usr/openwin/lib/app-defaults/XScreenSaver" }
    }
  }
  else {
    $file = $path
  }
  if $path !~ /\// {
    case $module {
      "apache":                     { $info = $pulsar_apache }
      "auditclass":                 { $info = $pulsar_auditclass }
      "auditcontrol":               { $info = $pulsar_auditcontrol }
      "auditevent":                 { $info = $pulsar_auditevent }
      "auditrules":                 { $info = $pulsar_auditrules }
      "audituser":                  { $info = $pulsar_audituser }
      "avahid":                     { $info = $pulsar_avahid }
      "cron":                       { $info = $pulsar_cron }
      "cups":                       { $info = $pulsar_cups }
      "cupsd":                      { $info = $pulsar_cupsd }
      "defaddusr":                  { $info = $pulsar_defaddusr }
      "floppycdromfdi":             { $info = $pulsar_floppycdromfdi }
      "fstab":                      { $fact = $pulsar_fstab }
      "ftpd":                       { $fact = $pulsar_ftpd }
      "ftpaccess":                  { $fact = $pulsar_ftpdaccess }
      /ftpdissue|ftpdbanner/:       { $fact = $pulsar_ftpdbanner }
      "gdm":                        { $info = $pulsar_gdm }
      "gdmbanner":                  { $info = $pulsar_gdm }
      "gdminit":                    { $info = $pulsar_gdminit }
      "grub":                       { $info = $pulsar_grub }
      "hostconfig":                 { $info = $pulsar_hostconfig }
      "hostsallow":                 { $info = $pulsar_hostallow }
      "hostsdeny":                  { $info = $pulsar_hostsdeny }
      "inet":                       { $info = $pulsar_inet }
      "inetd":                      { $info = $pulsar_inetd }
      "keyserv":                    { $info = $pulsar_keyserv }
      "inetinit":                   { $info = $pulsar_inetinit }
      "limits":                     { $info = $pulsar_limits }
      "login":                      { $info = $pulsar_login }
      "mail":                       { $info = $pulsar_mail }
      "modprobe":                   { $info = $pulsar_modprobe }
      "nddnetwork":                 { $info = $pulsar_nddnetwork }
      "newsyslog":                  { $info = $pulsar_syslog }
      "network":                    { $info = $pulsar_network }
      "ntp":                        { $info = $pulsar_ntp }
      "pam":                        { $info = $pulsar_pam }
      "pamcommonauth":              { $info = $pulsar_pamcommonauth }
      "pamgdmautologin":            { $info = $pulsar_pamgdmautologin }
      "pamsshd":                    { $info = $pulsar_pamsshd }
      "pamsu":                      { $info = $pulsar_pamsu }
      "pamsystemauth":              { $info = $pulsar_pamsystmauth }
      "passwd":                     { $info = $pulsar_passwd }
      "policy":                     { $info = $pulsar_policy }
      "postfix":                    { $info = $pulsar_postfix }
      "power":                      { $info = $pulsar_power }
      "prelink":                    { $info = $pulsar_prelink }
      "proftpd":                    { $info = $pulsar_proftpd }
      "rclocal":                    { $info = $pulsar_rclocal }
      /^rc$|rcconf/:                { $info = $pulsar_rc }
      "rmmount":                    { $info = $pulsar_rmmount }
      "selinux":                    { $info = $pulsar_selinux }
      "sendmail":                   { $info = $pulsar_sendmail }
      "sendmailcf":                 { $info = $pulsar_sendmailcf }
      /smb|samba/:                  { $info = $pulsar_samba }
      "ssh":                        { $info = $pulsar_ssh }
      "sshd":                       { $info = $pulsar_sshd }
      "su":                         { $info = $pulsar_su }
      "sudoers":                    { $info = $pulsar_sudoers }
      "sudoerswheel":               { $info = $pulsar_sudoerswheel }
      "sysctl":                     { $info = $pulsar_sysctl }
      "syslog":                     { $info = $pulsar_syslog }
      "syslogd":                    { $info = $pulsar_syslogd }
      "sysstat":                    { $info = $pulsar_sysstat }
      "syssuspend":                 { $info = $pulsar_syssuspend }
      "system":                     { $info = $pulsar_system }
      "telentd":                    { $info = $pulsar_telnetd }
      "umask":                      { $info = $pulsar_umask }
      "user":                       { $info = $pulsar_user }
      "vsftpd":                     { $info = $pulsar_vsftpd }
      "yum":                        { $info = $pulsar_yum }
      /xscreensaver|XScreenSaver/:  { $info = $pulsar_xscreensaver }
    }
  }
  else {
    $info = $fact
  }
  if $match =~ /[A-z]|[0-9]/ {
    $array  = split($info,"\n")
    $string  = inline_template("<%= array.grep(match) %>")
  }
  else {
    if $line =~ /[A-z]|[0-9]/ {
      $string = $line
    }
    else {
      if $remove =~ /[A-z]|[0-9]/ {
        $string = $remove
      }
    }
  }
  if $line !~ /[A-z]|[0-9]/ and $remove !~ /[A-z]|[0-9]/ {
    if $param =~ /[A-z]|[0-9]/ and $value =~ /[A-z]|[0-9]/ {
      if $path =~ /httpd|ssh|sudo/ {
        $separator = " "
      }
      else {
        if $path =~ /sysctl|krb5/ {
          $separator = " = "
        }
        else {
          if $path =~ /XScreenSaver/ {
            $separator = ": "
          }
          else {
            if $path =~ /system|audit/ {
              $separator = ":"
            }
            else {
              $separator = "="
            }
          }
        }
      }
      if $path == "system" {
        $entry = "set ${param}${separator}${value}"
      }
      else {
        if $path =~ /XScreenSaver/ {
          $entry = "*${param}${separator}${value}"
        }
        else {
          $entry = "${param}${separator}${value}"
        }
      }
      $string = $entry
    }
  }
  else {
    if $remove !~ /[A-z]|[0-9]/ {
      $entry = $line
    }
  }
  if $info !~ /[A-z]|[0-9]/ {
    $test = null
  }
  else {
    $test = $info
  }
  if $string in $test {
    if $entry =~ /[A-z]|[0-9]/ {
      $secure = "File \"${file}\" contains entry \"${entry}\""
    }
    else {
      $secure = "Parameter \"${param}\" in \"${file}\" correctly set to \"${value}\""
    }
    secure_message { $secure: }
  }
  else {
    if $remove =~ /[A-z]/ or $ensure == "absent" {
      if $remove =~ /[A-z]|[0-9]/ {
        $entry = $remove
      }
      $command = "cat \"${file}\" | sed 's/${entry}//g' > /tmp/zzz ; cat /tmp/zzz > \"${file}\""
      $fixing  = "Removing \"${entry}\" from \"${file}\""
    }
    else {
      $command = "echo \"${entry}\" >> \"${file}\""
      $fixing  = "Adding \"${entry}\" to \"${file}\""
    }
    if $pulsar_mode =~ /report/ {
      if $entry =~ /[A-z]|[0-9]/ {
        $warning = "File \"${file}\" does not contain entry \"${entry}\""
      }
      else {
        $warning = "Parameter \"${param}\" in \"${file}\" is not correctly set to \"${value}\""
      }
      warning_message { $warning: fix => $command }
    }
    else {
      if $remove =~ /[A-z]|[0-9]/ {
        exec { $fixing:
          command => $command
        }
      }
      else {
        $message = "Adding \"${entry}\" to ${file}"
        file_line { $fixing:
          path   => $file,
          line   => $line,
          ensure => $ensure,
        }
      }
    }
  }
}

# Fix duplicates

define fix_duplicate_user ($duplicate) {
  $warning = "Duplicate ${duplicate} ${name}"
  $fixing  = "Disabling ${duplicate} ${name}"
  if $name =~ /[A-z]/ {
    if $duplicate =~ /user/ {
      if $kernel == "AIX" {
        $fix_command = "chuser account_locked=true ${name}"
      }
      else {
        $fix_command = "passwd -l ${name}"
      }
    }
    if $duplicate =~ /uid/ {
      if $kernel == "AIX" {
        $command = "chuser account_locked=true `cat /etc/passwd |grep ':${name}:' |cut -f1 -d:`"
      }
      else {
        $command = "passwd -l `cat /etc/passwd |grep ':${name}:' |cut -f1 -d:`"
      }
    }
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        command => $command,
      }
    }
  }
}

# Handle duplicate

define check_duplicate () {
  $secure = "No duplicate ${name} found"
  case $name {
    "uids":   { $fact = $pulsar_duplicateuids }
    "gids":   { $fact = $pulsar_duplicategids }
    "users":  { $fact = $pulsar_duplicateusers }
    "groups": { $fact = $pulsar_duplicategroups }
  }
  if $fact =~ /[0-9]|[A-z]/ {
    $duplicates = split($actual_value,",")
    if $name =~ /uids|users/ {
      fix_duplicate_user { $duplicates: duplicate => $name }
    }
    else {
      $warning = "Duplicate ${name}: ${fact}"
      warning_message { $warning: }
    }
  }
  else {
    secure_message { $secure: }
  }
}

# Disable xinetd service

define disable_xinetd_service () {}

# Enable xinetd service

define enable_xinetd_service () {}

# Check list of files

define check_files ($type) {}

# Handle FreeBSD sulogin

define handle_freebsd_sulogin () {}

# Check NIS entries

define check_nis_entries () {
  case $name {
    "group":    {
      $fact = $pulsar_nisgroupentries
      $file = "/etc/group"
    }
    "passwd":   {
      $fact = $pulsar_nispasswordentries
      $file = "/etc/passwd"
    }
    "password": {
      $fact = $pulsar_nispasswordentries
      $file = "/etc/passwd"
    }
  }
  $secure  = "No NIS \"${name}\" entries in \"${file}\""
  $warning = "NIS \"${name}\" entries in \"${file}\""
  $fixing  = "Removing NIS \"${name}\" entries from \"${file}\""
  $command = "cat ${file} |grep -v '^+' > /tmp/zzz ; cat /tmp/zzz > ${file} ; rm /tmp/zzz"
  if !$fact {
    secure_message { $secure: }
  }
  else {
    if "+" in $fact {
      secure_message { $secure: }
    }
    else {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: }
      }
      else {
        exec { $fixing:
          command => $command,
        }
      }
    }
  }
}

# Check partitions

define check_partition_exists ($fact) {
  $secure  = "Filesystem \"${name}\" is mounted on a separate partition"
  $warning = "Filesystem \"${name}\" is not mounted on a separate partition"
  if $actual_value =~ /[A-z]/ {
    secure_message { $secure: }
  }
  else {
    warning_message { $warning: }
  }
}

define check_passwd_value () {
  case $kernel {
    "Linux":  {
      $fact = $pulsar_login
      $path = "/etc/login.defs"
    }
    "SunOS":  {
      $fact = $pulsar_passwd
      $path = "/etc/default/passwd"
    }
  }
  check_value { $name:
    fact => $fact,
    path => $path,
    line => $name,
  }
}

# Check reserved UID

define check_reserved_uid($value)  {
  $secure  = "User ${name} is in the list of users who should have a reserved UID"
  $warning = "User ${name} is not in the list of users who should have a reserved UID"
  if $kernel == "FreeBSD" {
    $command     = "pw lock ${name}"
  }
  else {
    $command     = "passwd -l ${name}"
  }
  if $name in $value {
    secure_message { $secure: }
  }
  else {
    warning_message { $warning: fix => $command }
  }
}

# Check cron users

define check_cron_users ($path = "") {
  $fact    = $pulsar_cronallow
  $secure  = "User \"${name}\" is in \"${path}\""
  $warning = "User \"${name}\" is not in \"${path}\""
  $command = "echo \"${name}\" >> \"${path}\""
  $fixing  = "Adding user \"${name}\" to \"${path}\""
  if $name in $fact {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: }
    }
    else {
      file_line { $fixing:
        path   => $path,
        line   => $name,
        ensure => present,
      }
    }
  }
}

# Handle cron perms

define check_cronallow_perms () {
  check_file_perms { $name:
    owner => "root",
    group => "root",
    mode  => "0600",
  }
}

# Handle cron perms

define check_crondir_perms () {
  check_dir_perms { $name:
    fact  => $fact,
    owner => "root",
    group => "root",
    mode  => "0750",
  }
}

# Handle reserved UIDs

define check_reserved_uids() {
  $test_users = split($pulsar_reserveduids,",")
  if $kernel == "Linux" {
    $valid_users = [
      'root', 'bin', 'daemon', 'adm', 'lp', 'sync', 'shutdown', 'halt',
      'mail', 'news', 'uucp', 'operator', 'games', 'gopher', 'ftp', 'nobody',
      'nscd', 'vcsa', 'rpc', 'mailnull', 'smmsp', 'pcap', 'dbus', 'sshd',
      'rpcuser', 'nfsnobody', 'haldaemon', 'distcache', 'apache', 'oprofile',
      'webalizer', 'dovecot', 'squid', 'named', 'xfs', 'gdm', 'sabayon'
    ]
  }
  if $kernel == "SunOS" {
    $valid_users = [
      'root', 'daemon', 'bin', 'sys', 'adm', 'lp', 'uucp', 'nuucp',
      'smmsp', 'listen', 'gdm', 'webservd', 'postgres', 'svctag',
      'nobody', 'noaccess', 'nobody4', 'unknown'
    ]
  }
  check_reserved_uid { $test_users:
    value => $valid_users,
  }
}

# Fix system account

define fix_invalid_account () {
  $command = "passwd -l ${name}"
  $warning = "User ${name} has an invalid uid"
  $onlyif  = "cat /etc/passwd |grep '^${name}:' |grep ':0:'"
  $fixing  = "Setting user ${name} shell to /sbin/nologin"
  if $pulsar_mode =~ /report/ {
    warning_message { $warning: fix => $command }
  }
  else {
    exec { $fixing:
      command => $command,
      onlyif  => $onlyif,
    }
  }
}

# Handle system accounts

define check_system_accounts () {
  $secure = "No users with invalid ids"
  if $pulsar_invalidsystemaccounts =~ /[A-z]/ {
    $users = split($pulsar_invalidsystemaccounts,",")
    fix_invalid_account { $users: }
  }
  else {
    secure_message { $secure: }
  }
}

# Fix invalid shells

define fix_invalid_shell () {
  $warning = "User ${name} has an invalid shell"
  $fixing  = "Setting user ${name} shell to /sbin/nologin"
  $unless  = "cat /etc/passwd |grep '^${name}:' |grep 'nologin'"
  if $kernel =~ /FreeBSD/ {
    $command = "pw moduser ${name} -s /sbin/nologin"
  }
  else {
    $command = "usermod -s /sbin/nologin ${name}"
  }
  if $pulsar_mode =~ /report/ {
    warning_message { $warning: fix => $command }
  }
  else {
    exec { $fixing:
      command => $command,
      unless  => $unless,
    }
  }
}

# Handle invalid shells

define check_system_shells () {
  $secure = "No users with invalid shells"
  $fact   = $pulsar_invalidsystemshells
  if $fact =~ /[A-z]/ {
    $users = split($fact,",")
    fix_invalid_shell { $users: }
  }
  else {
    secure_message { $secure: }
  }
}

# Handle unconfined daemons

define check_unconfined_daemons () {
  if $pulsar_mode =~ /report/ {
    $fact    = $pulsar_unconfineddaemons
    $warning = "Unconfined daemons (${actual_value})"
    $command = "Confine daemons (${actual_value})"
    $secure  = "No unconfined daemons"
    if $fact =~ /[A-z]/ {
      warning_message { $warning: fix => $command }
    }
    else {
      secure_message { $secure: }
    }
  }
}

# Handle sysctl values

define check_skel_values ($line) {
  case $name {
    'loginskel': {
      $fact = $pulsar_loginskel
      $path = "/etc/skel/login"
    }
    'profileskel': {
      $fact = $pulsar_profileskel
      $path = "/etc/skel/profile"
    }
    'bashprofileskel': {
      $fact = $pulsar_bashprofileskel
      $path = "/etc/skel/.bash_profile"
    }
    'bashrcskel': {
      $fact = $pulsar_bashrcskel
      $path = "/etc/skel/.bashrc"
    }
    'zshrcskel': {
      $fact = $pulsar_zshrcskel
      $path = "/etc/skel/.zshrc"
    }
    'kshrcskel': {
      $fact = $pulsar_kshrcskel
      $path = "/etc/skel/.kshrc"
    }
    'tshrcskel': {
      $fact = $pulsar_tshrcskel
      $path = "/etc/skel/.tshrc"
    }
  }
  check_value { $name:
    fact => $fact,
    path => $path,
    line => $line,
  }
}

# Handle multiple values

define check_file_values ($param, $value, $path = "") {
  $message = "Handling Parameter \"${param}\" for \"${path}\""
  check_file_value { "${message}":
    path  => $path,
    param => $param,
    value => $value,
  }
}

# Check empty password fields

define check_empty_password_fields () {
  $fact   = $pulsar_emptypasswordfields
  $users  = split($fact,",")
  $secure = "No empty password fields found"
  if $users =~ /[A-z]/ {
    disable_user { $users: reason => "empty password field" }
  }
  else {
    secure_message { $secure: }
  }
}

# Fix suid files (remove group/other read write)

define fix_user_file ($type = "") {
  if $type !~ /[A-z]/ {
    $mode = "0000"
    $fix_command     = "chmod ${mode} ${name}"
  }
  else {
    if $type =~ /unowned/ {
      $mode = "600"
      $fix_command = "chmod ${mode} ${name} ; chown root:root ${name}"
    }
    else {
      if $type =~ /stickybit/ {
        $mode = "-t"
      }
      if $type =~ /suid/ {
        $mode = "-s"
      }
      if $type =~ /worldwritable/ {
        $mode = "-o-w"
      }
      if $type =~ /groupwritable/ {
        $mode = "-g-w"
      }
      if $type =~ /readwritable/ {
        $mode = "600"
      }
      $fix_command     = "chmod ${mode} ${name}"
    }
  }
  $warning_message = "File \"${name}\" is \"${type}\""
  $fix_message     = "Fixing file ${name} permissions"
  if $pulsar_mode =~ /report/ {
    warning_message { "${warning_message}": fix => $fix_command }
  }
  else {
    exec { "${fix_message}":
      command => $fix_command,
    }
  }
}

# Move files

define disable_file () {
  if $name =~ /\// {
    $file_info = split($name,"/")
    $directory = inline_template("<%= file_info[0..-2] %>")
    $dir_name  = join($directory,"/")
    $file_name = $file_info[-1]
  }
  else {
    $dir_name  = "/etc/init.d"
    $file_name = $name
  }
  $new_name  = "/${dir_name}/_${file_name}"
  $warning   = "File \"${name}\" exists"
  $command   = "mv \"${name}\" \"${new_name}\""
  $fixing    = "Moving file \"${name}\" to \"${new_name}\""
  if $pulsar_mode =~ /report/ {
    warning_message { $warning: fix => $command }
  }
  else {
    exec { $fixing:
      command => $command,
    }
  }
}

# Disable files

define check_user_files () {
  $secure = "No ${name} files need to be fixed"
  case $name {
    "forward":        { $fact = $pulsar_forwardfiles }
    "netrc":          { $fact = $pulsar_netrcfiles }
    "rhosts":         { $fact = $pulsar_rhostsfiles }
    "hostequiv":      { $fact = $pulsar_hostsequivfiles }
    "shosts":         { $fact = $pulsar_shostsfiles }
    "stickybit":      { $fact = $pulsar_stickybitfiles }
    "suid":           { $fact = $pulsar_suidfiles }
    "unowned":        { $fact = $pulsar_unownedfiles }
    "worldwritable":  { $fact = $pulsar_worldwritablefiles }
    "readabledot":    { $fact = $pulsar_readabledot }
  }
  if $fact =~ /[A-z]/ {
    $file_list = split($fact,",")
    fix_user_file { $file_list: type => $name }
  }
  else {
    secure_message { $secure: }
  }
}

# Check group exists

define check_group_exists ($fact) {
  $secure  = "Group \"${name}\" exists"
  $warning = "Wheel user ${name} has not logged in recently"
  $command = "groupadd ${name} ; usermod -G ${name} root"
  $fixing  = "Creating group ${name}"
  if $fact == "yes" {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        command => $command,
      }
    }
  }
}

# Check grub password

define check_grub_password () {
  $fact    = $pulsar_grub
  $secure  = "Grub password set"
  $warning = "Grub password not set"
  if $fact =~ /password/ {
    secure_message { $secure: }
  }
  else {
    warning_message { $warning: }
  }
}

# Handle wheel users

define check_wheel_users () {
  $fact    = $pulsar_intactivewheelusers
  $users   = split($fact,",")
  $secure  = "There are no wheel users with inactive logins"
  $warning = "There are users in the wheel group with inactive logins"
  if $users !~ /[A-z]/ {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: }
    }
    disable_wheel_user { $users: }
  }
}

# Check wheel users

define disable_wheel_user () {
  $warning = "Wheel user ${name} has not logged in recently"
  $command = "passwd -l ${name}"
  $fixing  = "Fixing wheel user ${name}"
  if $pulsar_mode =~ /report/ {
    warning_message { $warning: fix => $command }
  }
  else {
    exec { $fixing:
      command => $command,
    }
  }
}

# Check world writable files

define fix_world_writable_file () {
  $warning = "World writable file ${name}"
  $command = "chmod o-w \"${name}\""
  $fixing  = "Fixing world writable file \"${name}\""
  if $pulsar_mode =~ /report/ {
    warning_message { $warning: fix => $command }
  }
  else {
    exec { $fixing:
      command => $command,
    }
  }
}

# Handle exec/system command

define check_exec ($fact = "", $exec, $check, $value) {
  if $fact !~ /[0-9]|[A-z]/ {
    $string  = regsubst($exec,'/|\.','_',G)
    $temp    = "pulsar_exec_${string}"
    $lc_temp = inline_template("<%= temp.downcase %>")
    $test    = inline_template("<%= scope.lookupvar(lc_temp) %>")
  }
  else {
    $test = $fact
  }
  $secure  = "Output of \"${check}\" is correct (\"${value}\")"
  $warning = "Output of \"${check}\" is not correct (Currently \"${fact}\")"
  $fixing  = "Executing \"${exec}\""
  $unless  = "${check} 2>&1 |grep '${value}'"
  if $test in $value {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $exec }
    }
    else {
      if $check =~ /[A-z]/ {
        $unless = "${check} |grep '${value}'"
        exec { $fixing:
          command => $exec,
          unless  => $unless,
        }
      }
      else {
        exec { $fixing:
          command => $exec,
        }
      }
    }
  }
}

# Disable serial console

define disable_serial_console () {
  if $kernel =~ /AIX|Linux/ {
    disable_inittab { "getty": }
  }
  if $kernel == "SunOS" {
    if $kernelrelease =~ /11/ {
      if $pulsar_sunos_serialservices =~ /[a-z]/ {
        $service_list = split($pulsar_serialservices,",")
        disable_service { $service_list: }
      }
    }
  }
}

# Fix shadow group

define fix_shadow_group_members () {
  # Need to put commadn in here
  $command = ""
  $warning = "Shadow group contains members"
  $onlyif  = ""
  $fixing  = ""
  if $pulsar_mode =~ /report/ {
    warning_message { $warning: fix => $command }
  }
  else {
    exec { $fixing:
      command => $command,
      onlyif  => $onlyif,
    }
  }
}

# Handle shadow group members

define check_shadow_group_members () {
  $fact   = $pulsar_shadowgroupmembers
  $secure = "Shadow group does not contain members"
  if $fact =~ /[A-z]/ {
    $users = split($fact,",")
    fix_shadow_group_members { $users: }
  }
  else {
    secure_message { $secure: }
  }
}

# Check directory exists

define check_dir_exists ($fact = "", $exists = "yes" ) {
  check_exists { $name:
    fact   => $fact,
    type   => "Directory",
    exists => $exists,
  }
}

# Check file exists (default is yes)

define check_file_exists ($fact = "", $exists = "yes") {
  check_exists { $name:
    fact   => $fact,
    type   => "File",
    exists => $exists,
  }
}

# Check file or directory exists

define check_exists ($fact = "", $type = "", $exists = "yes") {
  if $type =~ /[F,f]ile|[D,d]ir/ {
    if $type =~ /[F,f]ile/ {
      if $exists =~ /yes/ {
        $command = "touch \"${name}\""
      }
      else {
        $command = "rm \"${name}\""
      }
    }
    if $type =~ /[D,d]ir/ {
      if $exists =~ /yes/ {
        $command = "mkdir \"${name}\""
      }
      else {
        $command = "rmdir \"${name}\""
      }
    }
    if $exists =~ /yes/ {
      $warning = "${type} \"${name}\" does not exist"
      $secure  = "${type} \"${name}\" exists"
    }
    else {
      $warning = "${type} \"${name}\" exists"
      $secure  = "${type} \"${name}\" does not exist"
    }
  }
  else {
    $command = ""
    if $exists =~ /yes/ {
      $warning = "File/Directory \"${name}\" does nor exist"
      $secure  = "File/Directory \"${name}\" exists"
    }
    else {
      $warning = "File/Directory \"${name}\" exists"
      $secure  = "File/Directory \"${name}\" does not exist"
    }
  }
  if $fact == $exists {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      if $command =~ /[A-z]/ {
        $fixing = "Creating ${type} ${name}"
        exec { $fixing:
          command => $command,
        }
      }
    }
  }
}

# Fix invalid shell entry in /etc/shells

define fix_invalid_shell_entry () {
  $command = "cat /etc/shells |grep -v '#{name}' > /tmp/shells ; cat /tmp/shells > /etc/shells ; rm /tmp/shells"
  $warning = "Shell #{name} is in /etc/shells but does not exist"
  $onlyif  = "cat /etc/shells |grep '#{name}"
  $fixing  = ""
  if $pulsar_mode =~ /report/ {
    warning_message { $warning: fix => $command }
  }
  else {
    exec { $fixing:
      command => $command,
      onlyif  => $onlyif,
    }
  }
}

# Handle invalid shells

define handle_invalid_shells () {
  $fact   = $pulsar_invalidshells
  $secure = "No invalid shells in /etc/shells"
  if $fact =~ /[A-z]/ {
    $shells = split($fact,",")
    fix_invalid_shell_entry { $shells: }
  }
  else {
    secure_message { $secure: }
  }
}

# Handle file perms

define check_file_perms ($fact ="", $mode, $owner, $group) {
  if $fact !~ /[0-9]|[A-z]/ {
    if $name !~ /\// {
      $temp = "pulsar_perms_configfile_${name}"
    }
    else {
      $file    = regsubst($name,'/|\.','_',G)
      $temp    = "pulsar_perms${file}"
    }
    $lc_temp = inline_template("<%= temp.downcase %>")
    $perms   = inline_template("<%= scope.lookupvar(lc_temp) %>")
  }
  else {
    $perms = $fact
  }
  check_perms { $name:
    fact  => $perms,
    owner => $owner,
    group => $group,
    mode  => $mode,
    type => "File",
  }
}

# Handle directory perms

define check_dir_perms ($fact ="", $mode, $owner, $group) {
  if $fact !~ /[0-9]|[A-z]/ {
    $file    = regsubst($name,'/|\.','_',G)
    $temp    = "pulsar_perms${file}"
    $lc_temp = inline_template("<%= temp.downcase %>")
    $perms   = inline_template("<%= scope.lookupvar(lc_temp) %>")
  }
  else {
    $perms = $fact
  }
  check_perms { $name:
    fact  => $perms,
    owner => $owner,
    group => $group,
    mode  => $mode,
    type  => "Directory",
  }
}

# Handle file/directory permissions

define check_perms ($fact = "", $mode, $owner, $group, $type = "") {
  $value = "${mode},${owner},${group}"
  if $type !~ /File|file|Dir|dir/ {
    $fs_item    = "File/Directory"
    $fs_command = "touch/mkdir"
  }
  else {
    $fs_item = $type
    if $type =~ /File|file/ {
      $fs_command = "touch"
    }
    else {
      $fs_command = "mkdir"
    }
  }
  if $mode =~ /^[0-9][0-9][0-9]$/ {
    $full_mode = "0${mode}"
  }
  else {
    $full_mode = $mode
  }
  if $fact !~ /[0-9]/ {
    $warning = "$fs_item \"${name}\" does not exist"
    $command = "$fs_command \"${name}\" chmod ${full_mode} \"${name}\" ; chown ${owner}:${group} \"${name}\""
    warning_message { $warning: fix => $command }
  }
  else {
    $command = "$fs_command \"${name}\" ; chmod ${full_mode} ${name} ; chown ${owner}:${group} \"${name}\""
    if $fact == $value {
      $secure = "$fs_item permissions for \"${name}\" are correct (Mode=${full_mode},Owner=${owner},Group=${group})"
      secure_message { $secure: }
    }
    else {
      if $pulsar_mode =~ /report/ {
        $f_values = split($actual_value,",")
        $f_mode   = $f_values[0]
        $f_owner  = $f_values[1]
        $f_group  = $f_values[2]
        $warning  = "File permissions for \"${name}\" are not correct (Currently: Mode=${f_mode},Owner=${f_owner},Group=${f_group})"
        warning_message { $warning: fix => $command }
      }
      else {
        file { $name:
          mode  => $full_mode,
          owner => $owner,
          group => $group,
        }
      }
    }
  }
}

# Handle symlink

define check_symlink ($target) {
  $fact    = "pulsar_symlink_${name}"
  $lc_fact = inline_template("<%= fact.downcase %>")
  $link    = inline_template("<%= scope.lookupvar(lc_fact)%>")
  $secure  = "File \"${name}\" is correctly symlinked to \"${target}\""
  $warning = "File \"${name}\" is not symlinked to \"${target}\""
  $command = "ln -s \"${target}\" \"${name}\""
  $fixing  = "Symlinking \"${name}\" to \"${link}\""
  if $target in $link {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command}
    }
    else {
      file { $fixing:
        path   => $name,
        target => $target,
        ensure => link,
      }
    }
  }
}

# Enable tcp wrappers via inetadm on Solaris

define enable_tcpwrappers () {
  if $kernel =~ /SunOS/ {
    $param   = "tcp_wrappers"
    $value   = "TRUE"
    $message = "Setting ientadm ${parameter} for ${name} to ${value}"
    check_inetadm { "${message}":
     service => $name,
     param   => $param,
     value   => $value,
    }
  }
}

# Disable service

define disable_service () {
  $status  = "disabled"
  $message = "Disabling ${name}"
  handle_service { $message:
    service => $name,
    status  => $status,
  }
}

# Enable service

define enable_service () {
  $status  = "enabled"
  $message = "Enabling ${name}"
  handle_service { $message:
    service => $name,
    status  => $status,
  }
}

# Handle service

define handle_service ($service, $status) {
  $fact = $pulsar_systemservices
  $secure  = "Service \"${service}\" is ${status}"
  $warning = "Service \"${service}\" is not ${status}"
  if $kernel == "Darwin" {
    $enable  = "/usr/bin/sudo /bin/launchctl load -w /System/Library/LaunchDaemons/${service_name}.plist"
    $disable = "/usr/bin/sudo /bin/launchctl unload -w /System/Library/LaunchDaemons/${service_name}.plist"
  }
  if $kernel == "Linux" {
    if $lsbdistid =~ /CentOS|Red|Scientific|SuSE/ {
      $enable  = "/usr/bin/sudo /sbin/chkconfig ${service_name} on"
      $disable = "/usr/bin/sudo /sbin/chkconfig ${service_name} off"
    }
    if $lsbdistid =~ /Debian|Ubuntu/ {
      $enable  = "/usr/bin/sudo /usr/bin/update-rc.d ${service_name} enable ; /usr/bin/sudo /usr/bin/service ${service_name} start"
      $disable = "/usr/bin/sudo /usr/bin/update-rc.d ${service_name} disable ; /usr/bin/sudo /usr/bin/service ${service_name} stop"
    }
  }
  if $kernel == "SunOS" {
    if $kernelrelease =~ /10|11/ {
      $enable  = "/usr/bin/sudo /usr/bin/svcadm enable ${service_name}"
      $disable = "/usr/bin/sudo /usr/bin/svcadm disable ${service_name}"
    }
    else {
      $enable  = "for i in `find /etc/rc*.d/_[S,K]*${service_name}` ; do export j=`echo $i |sed 's/_//g'` ; echo \"mv $i $j\" |sh ; done"
      $disable = "for i in `find /etc/rc*.d/[S,K]*${service_name}` ; do export j=`echo $i |sed 's/[S,K]/_&/g'` ; echo \"mv $i $j\" |sh ; done"
    }
  }
  if $status =~ /enabled|on|true/ {
    if "${service}," in $fact {
      secure_message { $secure: }
    }
    else {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix  => $enable }
      }
      else {
        service { $service_name:
          enable => true,
          ensure => running,
        }
      }
    }
  }
  else {
    if "${service}," in $fact {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix => $disable }
      }
      else {
        service { $service:
          enable => false,
          ensure => stopped,
        }
      }
    }
    else{
      if $pulsar_mode =~ /report/ {
        secure_message { $secure: }
      }
    }
  }
}

# Handle primary GID

define check_primary_gid($fact, $gid) {
  $secure  = "Primary GID for user ${name} is correctly set to ${gid}"
  $warning = "Primary GID for user ${name} is not set to ${gid} (Currently: ${fact})"
  $fixing  = "Setting primary GID for ${name} to ${gid}"
  $command = "usermod -g ${gid} ${name}"
  $unless  = "cat /etc/passwd |grep '^${name}:' |cut -f4 -d: |grep '^${gid}$'"
  if $fact == $gid {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        command => $command,
        unless  => $unless,
      }
    }
  }
}

# Check old users

define check_old_users () {
  $fact    = $pulsar_oldusers
  $securee = "No old inactive user accounts exist"
  if $fact =~ /[A-z]/ {
    $users  = split($fact,",")
    $reason = "User has not logged in recently"
    disable_user { $users: reason => $reason }
  }
  else {
    secure_message { $secure: }
  }
}

# Check path directory

define check_path_dir() {
  $path    = regsubst($name," ","",G)
  $warning = "PATH contains ."
  $secure  = "PATH ${path} does not contain ."
  $message = "Remove . from PATH"
  if $path =~ /^\.$/ {
    warning_message { $warning: fix => $message }
  }
  else {
    secure_message { $secure: }
  }
}

# Handle user PATH

define check_path ($fact = "") {
  if $fact !~ /[0-9]|[A-z]/ {
    $string = regsubst($name,'/|\.','_',G)
    $temp   = "pulsar_${name}env_path"
    $test   = inline_template("<%= scope.lookupvar(temp) %>")
  }
  else {
    $test = $fact
  }
  $Warning = "Empty directory in PATH for ${name}"
  $secure  = "No empty directories in PATH for ${name}"
  $message = "Remove empty directory from PATH for ${name}"
  if $test =~ /::|:$/ {
    warning_message { $warning: fix => $message }
  }
  else {
    secure_message { $secure: }
  }
  $paths = split($test,":")
  check_path_dir { $paths: }
}

# Handle users with invalid home directory permissions

define handle_invalid_home_perm () {
  $correct = "0750"
  $details = split($name,":")
  $home    = $details[0]
  $actual  = $details[1]
  $fixing  = "Fixing permissions on ${home}"
  $command = "chmod ${correct} ${home}"
  $warning = "Home directory ${home} does not have correct permissions (Currently \"${actual}\", Should be \"${correct}\")"
  if $actual != $correct {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing: command => $command }
    }
  }
}

define check_invalid_home_perms () {
  $fact   = $pulsar_homeperms
  $secure = "No home directories with invalid permissions"
  if $fact =~ /[A-z]/ {
    $perms = split($fact,",")
    handle_invalid_home_perm { $perms: }
  }
  else {
    secure_message { $secure: }
  }
}

# Handle unused gids and groups

define handle_unused ($type) {
  $warning = "Unused ${type}: ${name}"
  warning_message { $warning: }
}

define check_unused () {
  case $name {
    "groups": { $fact = $pulsar_unusedgroups }
    "gids":   { $fact = $pulsar_unusedgids }
  }
  $secure = "No unused ${name}"
  if $fact =~ /[A-z]/ {
    $items = split($fact,",")
    handle_unused { $items: type => $name}
  }
  else {
    secure_message { $secure: }
  }
}

# Handle users with invalid home directory ownership

define handle_invalid_home_owner () {
  $details = split($name,":")
  $user    = $details[0]
  $uid     = $details[1]
  $home    = $details[2]
  $warning = "User ${user_name} does not own their home directory"
  $fixing  = "Fixing ownership of ${user_home}"
  $command = "chown ${user_name} ${user_home}"
  if $pulsar_mode =~ /report/ {
    warning_message { $warning: fix => $command }
  }
  else {
    exec { $fixing: command => $command }
  }
}

define check_invalid_home_owners () {
  $secure = "No home directories with incorrect ownership"
  if $pulsar_invalidhomeowners =~ /[A-z]/ {
    $invalid_users = split($pulsar_invalidhomeowners,",")
    handle_invalid_home_owner { $invalid_users: }
  }
  else {
    secure_message { $secure: }
  }
}

# Handle users with invalid home directories

define handle_invalid_home_dir () {
  $home    = "${pulsar_defaulthome}/${name}"
  $warning = "User ${user_name} does not have a valid home directory"
  $fixing  = "Fixing home directory for ${user_home}"
  $command = "mkdir ${user_home} ; chown ${user_name} ${user_home}"
  if $pulsar_mode =~ /report/ {
    warning_message { $warning: fix => $command }
  }
  else {
    exec { $fixing: command => $command }
  }
}

define check_invalid_home_dirs () {
  $secure = "No users have invalid home directories"
  if $pulsar_invalidhomedirs =~ /[A-z]/ {
    $invalid_users = split($pulsar_invalidhomedirs,",")
    handle_invalid_home_dir { $invalid_users: }
  }
  else {
    secure_message { $secure: }
  }
}

# Check root home directory

define check_home_dir($path = "") {
  $home    = "pulsar_${kernel}_${name}homedir"
  $lc_fact = inline_template("<%= home.downcase %>")
  $fact     = inline_template("<%= scope.lookupvar(lc_fact) %>")
  $secure  = "Home directory for ${name} is ${path}"
  $warning = "Home directory for ${name} is not ${path} (Currently: ${fact}"
  if $name =~ /root/ {
    $ommand = "mv -i /.?* ${home} ; passmgmt -m -h ${path} ${name}"
    $unless = "cat /etc/passwd |grep '^${name}:' |cut -f6 -d: |grep '^${path}$'"
    $fixing = "Moving ${name} account to ${path}"
  }
  if $fact == $path {
    secure_message { $secure: }
  }
  else {
    if $name =~ /root/ {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix => $command }
      }
      else {
        exec { $fixing:
          command => $command,
          unless  => $unless,
        }
      }
    }
  }
}

# Check for root SSH keys

define disable_ssh_keys () {
  $secure = "No SSH keys exist for user ${name}"
  if $pulsar_rootsshkeys =~ /[A-z]/ {
    $ssh_key_list = split($pulsar_rootsshkeys,",")
    disable_file { $ssh_key_list: }
  }
  else {
    secure_message { $secure: }
  }
}

# Disable user

define disable_user($reason = "") {
  $fixing  = "Disabling user ${name}"
  $command = "passwd -l ${name}"
  $warning = "User ${name} is ${reason}"
  $secure  = "User ${name} is not ${reason}"
  if $name in $pulsar_userlist {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        command => $command,
      }
    }
  }
  else {
    secure_message { $secure: }
  }
}

# Remove text

define remove_text_from_file ($fact ="", $path) {
  if $name =~ /%/ {
    $line = regsubst($name,'%','',G)
  }
  else {
    $line = $name
  }
  check_value { $name:
    path   => $path,
    remove => $line,
    fact   => $fact,
  }
}

# Handle file mtime

define check_file_mtime ($fact = "", $max = "", $min = "", $exec = "") {
  if $fact !~ /[0-9]|[A-z]/ {
    if $name !~ /\// {
      $temp = "pulsar_mtime_configfile_${name}"
    }
    else {
      $file    = regsubst($name,'/|\.','_',G)
      $temp    = "pulsar_mtime${file}"
    }
    $lc_temp = inline_template("<%= temp.downcase %>")
    $mtime   = inline_template("<%= scope.lookupvar(lc_temp) %>")
  }
  else {
    $mtime = $fact
  }
  $secure  = "File \"${name}\" mtime \"${fact}\" meets mtime requirements (Max: \"${max}\", Min: \"${min}\")"
  $warning = "File \"${name}\" mtime does not meet criteria (Max: \"${max}\", Min: \"${min}\", Currently \"${fact}\")"
  $fixing  = "Executing ${exec}"
  if $mtime =~ /file does not exist/ or $mtime !~ /[0-9]/ {
    $do_exec = "yes"
  }
  else {
    if $max =~ /[0-9]/ {
      if $mtime > $max {
        $do_exec = "yes"
      }
    }
    else {
      if $min =~ /[0-9]/ {
        if $mtime > $min {
          $do_exec = "yes"
        }
      }
    }
  }
  if $do_exec == "yes" {
    if $exec =~ /[A-z]/ {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix => $exec }
      }
      else {
        exec { $fixing:
          command => $exec,
        }
      }
    }
    else {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: }
      }
    }
  }
  else {
    secure_message { $secure: }
  }
}

# Fix console service

define fix_console_service() {
  $warning = "Remote console enabled on ${name}"
  $fixing  = "Disabling remote console on ${name}"
  if $kernel == "SunOS" {
    $command = "/usr/sbin/consadm -d ${name}"
    $onlyif  = "/usr/sbin/consadm -p |grep '${name}'"
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      exec { $fixing:
        command => $command,
        onlyif  => $onlyif,
      }
    }
  }
  else {
    if $pulsar_mode =~ /report/ {
      $command = "cat /etc/securetty |grep -v '${name}' > /tmp/zzz ; cat /tmp/zzz > /etc/securetty"
      warning_message { $warning: fix => $command }
    }
    else {
      if $name =~ /tty/ {
        file_line { $fixing:
          path  => "/etc/securetty",
          line  => $name,
          ensure => absent,
        }
      }
    }
  }
}

# Handle console services

define handle_console_services () {
  $fact   = $pulsar_consoleservices
  $secure = "No remote consoles enabled"
  if $fact !~ /[A-z]/ {
    secure_message { $secure: }
  }
  else {
    $devices = split($fact,",")
    fix_console_service { $devices: }
  }
}

# Disable remote access

define disable_remote_access () {
  handle_aix_lsuser_login { $name:
    login  => "false",
    rlogin => "false",
  }
}

# Handle adding lines to a file

define remove_line_from_file ($path = "", $match = "") {
  $message = "Checking file \"${name}\" for \"${line}\""
  check_value { $message:
    path  => $path,
    line  => $name,
    match => $match,
  }
}

# Install package

define install_package () {
  check_package { $name:
    status => "installed",
  }
}

# Uninstall package

define uninstall_package () {
  check_package { $name:
    status => "uninstalled",
  }
}

# Handle package

define check_package ($status) {
  $search = "${name}:"
  if $kernel == "Linux" {
    if $lsbdistid =~ /SuSE|Red|Scientific|CentOS/ {
      $install   = "yum install ${name}"
      $uninstall = "yum remove ${name}"
    }
    else {
      $install   = "apt-get install ${name}"
      $uninstall = "apt-get remove ${name}"
    }
  }
  if $kernel == "SunOS" {
    if $kernelrelease != "5.11" {
      $install   = "pkgadd -d ${name}"
      $uninstall = "pkgrm ${name}"
    }
    else {
      $install   = "pkg install ${name}"
      $uninstall = "pkg remove ${name}"
    }
  }
  $secure  = "Package ${name} is ${status}"
  $warning = "Package ${name} is not ${status}"
  $fixing  = "Ensuring package ${package} is ${status}"
  if $status == "installed" {
    if $search in $pulsar_installedpackages {
      secure_message { $secure: }
    }
    else {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix => $install }
      }
      else {
        package { $name:
          ensure => present,
        }
      }
    }
  }
  else {
    if $search in $pulsar_installedpackages {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix => $uninstall }
      }
      else {
        if $pulsar_uninstall_package == "yes" {
          package { $name:
            ensure => absent,
          }
        }
      }
    }
    else{
      secure_message { $secure: }
    }
  }
}

# Check a mount

define check_nodev_mount ($type) {
  $file = $pulsar_configfile_fstab
  if $name =~ /ext[2,3,4]|swapfs/ {
    $info  = split($name,"\s+")
    $mount = $info[1]
    if $mount !~ /^\/$|^\/boot$/ {
      if $type in $mount {
        $secure = "Mount \"${mount}\" is already mounted with option \"${type}\""
        secure_message { $secure: }
      }
      else {
        $command = "cat \"${file}\"| awk '( $3 ~ /^ext[2,3,4]|tmpfs$/ && $2 == \"${mount}\" ) { $4 = $4 \",${type}\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",$1,$2,$3,$4,$5,$6 }' > /tmp/zzz ; cat /tmp/zzz > \"${file}\" ; rm /tmp/zzz"
        if $pulsar_mode =~ /report/ {
          $warning = "Mount \"${mount}\" is not mounted with option \"${type}\""
          warning_message { $warning: fix => $command }
        }
        else {
          $fixing = "Adding option \"${type}\" to mount \"${mount}\""
          exec { $fixing:
            command => $command,
          }
        }
      }
    }
  }
}

define check_noexec_mount ($type) {
  $file = $pulsar_configfile_fstab
  if $name =~ /ext[2,3,4]|swapfs/ {
    $info  = split($name,"\s+")
    $mount = $info[1]
    if $mount !~ /^\/$|^\/boot$/ {
      if $type in $mount {
        $secure = "Mount \"${mount_point}\" is already mounted with option \"${type}\""
        secure_message { $secure: }
      }
      else {
        $command = "cat \"${fstab_file}\"| awk '( $3 ~ /^ext[2,3,4]|tmpfs$/ && $2 == \"${mount}\" ) { $4 = $4 \",${type}\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",$1,$2,$3,$4,$5,$6 }' > /tmp/zzz ; cat /tmp/zzz > \"${file}\" ; rm /tmp/zzz"
        if $pulsar_mode =~ /report/ {
          $warning = "Mount \"${mount}\" is not mounted with option \"${type}\""
          warning_message { $warning: fix => $command }
        }
        else {
          $fixing = "Adding option \"${type}\" to mount \"${mount}\""
          exec { $fixing:
            command => $command,
          }
        }
      }
    }
  }
}

define check_nosuid_mount ($type) {
  $file = $pulsar_configfile_fstab
  if $name =~ /ext[2,3,4]|swapfs/ {
    $info  = split($name,"\s+")
    $mount = $info[1]
    if $mount !~ /^\/$|^\/boot$/ {
      if $type in $mount {
        $secure = "Mount \"${mount}\" is already mounted with option \"${type}\""
        secure_message { $secure: }
      }
      else {
        $command = "cat \"${file}\"| awk '( $3 ~ /^ext[2,3,4]|tmpfs$/ && $2 == \"${mount}\" ) { $4 = $4 \",${type}\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",$1,$2,$3,$4,$5,$6 }' > /tmp/zzz ; cat /tmp/zzz > \"${file}\" ; rm /tmp/zzz"
        if $pulsar_mode =~ /report/ {
          $warning = "Mount \"${mount}\" is not mounted with option \"${type}\""
          warning_message { $warning: fix => $command }
        }
        else {
          $fixing = "Adding option \"${type}\" to mount \"${mount}\""
          exec { $fixing:
            command => $command,
          }
        }
      }
    }
    else {
      $secure = "Mount \"${mount}\" does not need to be mounted with \"${type}\""
      secure_message { $secure: }
    }
  }
}

# Check mounts

define check_mounts () {
  $fact    = $pulsar_fstab
  $entries = split($fact,"\n")
  case $name {
    "nodev":  { check_nodev_mount { $entries: type => $name } }
    "noexec": { check_noexec_mount { $entries: type => $name } }
    "nosuid": { check_nosuid_mount { $entries: type => $name } }
  }
}

# Disable initab service

define disable_inittab () {
  handle_inittab { $name:
    status => "off",
  }
}

# Enable initab service

define enable_inittab ($entry) {
  handle_inittab { $name:
    status => "on",
    entry  => $entry,
  }
}

# Handle crontab

define add_crontab_entry ($fact = "", $path) {
  $secure  = "Crontab file \"${path}\" contains \"${name}\""
  $warning = "Crontab file \"${path}\" does not contain \"${name}\""
  $fixing  = "Adding \"${name}\" to crontab file \"${path}\""
  $command = "echo \"${name}\" >> \"${path}\""
  if $name in $fact {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $command }
    }
    else {
      file_line { $fixing:
        path   => $path,
        line   => $name,
        ensure => present,
      }
    }
  }
}

# Handle inittab

define handle_inittab ($status, $entry = "") {
  $fact = $pulsar_inittabservices
  if $kernel == "AIX" {
    $disable = "rmitab `lsitab -a |grep '^${name}'`"
    $enable  = "mkitab \"${entry}\""
    if $status =~ /enabled|on/ {
      $onlyif = "lsitab -a |grep '^${name}' |wc -l |grep '^0$'"
    }
    else {
      $onlyif = "lsitab -a |grep '^${name}' |wc -l |grep '^1$'"
    }
  }
  else {
    $disable = "grep -v '^${name}' /etc/inittab > /tmp/zzz ; cat /tmp/zzz > /etc/inittab"
    $enable  = "echo '${entry}' >> /etc/inittab"
    if $status =~ /enabled|on/ {
      $onlyif = "cat /etc/inittab |grep '^${name}' |wc -l |grep '^0$'"
    }
    else {
      $onlyif_command = "cat /etc/inittab |grep '^${name}' |wc -l |grep '^1$'"
    }
  }
  $secure  = "Init entry ${service_name} is ${status}"
  $warning = "Init entry ${service_name} is not ${status}"
  $fixing  = "Setting ${service_name} to ${status}"
  if $status =~ /enabled|on/ {
    if "${name}," in $fact {
      secure_message { $secure: }
    }
    else {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix => $enable }
      }
      else {
        if $kernel == "AIX" {
          exec { $fixing:
            command => $enable,
            onlyif  => $onlyif,
          }
        }
        else {
          file_line { $name:
            path   => "/etc/inittab",
            line   => $entry,
            ensure => present,
          }
        }
      }
    }
  }
  else {
    if "${name}," in $fact {
      if $pulsar_mode =~ /report/ {
        warning_message { $warning: fix => $disable }
      }
      else {
        exec { $fixing:
          command => $disable,
          onlyif  => $onlyif,
        }
      }
    }
    else {
      secure_message { $secure: }
    }
  }
}

class pulsar::init {
  verbose_message { 'Initialising pulsar (init.pp)': }
}

class pulsar::mode {
  if $pulsar_mode == "lockdown" {
    verbose_message { "Running in lockdown mode": }
  }
  else {
    verbose_message { "Running in report mode": }
  }
}

class pulsar::exit {
  if $pulsar_mode =~ /report/ {
    notify { "Finishing pulsar run": }
  }
}

# Create class

class pulsar {

  include pulsar::init
  include pulsar::mode
  include pulsar::exit

  if $kernel == "AIX" {
    include pulsar::aix
  }
  if $kernel == "Darwin" {
    include pulsar::darwin
  }
  if $kernel == "FreeBSD" {
    include pulsar::freebsd
  }
  if $kernel == "Linux" {
    include pulsar::linux
  }
  if $kernel == "SunOS" {
    include pulsar::sunos
  }

  # Set up some variables

  $cron_allow_list    = [ 'root', 'sys' ]
  $funct_file_value   = '/usr/local/bin/update_file_value.sh'
  $audit_logadm_value = '/usr/local/bin/audit_logadm_value.sh'
  $pulsar_work_dir    = '/opt/pulsar'
  $pulsar_temp_dir    = '${pulsar_work_dir}/tmp'
  $pulsar_temp_file   = '${pulsar_temp_dir}/output'

  # Set up default exec path

  Exec { path => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin' ] }

}


