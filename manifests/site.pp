import "nodes"

Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }

#--------------------------------------------
node graphite inherits graphitenode {
  $projectdir = "/etc/puppet.amara-metrics"
  
  graphite::apache{ "graphite.universalsubtitles.org": }
}

