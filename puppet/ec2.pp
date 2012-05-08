Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

class ec2 {
  $projectdir = "/opt/metrics"

  #group { "vagrant": ensure => "present"; } ->
  #user { "vagrant": ensure => "present"; } ->

  class { "base": }
}

class { "ec2": }
