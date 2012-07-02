# Class: graphite::service
#
# Graphite services
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
class graphite::service {
  service {'carbon-cache':
    enable    => true,
    ensure    => running,
    provider  => "upstart",
  }
}
