# pulsar::service::postgresql
#
# Turn off postgresql if not required
# Recommend removing this from base install as it slows down patching significantly
#.

# Requires fact: pulsar_systemservices

class pulsar::service::postgresql::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::postgresql": }
    }
  }
}

class pulsar::service::postgresql::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          $service_list = [
            'svc:/application/database/postgresql_83:default_32bit',
            'svc:/application/database/postgresql_83:default_64bit',
            'svc:/application/database/postgresql:version_81',
            'svc:/application/database/postgresql:version_82',
            'svc:/application/database/postgresql:version_82_64bit'
          ]
          disable_service { $service_list: }
        }
      }
      if $kernel == "Linux" {
        disable_service { "postgresql": }
      }
    }
  }
}
