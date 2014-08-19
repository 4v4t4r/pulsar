# pulsar::service::opengl
#
# OpenGL. Not required unless running a GUI. Not required on a server.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::opengl::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        init_message { "pulsar::service::opengl": }
      }
    }
  }
}

class pulsar::service::opengl::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        disable_service { "svc:/application/opengl/ogl-select:default": }
      }
    }
  }
}
