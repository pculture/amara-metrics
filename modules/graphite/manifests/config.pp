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
  $webapp  = $graphite::params::webapp
  $wwwuser = $graphite::params::wwwuser

  file {"${instdir}/conf/aggregation-rules.conf":
    content => template('graphite/aggregation-rules.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/carbon.amqp.conf":
    content => template('graphite/carbon.amqp.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/carbon.conf":
    content => template('graphite/carbon.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/dashboard.conf":
    content => template('graphite/dashboard.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/graphite.wsgi":
    content => template('graphite/graphite.wsgi.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/graphTemplates.conf":
    content => template('graphite/graphTemplates.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/relay-rules.conf":
    content => template('graphite/relay-rules.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/rewrite-rules.conf":
    content => template('graphite/rewrite-rules.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/storage-schemas.conf":
    content => template('graphite/storage-schemas.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }

  # Setup the database
  exec {'graphite-install-db':
    environment => ["PYTHONPATH=${webapp}:${instdir}/whisper"],
    cwd         => $instdir,
    user        => $wwwuser,
    command     => "/usr/bin/python $webapp/graphite/manage.py syncdb --noinput",
    require => [File["${instdir}/storage/graphite.db"]]
  }


}
