Amara metrics server
====================

This repository contains Puppet scripts to provision a metrics server.

It installs two main pieces of software:

* Riemann
* Graphite

Running
=======

    $ git clone git://github.com/pculture/amara-metrics.git
    $ cd amara-metrics
    $ vagrant up

Add `graphite.example.com 10.10.10.44` to your host's `/etc/hosts` file.  Open
your browser to `http://graphite.example.com`.

More
====

To learn more about how this works, please have a look at the very detail blog
post [Tracking Application-Level Metrics in Amara][1] on the Amara blog.


[1]: http://labs.amara.org/2012-07-16-metrics.html
