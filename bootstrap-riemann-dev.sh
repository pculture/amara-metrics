#!/usr/bin/env bash

set -e

# Get/update Leiningen
sudo wget https://raw.github.com/technomancy/leiningen/stable/bin/lein -O /usr/bin/lein
sudo chmod a+x /usr/bin/lein

# Make sure we have a javac
sudo aptitude install openjdk-6-jdk

cd riemann

lein deps
lein javac

echo "Riemann is ready to go.  To start the server:"
echo
echo "cd ./riemann"
echo "lein run ../riemann.config.clj"
