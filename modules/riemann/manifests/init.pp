
define download_ignore_if_missing ($uri, $timeout = 300, $returns = 0) {
    exec {
        "download ignore if missing $uri":
            require => Package[ "wget" ],
            onlyif  => "wget -q '$uri' -O $name || rm -f $name",
            command => "/bin/true",
            timeout => $timeout,
            returns => $returns,
            creates => $name,
    }
}

class riemann {
    $version = "0.1.1-SNAPSHOT"
    $instdir = '/opt'
    $debfile = "riemann-${version}.deb"

    download_ignore_if_missing { "/tmp/$debfile":
        uri => "http://aphyr.com/riemann/riemann_${version}.deb",
        before => File["$instdir/$debfile"],
    } 

    file { "$instdir/$debfile":
        mode => 0644,
        owner => root,
        group => root,
        source => ["file:///tmp/$debfile",
                   "puppet:///modules/riemann/riemann_${version}.deb"],
        alias => "riemann-deb",
    }
    
    file { "/etc/riemann/riemann.config":
        mode   => 0644,
        owner  => root,
        group  => root,
        source => "puppet:///modules/riemann/riemann.config",
        require => Exec['riemann-install'],
        notify => Service['riemann'],
    }

    exec { "riemann-install":
        cwd => "$instdir",
        command => "dpkg -i $debfile",
        refreshonly => true,
        subscribe => File["riemann-deb"],
    } ->
    # manual symlink to /lib/init/upstart-job for http://projects.puppetlabs.com/issues/14297
    file { '/etc/init.d/riemann':
        ensure  => link,
        target  => '/lib/init/upstart-job',
        alias   => "riemann-upstart-job"
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
        hasrestart => true,
        hasstatus => true,
        subscribe => [
            File["riemann-upstart-job"],
            Exec["riemann-install"],
            File["riemann-upstart"],
            Service["carbon-cache"],
        ],
    } ->
    exec { "cleanup" :
        command => "rm -f /tmp/$debfile",
    }
}
