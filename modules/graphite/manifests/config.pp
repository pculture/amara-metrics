# Class graphite::config
#
# The config for the graphite server config goes here
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  This should not be used directly see the main module
# 
# (c) Copyright John Cooper - Licenced Under GPL Version 3
# [Remember: No empty lines between comments and class definition]
class graphite::config {
  $user    = $graphite::params::user
  $group   = $graphite::params::group
  $instdir = $graphite::params::instdir
  $logdir  = $graphite::params::logdir
  $webapp  = $graphite::params::webapp
  $confdir = $graphite::params::confdir
  $storedir= $graphite::params::storedir
  $wwwuser = $graphite::params::wwwuser

  file {"$confdir":
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
  }
  
  file {"${confdir}/aggregation-rules.conf":
    content => template('graphite/aggregation-rules.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File[$confdir],
  }
  file {"${confdir}/carbon.amqp.conf":
    content => template('graphite/carbon.amqp.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File[$confdir],
  }
  file {"${confdir}/carbon.conf":
    content => template('graphite/carbon.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File[$confdir],
  }
  file {"${confdir}/dashboard.conf":
    content => template('graphite/dashboard.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File[$confdir],
  }
  file {"${webapp}/graphite.wsgi":
    content => template('graphite/graphite.wsgi.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }
  file {"${confdir}/graphTemplates.conf":
    content => template('graphite/graphTemplates.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File[$confdir],
  }
  file {"${confdir}/local_settings.py":
    content => template('graphite/local_settings.py.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File[$confdir],
    notify  => Service['apache2'],
  }
  file {"${webapp}/graphite/local_settings.py":
    ensure  => link,
    target  => "${confdir}/local_settings.py",
  }
  file {"${confdir}/relay-rules.conf":
    content => template('graphite/relay-rules.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File[$confdir],
  }
  file {"${confdir}/rewrite-rules.conf":
    content => template('graphite/rewrite-rules.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File[$confdir],
  }
  file {"${confdir}/storage-schemas.conf":
    content => template('graphite/storage-schemas.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File[$confdir],
  }

  # Setup the database
  exec {'graphite-install-db':
    environment => ["PYTHONPATH=${webapp}:${instdir}/whisper"],
    cwd         => $instdir,
    user        => $wwwuser,
    command     => "/usr/bin/python $webapp/graphite/manage.py syncdb --noinput",
    require => [File["$storedir/graphite.db"]]
  }


}
