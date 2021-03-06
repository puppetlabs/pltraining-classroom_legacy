# Create a few scripts for gathering metrics from a running server.
# Requires java_args => {"Dcom.sun.management.jmxremote":"=true","Dcom.sun.management.jmxremote.port":"=9010","Dcom.sun.management.jmxremote.authenticate":"=false","Dcom.sun.management.jmxremote.local.only":"=false","Dcom.sun.management.jmxremote.ssl":"=false"}
class classroom_legacy::master::metrics {
  assert_private('This class should not be called directly')

  File {
    owner => 'root',
    group => 'root',
    mode  => '0777',
  }

  # these will only work once the machine has been promoted to a master
  if defined('$pe_server_version') {
    package { ['jmx', 'table_print']:
      ensure   => present,
      provider => puppetserver_gem,
    }
  }

  file { '/usr/local/bin/puppetserver_compiles':
    ensure => file,
    source => 'puppet:///modules/classroom_legacy/metrics/puppetserver_compiles',
  }

  # JMX wrapper script that calls the actual metrics in the context of the JVM
  file { '/usr/local/bin/puppetserver_metrics':
    ensure => file,
    source => 'puppet:///modules/classroom_legacy/metrics/puppetserver_metrics',
  }

  # the individual JMX metrics called by the wrapper script
  file { '/usr/local/bin/metrics':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/classroom_legacy/metrics/metrics',
  }
}
