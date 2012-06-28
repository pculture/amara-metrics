
#--------------------------------------------
# Base
node basenode {
  class { "base": }
}

#--------------------------------------------
# Graphite servers

node graphitenode inherits basenode {
  include graphite
  class { "riemann": } <- Package['openjdk-6-jre']
}
