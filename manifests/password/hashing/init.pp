# pulsar::password::hashing
#
# Check that password hashing is set to SHA512.
#
# The SHA-512 algorithm provides much stronger hashing than MD5, thus providing
# additional protection to the system by increasing the level of effort for an
# attacker to successfully determine passwords.
#
# Refer to Section(s) 6.3.1 Page(s) 138-9 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.3.4 Page(s) 162-3 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.3.1 Page(s) 141-2 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requries fact: pulsar_authconfig

class pulsar::password::hashing::init {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /Ubuntu/ {
        init_message { "pulsar::password::hashing": }
      }
    }
  }
}

class pulsar::password::hashing::main {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /Ubuntu/ {
        check_authconfig { "pulsar::password::hashing::passlgo":
          param => "passalgo",
          value => "sha512",
          match => "password hashing algorithm is",
        }
      }
    }
  }
}

