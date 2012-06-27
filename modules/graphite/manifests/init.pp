# Class: graphite
#
# A module for installing and configuring a graphite server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
# 
#   include graphite
#   graphite::apache{ 'graphite.yoursite.com': }
#
# (c) Copyright John Cooper - Licenced Under GPL Version 3
# [Remember: No empty lines between comments and class definition]
class graphite {
  include graphite::params  
  include graphite::install 
  include graphite::config
  include graphite::service

  Class["graphite::params"] ->
  Class["graphite::install"] ->
  Class["graphite::config"] ->
  Class["graphite::service"] 
}
