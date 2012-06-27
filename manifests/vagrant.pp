import "nodes"

Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

#--------------------------------------------
node vagrant inherits graphitenode {
  $projectdir = "/opt/metrics"
  
  group { "vagrant": ensure => "present"; } ->
  user  { "vagrant": ensure => "present"; } ->

  graphite::apache{ "graphite.example.com": }
}
