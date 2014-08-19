# pulsar::fs::home::owner
#
# Check That Users Are Assigned Home Directories
# Check That Defined Home Directories Exist
# Check User Home Directory Ownership
#
# The /etc/passwd file defines a home directory that the user is placed in upon
# login. If there is no defined home directory, the user will be placed in "/"
# and will not be able to write any files or have local environment variables set.
# All users must be assigned a home directory in the /etc/passwd file.
#
# Users can be defined to have a home directory in /etc/passwd, even if the
# directory does not actually exist.
# If the user's home directory does not exist, the user will be placed in "/"
# and will not be able to write any files or have local environment variables set.
#
# The user home directory is space defined for the particular user to set local
# environment variables and to store personal files.
# Since the user is accountable for files stored in the user home directory,
# the user must be the owner of the directory.
#.

# Requires fact: pulsar_invalidhomeowners
# Requires fact: pulsar_invalidhomedirs
# Requires fact: pulsar_defaulthome

class pulsar::fs::home::owner::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel =~ /SunOS|Linux|AIX|FreeBSD/ {
      init_message { "pulsar::fs::home::owner": }
    }
  }
}

class pulsar::fs::home::owner::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel =~ /SunOS|Linux|AIX|FreeBSD/ {
      check_invalid_home_owners { "pulsar::fs::home::owner::ownership": }
      check_invalid_home_dirs { "pulsar::fs::home::owner::exists": }
    }
  }
}
