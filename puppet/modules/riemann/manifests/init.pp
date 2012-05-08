class riemann {
    $version = "0.1.1-SNAPSHOT"

    file { "/opt/riemann.deb":
        mode => 0644,
        owner => root,
        group => root,
        source => "puppet:///modules/riemann/riemann_${version}.deb",
        alias => "riemann-deb",
    }
    exec { "riemann-install":
        cwd => "/opt",
        command => "dpkg -i riemann.deb",
        refreshonly => true,
        subscribe => File["riemann-deb"],
    } ->
    file { "/etc/init/riemann.conf":
        mode => 0644,
        owner => root,
        group => root,
        source => "puppet:///modules/riemann/riemann.conf",
        alias => "riemann-upstart",
    } ->
    service { "riemann":
        ensure => running,
        provider => upstart,
        subscribe => [
            Exec["riemann-install"],
            File["riemann-upstart"],
            Service["carbon-cache"],
        ],
    }
}
