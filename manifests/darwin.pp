# OS X related audit

# Requires fact: pulsar_managednode

# Check OS X pwpolicy

define check_pwpolicy ($fact = "", $value) {
  if $fact !~ /[A-z]|[0-9]/ {
    $string = inline_template("<%= name.downcase %>")
    $temp   = "pulsar_pwpolicy_${string}"
    $test   = inline_template("<%= scope.lookupvar(temp)%>")
  }
  else {
    $test = $fact
  }
  $secure  = "pwpolicy parameter \"${name}\" is set to \"${value}\""
  $warning = "pwpolicy parameter \"${name}\" not set to \"${value}\" (Currently \"${fact}\")"
  $command = "/usr/bin/sudo /usr/bin/pwpolicy -n ${pulsar_managednode} -setglobalpolicy ${name}=${value}"
  $unless  = "/usr/bin/sudo /usr/bin/pwpolicy -n ${pulsar_managednode} -getglobalpolicy ${name} 2>&1 |cut -f2 -d= |sed 's/ //g' |grep \"^${value}\""
  $fixing  = "Setting pwpolicy ${name} to ${value}"
  if $test == $value {
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

# Handle OS X dscl

define check_dscl ($fact = "", $user, $param, $value) {
  if $fact !~ /[A-z]|[0-9]/ {
    $string = inline_template("<%= param.downcase %>")
    $temp   = "pulsar_dscl_${user}_${string}"
    $test   = inline_template("<%= scope.lookupvar(temp)%>")
  }
  else {
    $test = $fact
  }
  if $test in $value {
    $message  = "dscl parameter \"${param}\" is set to \"${value}\""
    secure_message { $message: }
  }
  else {
    $command = "/usr/bin/sudo /usr/bin/dscl . -create /Users/${user} ${param} ${value}"
    if $pulsar_mode =~ /report/ {
      $message = "dscl parameter \"${param}\" not set to \"${value}\" (Currently \"${fact}\")"
      warning_message { $message: fix => $command }
    }
    else {
      $unless  = "/usr/bin/dscl . read /Users/${user} ${param} 2>&1 |awk -F: '{print $(NF)}' |sed 's/ //g' |grep \"^${value}\""
      $message = "Setting dscl ${param} to ${value}"
      exec { "${fix_message}":
        command => $fix_command,
        unless  => $unless_command,
      }
    }
  }
}

# Handle OS X pmset

define check_pmset ($fact = "", $value) {
  if $fact !~ /[A-z]|[0-9]/ {
    $temp = "pulsar_pmset_${name}"
    $test = inline_template("<%= scope.lookupvar(temp)%>")
  }
  else {
    $test = $fact
  }
  $warning = "pmset parameter \"${name}\" not set to \"${value}\" (Currently \"${test}\")"
  $command = "/usr/bin/sudo /usr/bin/pmset -c ${name} ${value}"
  $fixing  = "Setting pmset parameter ${name} to ${correct_value}"
  $unless  = "/usr/bin/pmset -c ${name} 2>&1 |awk '{print $2}' |sed 's/ //g' |grep \"^${value}\""
  $secure  = "pmset parameter \"${name}\" is set to \"${value}\""
  if $test in $value {
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

# Fix software update

define fix_software_update () {
  if $kernel == "Darwin" {
    $warning = "Scheduled Software Update is off"
    $fixing  = "Ensuring Software Update is on"
    $command = "sudo softwareupdate --schedule on"
    $onlyif  = "sudo softwareupdate --schedule |awk '{print $4}'"
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
}

# Check bonjour

define check_bonjour () {
  $fact = $pulsar_launchctl_com_apple_mdnsresponder_programarguments
  if $fact !~ /NoMulticastAdvertisements/ {
    check_exec { 'pulsar::service::bonjour::NoMulticastAdvertisements':
      fact  => $fact,
      exec  => 'cat /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist |sed "s,mDNSResponder</string>,&X                <string>-NoMulticastAdvertisements</string>,g" |tr X "\n" > /tmp/bonjour ; cat /tmp/bonjour > /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist ; rm /tmp/bonjour',
      check => 'cat /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist |grep "NoMulticastAdvertisements" |wc -l |grep "^1$"',
      value => "1",
    }
  }
}


# Handle software update

define check_software_update () {
  if $kernel == "Darwin" {
    $secure = "Scheduled Software Update is on"
    if $pulsar_softwareupdateschedule == "on" {
      secure_message { $secure: }
    }
    else {
      fix_software_update { "softwareupdate": }
    }
  }
}

# Handle OSX System Profiler

define check_profiler ($fact = "", $param, $value, $exec) {
  if $fact !~ /[A-z]|[0-9]/ {
    $lc_name  = inline_template("<%= name.downcase %>")
    $lc_param = inline_template("<%= param.downcase %>")
    $temp     = "pulsar_systemprofiler_${lc_name}_${lc_param}"
    $test     = inline_template("<%= scope.lookupvar(temp)%>")
  }
  else {
    $test = $fact
  }
  $secure  = "System parameter \"${param}\" for \"${name}\" correctly set to \"${value}\""
  $warning = "System parameter \"${param}\" for \"${name}\" not correctly set to \"${value}\" (Currently set to \"${fact}\")"
  $fixing  = "Setting system parameter \"${parameter}\" to \"${correct_value}\""
  $unless  = "system_profiler ${name} |grep '${param}' |awk -F ': ' '{print $2}' |grep '${value}'"
  if $test == $value {
    secure_message { $secure: }
  }
  else {
    if $pulsar_mode =~ /report/ {
      warning_message { $warning: fix => $exec }
    }
    else {
      exec { $fixing:
        command => $exec,
        unless  => $unless,
      }
    }
  }
}

# Check OS X Defaults

define check_defaults ($fact = "", $pfile, $param, $value) {
  if $fact !~ /[A-z]|[0-9]/ {
    $lc_pfile = inline_template("<%= pfile.downcase %>")
    $lc_param = inline_template("<%= param.downcase %>")
    $temp     = "pulsar_systemprofiler_${lc_pfile}_${lc_param}"
    $us_temp  = regsubst($temp,'.','_',G)
    $test     = inline_template("<%= scope.lookupvar(us_temp)%>")
  }
  else {
    $test = $fact
  }
  $int_fact = $test
  if $value =~ /[0-9]/ {
    $type = "int"
    $int_value  = $value
    $char_value = $test
  }
  else {
    $type = "bool"
    if $value == "yes" {
      $int_value = "1"
    }
    if $value == "no" {
      $int_value = "0"
    }
    if $int_fact == "1" {
      $char_fact = "yes"
    }
    if $int_fact == "0" {
      $char_fact = "no"
    }
  }
  if $int_value == $int_fact {
    $message  = "Defaults parameter \"${param}\" for \"${pfile}\" is correctly set to \"${value}\""
    secure_message { $message: }
  }
  else {
    $command = "/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/${pfile} ${param} -${type} ${value}"
    if $pulsar_mode =~ /report/ {
      $message = "Defaults parameter \"${param}\" for \"${pfile}\" is not correctly set to \"${value}\""
      warning_message { $message: fix => $command }
    }
    else {
      $message = "Setting defaults parameter ${param} to ${value}"
      $unless  = "/usr/bin/defaults read /Library/Preferences/${pfile} ${param} |grep \"^${value}\""
      exec { $message:
        command => $command,
        unless  => $unless,
      }
    }
  }
}

# OS X Audit

class pulsar::darwin::init {
  if $kernel == "Darwin" {
    init_message { "pulsar::darwin": }
  }
}

class pulsar::darwin {
  if $kernel == "Darwin" {
    include pulsar,                                 pulsar::init
    include pulsar::mode,                           pulsar::darwin::init
    include pulsar::file::stickybit::init,          pulsar::file::stickybit::main
    include pulsar::file::suid::init,               pulsar::file::suid::main
    include pulsar::file::unowned::init,            pulsar::file::unowned::main
    include pulsar::file::writable::init,           pulsar::file::writable::main
    include pulsar::firewall::osx::init,            pulsar::firewall::osx::main
    include pulsar::firewall::tcpwrappers::init,    pulsar::firewall::tcpwrappers::main
    include pulsar::login::auto::init,              pulsar::login::auto::main
    include pulsar::login::detail::init,            pulsar::login::detail::main
    include pulsar::login::guest::init,             pulsar::login::guest::main
    include pulsar::login::logout::init,            pulsar::login::logout::main
    include pulsar::login::remote::init,            pulsar::login::remote::main
    include pulsar::login::warning::init,           pulsar::login::warning::main
    include pulsar::os::core::limit::init,          pulsar::os::core::limit::main
    include pulsar::os::setup::init,                pulsar::os::setup::main
    include pulsar::os::update::init,               pulsar::os::update::main
    include pulsar::password::hints::init,          pulsar::password::hints::main
    include pulsar::password::strength::init,       pulsar::password::strength::main
    include pulsar::priv::sudo::timeout::init,      pulsar::priv::sudo::timeout::main
    include pulsar::priv::wheel::sudo::init,        pulsar::priv::wheel::sudo::main
    include pulsar::priv::wheel::users::init,       pulsar::priv::wheel::users::main
    include pulsar::security::banner::init,         pulsar::security::banner::main
    include pulsar::security::download::init,       pulsar::security::download::main
    include pulsar::security::issue::init,          pulsar::security::issue::main
    include pulsar::security::keyboard::init,       pulsar::security::keyboard::main
    include pulsar::security::keychain::init,       pulsar::security::keychain::main
    include pulsar::security::safari::init,         pulsar::security::safari::main
    include pulsar::security::screensaver::init,    pulsar::security::screensaver::main
    include pulsar::security::swap::init,           pulsar::security::swap::main
    include pulsar::security::trash::init,          pulsar::security::trash::main
    include pulsar::security::vault::init,          pulsar::security::vault::main
    include pulsar::service::apache::init,          pulsar::service::apache::main
    include pulsar::service::ard::init,             pulsar::service::ard::main
    include pulsar::service::bonjour::init,         pulsar::service::bonjour::main
    include pulsar::service::bt::init,              pulsar::service::bt::main
    include pulsar::service::cd::init,              pulsar::service::cd::main
    include pulsar::service::epcc::init,            pulsar::service::epcc::main
    include pulsar::service::file::init,            pulsar::service::file::main
    include pulsar::service::guest::init,           pulsar::service::guest::main
    include pulsar::service::infrared::init,        pulsar::service::infrared::main
    include pulsar::service::nat::init,             pulsar::service::nat::main
    include pulsar::service::newsyslog::init,       pulsar::service::newsyslog::main
    include pulsar::service::ntp::init,             pulsar::service::ntp::main
    include pulsar::service::print::sharing::init,  pulsar::service::print::sharing::main
    include pulsar::service::samba::init,           pulsar::service::samba::main
    include pulsar::service::screen::init,          pulsar::service::screen::main
    include pulsar::service::spctl::init,           pulsar::service::spctl::main
    include pulsar::service::ssh::config::init,     pulsar::service::ssh::config::main
    include pulsar::service::ssh::keys::init,       pulsar::service::ssh::keys::main
    include pulsar::service::web::init,             pulsar::service::web::main
    include pulsar::service::wol::init,             pulsar::service::wol::main
    include pulsar::service::xgrid::init,           pulsar::service::xgrid::main
    include pulsar::user::dotfiles::init,           pulsar::user::dotfiles::main
    include pulsar::user::duplicate::init,          pulsar::user::duplicate::main
    include pulsar::user::lockout::init,            pulsar::user::lockout::main
    include pulsar::user::netrc::init,              pulsar::user::netrc::main
    include pulsar::user::path::init,               pulsar::user::path::main
    include pulsar::user::rhosts::init,             pulsar::user::rhosts::main
    include pulsar::user::root::init,               pulsar::user::root::main
    include pulsar::user::super::init,              pulsar::user::super::main
    include pulsar::exit
    if $pulsar_mode =~ /report/ {
      Class['pulsar']->                                 Class['pulsar::init']->
      Class['pulsar::mode']->                           Class['pulsar::darwin::init']->
      Class['pulsar::file::stickybit::init']->          Class['pulsar::file::stickybit::main']->
      Class['pulsar::file::suid::init']->               Class['pulsar::file::suid::main']->
      Class['pulsar::file::unowned::init']->            Class['pulsar::file::unowned::main']->
      Class['pulsar::file::writable::init']->           Class['pulsar::file::writable::main']->
      Class['pulsar::firewall::osx::init']->            Class['pulsar::firewall::osx::main']->
      Class['pulsar::firewall::tcpwrappers::init']->    Class['pulsar::firewall::tcpwrappers::main']->
      Class['pulsar::login::auto::init']->              Class['pulsar::login::auto::main']->
      Class['pulsar::login::detail::init']->            Class['pulsar::login::detail::main']->
      Class['pulsar::login::guest::init']->             Class['pulsar::login::guest::main']->
      Class['pulsar::login::logout::init']->            Class['pulsar::login::logout::main']->
      Class['pulsar::login::remote::init']->            Class['pulsar::login::remote::main']->
      Class['pulsar::login::warning::init']->           Class['pulsar::login::warning::main']->
      Class['pulsar::os::core::limit::init']->          Class['pulsar::os::core::limit::main']->
      Class['pulsar::os::setup::init']->                Class['pulsar::os::setup::main']->
      Class['pulsar::os::update::init']->               Class['pulsar::os::update::main']->
      Class['pulsar::password::hints::init']->          Class['pulsar::password::hints::main']->
      Class['pulsar::password::strength::init']->       Class['pulsar::password::strength::main']->
      Class['pulsar::priv::sudo::timeout::init']->      Class['pulsar::priv::sudo::timeout::main']->
      Class['pulsar::priv::wheel::sudo::init']->        Class['pulsar::priv::wheel::sudo::main']->
      Class['pulsar::priv::wheel::users::init']->       Class['pulsar::priv::wheel::users::main']->
      Class['pulsar::security::banner::init']->         Class['pulsar::security::banner::main']->
      Class['pulsar::security::download::init']->       Class['pulsar::security::download::main']->
      Class['pulsar::security::issue::init']->          Class['pulsar::security::issue::main']->
      Class['pulsar::security::keyboard::init']->       Class['pulsar::security::keyboard::main']->
      Class['pulsar::security::keychain::init']->       Class['pulsar::security::keychain::main']->
      Class['pulsar::security::safari::init']->         Class['pulsar::security::safari::main']->
      Class['pulsar::security::screensaver::init']->    Class['pulsar::security::screensaver::main']->
      Class['pulsar::security::swap::init']->           Class['pulsar::security::swap::main']->
      Class['pulsar::security::trash::init']->          Class['pulsar::security::trash::main']->
      Class['pulsar::security::vault::init']->          Class['pulsar::security::vault::main']->
      Class['pulsar::service::apache::init']->          Class['pulsar::service::apache::main']->
      Class['pulsar::service::ard::init']->             Class['pulsar::service::ard::main']->
      Class['pulsar::service::bonjour::init']->         Class['pulsar::service::bonjour::main']->
      Class['pulsar::service::bt::init']->              Class['pulsar::service::bt::main']->
      Class['pulsar::service::cd::init']->              Class['pulsar::service::cd::main']->
      Class['pulsar::service::epcc::init']->            Class['pulsar::service::epcc::main']->
      Class['pulsar::service::file::init']->            Class['pulsar::service::file::main']->
      Class['pulsar::service::guest::init']->           Class['pulsar::service::guest::main']->
      Class['pulsar::service::infrared::init']->        Class['pulsar::service::infrared::main']->
      Class['pulsar::service::nat::init']->             Class['pulsar::service::nat::main']->
      Class['pulsar::service::newsyslog::init']->       Class['pulsar::service::newsyslog::main']->
      Class['pulsar::service::ntp::init']->             Class['pulsar::service::ntp::main']->
      Class['pulsar::service::print::sharing::init']->  Class['pulsar::service::print::sharing::main']->
      Class['pulsar::service::samba::init']->           Class['pulsar::service::samba::main']->
      Class['pulsar::service::screen::init']->          Class['pulsar::service::screen::main']->
      Class['pulsar::service::spctl::init']->           Class['pulsar::service::spctl::main']->
      Class['pulsar::service::ssh::config::init']->     Class['pulsar::service::ssh::config::main']->
      Class['pulsar::service::ssh::keys::init']->       Class['pulsar::service::ssh::keys::main']->
      Class['pulsar::service::web::init']->             Class['pulsar::service::web::main']->
      Class['pulsar::service::wol::init']->             Class['pulsar::service::wol::main']->
      Class['pulsar::service::xgrid::init']->           Class['pulsar::service::xgrid::main']->
      Class['pulsar::user::dotfiles::init']->           Class['pulsar::user::dotfiles::main']->
      Class['pulsar::user::duplicate::init']->          Class['pulsar::user::duplicate::main']->
      Class['pulsar::user::lockout::init']->            Class['pulsar::user::lockout::main']->
      Class['pulsar::user::netrc::init']->              Class['pulsar::user::netrc::main']->
      Class['pulsar::user::path::init']->               Class['pulsar::user::path::main']->
      Class['pulsar::user::rhosts::init']->             Class['pulsar::user::rhosts::main']->
      Class['pulsar::user::root::init']->               Class['pulsar::user::root::main']->
      Class['pulsar::user::super::init']->              Class['pulsar::user::super::main']->
      Class['pulsar::exit']
    }
  }
}
