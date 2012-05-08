# Class: graphite::params
# 
# Global configuration variables for the graphite server.
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
class graphite::params {
  case $operatingsystem {
    /Ubuntu|debian/: {
      $user    = 'graphite'
      $group   = 'graphite'
      $instdir = '/opt/graphite/'
      $wwwuser = 'www-data'
    }
    default: {
      fail("Operatingsystem, $operatingsystem, is not supported by the graphite module")
    }
  }
}
