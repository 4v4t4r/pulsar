# pulsar::security::stack
#
# Stack Protection
#
# Checks for the following values in /etc/system:
#
# set noexec_user_stack=1
# set noexec_user_stack_log=1
#
# Buffer overflow exploits have been the basis for many highly publicized
# compromises and defacements of large numbers of Internet connected systems.
# Many of the automated tools in use by system attackers exploit well-known
# buffer overflow problems in vendor-supplied and third-party software.
#
# Enabling stack protection prevents certain classes of buffer overflow
# attacks and is a significant security enhancement. However, this does not
# protect against buffer overflow attacks that do not execute code on the
# stack (such as return-to-libc exploits).
#
# Refer to Section(s) 3.2 Page(s) 26-7 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 3.3 Page(s) 62-3 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_system

class pulsar::security::stack::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::security::stack": }
    }
  }
}

class pulsar::security::stack::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel == "SunOS" {
      add_line_to_file { "set noexec_user_stack=1": path => "system" }
      add_line_to_file { "set noexec_user_stack_log=1": path => "system" }
    }
  }
}
