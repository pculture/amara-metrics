# Type: graphite::apache
# (c) Copyright John Cooper - Licenced Under GPL Version 3
#
# add a site serving graphite,
# This is a bit hacky as you probably want to set some thing up yourself
# but this will do for testing
define graphite::apache {
  $instdir    = $graphite::params::instdir
  $logdir     = $graphite::params::logdir
  $webapp     = $graphite::params::webapp
  $confdir    = $graphite::params::confdir
  $storedir   = $graphite::params::storedir
  $servername = $title
  $logdir_apache = "/var/log/apache2/${servername}"

  # Install
  package {['apache2',
            'libapache2-mod-wsgi',
            'cronolog']:
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
  file {"/etc/apache2/sites-enabled/$servername":
    ensure  => link,
    target  => "/etc/apache2/sites-available/$servername",
    notify  => Service['apache2'],
    require => Package['apache2']
  }
  file {"/etc/apache2/sites-available/$servername":
    content => template('graphite/apache/graphite.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service['apache2'],
    require => Package['apache2']
  }
  file {$logdir_apache:
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    require => [Package['apache2'],Class['graphite::install']],
    notify  => Service['apache2'],
  }
  file {"$logdir/access.log":
    ensure  => link,
    target  => "$logdir_apache/access.log",
    require => File[$logdir_apache]
  }
  file {"$logdir/error.log":
    ensure  => link,
    target  => "$logdir_apache/error.log",
    require => File[$logdir_apache]
  }
  file {"$storedir/index":
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
        File[$logdir_apache],
        File["$storedir/index"],
    ],
  }


}
