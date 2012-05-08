class aptitude {
  exec { "aptitude-update":
    command => "/usr/bin/apt-get update",
    refreshonly => false;
  }

  cron { "aptitude-update":
    command => "/usr/bin/aptitude update",
    user    => root,
    hour    => 23,
    minute  => 59;
  }
}
