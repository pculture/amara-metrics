Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

class vagrant {
  $projectdir = "/opt/metrics"

  group { "vagrant": ensure => "present"; } ->
  user { "vagrant": ensure => "present"; } ->

  class { "base": }
}

class { "vagrant": }
