# Type: graphite::apache
# (c) Copyright John Cooper - Licenced Under GPL Version 3
#
# add a site serving graphite,
# This is a bit hacky as you probably want to set some thing up yourself
# but this will do for testing
define graphite::apache {
  $instdir    = $graphite::params::instdir
  $servername = $title
  # Install
  package {['apache2',
            'libapache2-mod-wsgi']:
    ensure => installed,
  }

  # Config
  file {'/etc/apache2/mods-enabled/wsgi.conf':
    ensure  => link,
    target  => '/etc/apache2/mods-available/wsgi.conf',
    notify  => Service['apache2'],
    require => Package['libapache2-mod-wsgi']
  }
  file {'/etc/apache2/mods-enabled/wsgi.load':
    ensure  => link,
    target  => '/etc/apache2/mods-available/wsgi.load',
    notify  => Service['apache2'],
    require => Package['libapache2-mod-wsgi']
  }
  file {'/etc/apache2/sites-enabled/graphite.conf':
    ensure  => link,
    target  => '/etc/apache2/sites-available/graphite.conf',
    notify  => Service['apache2'],
    require => Package['apache2']
  }
  file {'/etc/apache2/sites-available/graphite.conf':
    content => template('graphite/apache/graphite.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
    notify  => Service['apache2'],
    require => Package['apache2']
  }
  file {"${instdir}/storage/log/webapp":
    owner   => 'www-data',
    group   => 'www-data',
    require => [Package['apache2'],Class['graphite::install']],
  }
  file {"${instdir}/storage/index":
    ensure  => present,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => [Package['apache2'],Class['graphite::install']],
  }

  # Service
  service { 'apache2':
    ensure  => running,
    require => [
        Package['apache2'],
        File["${instdir}/storage/log/webapp"],
        File["${instdir}/storage/index"],
    ],
  }


}
