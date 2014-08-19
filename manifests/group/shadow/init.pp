# pulsar::group::shadow
#
# The shadow group allows system programs which require access the ability to
# read the /etc/shadow file. No users should be assigned to the shadow group.
# Any users assigned to the shadow group would be granted read access to the
# /etc/shadow file. If attackers can gain read access to the /etc/shadow file,
# they can easily run a password cracking program against the hashed passwords
# to break them. Other security information that is stored in the /etc/shadow
# file (such as expiration) could also be useful to subvert additional user
# accounts.
#
# Refer to Section(s) 13.20 Page(s) 168-9 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_shadowgroupmembers

class pulsar::group::shadow::init {
  if $pulsar_modules =~ /group|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::group::shadow": }
    }
  }
}

class pulsar::group::shadow::main {
  if $pulsar_modules =~ /group|full/ {
    if $kernel == "Linux" {
      check_shadow_group_members { "pulsar::group::shadow": }
    }
  }
}
