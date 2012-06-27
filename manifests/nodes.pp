
#--------------------------------------------
# Base
# TODO: Move riemann from basenode to graphitenode
node basenode {
  class { "base": }
}

#--------------------------------------------
# Graphite servers

node graphitenode inherits basenode {
  include graphite
}
