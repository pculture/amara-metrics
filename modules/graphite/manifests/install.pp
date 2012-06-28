
  # Wrapper around installing pip modules
  # Use with the pip module name to install
  # and testmodule is what is use to test if it is already
  # installed
  define pipinstall () {
    exec {$title:
      command => "/usr/bin/pip install ${title}",
      unless  => "/usr/bin/pip freeze | grep  ${title}",
      require => Package['python-pip'],
    }
  }


# Class: graphite::install
#
# Install the required packages for the graphite server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
# 
# This class should not be called directly; use the main class.
#
# (c) Copyright John Cooper - Licenced Under GPL Version 3
# [Remember: No empty lines between comments and class definition]
class graphite::install {
  $instdir = $graphite::params::instdir
  $storedir= $graphite::params::storedir
  $user    = $graphite::params::user
  $wwwuser = $graphite::params::wwwuser

  user {$user:
    ensure => present,
    system => true,
    home   => $instdir,
  }

  package { ['python-django',
             'python-twisted',
             'python-cairo',
             'python-pip',
             'python-django-tagging',
             ]:
    ensure => installed,
  }

  pipinstall {['whisper',
               'carbon',
               'graphite-web']:
  }

  file {"${instdir}":
    ensure => directory,
    mode  => '0755',
  } ->
  file {"$storedir":
    ensure => directory,
    owner => $wwwuser,
    group => $wwwuser,
    mode  => '0755',
  } ->
  file {"$storedir/graphite.db":
    ensure => present,
    owner => $wwwuser,
    group => $wwwuser,
    mode  => '0755',
  } ->
  file { "$storedir/whisper/":
    ensure => directory,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    require => Pipinstall['whisper'],
  }

  # Install carbon-cache init service
  file { '/etc/init.d/carbon-cache':
    content => template('graphite/carbon-cache.init.erb'),
    owner   => root,
    group   => root,
    mode    => '0744',
    require => Pipinstall['carbon'],
  }
}
