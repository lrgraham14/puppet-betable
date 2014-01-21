class prepare {
  class { 'apt': }
  apt::ppa { 'ppa:richarvey/nodejs': }
}

class helloworld {
  include prepare
  include nodejs

#Add the repo to get a newer nodejs
#  apt::ppa { 'ppa:richarvey/nodejs': }

#Add the python-software-properties package to install ppa
  package { 'python-software-properties':
    ensure => latest,
    before => Class['prepare'],
  }

  package { 'npm':
    ensure => latest,
    before => Class['prepare'],
  }

# Install nodejs and packages
  package { 'express':
    ensure   => present,
    provider => 'npm',
#    before => Apt::Ppa['ppa:richarvey/nodejs'],
    before => [Package['npm'],Class['prepare']],
  }

##create the /helloworld directory
  file { ["/helloworld","/helloworld/node_modules"]:
    ensure => "directory",
  }
  file { "/helloworld/helloworld.js":
    ensure => "present",
    source => 'puppet:///modules/helloworld/helloworld.js'
  }
  file { "/helloworld/package.json":
    ensure => "present",
    source => 'puppet:///modules/helloworld/package.json'
  }
  file { '/helloworld/node_modules/express':
    ensure => 'link',
    target => '/usr/lib/node_modules/express',
    require => File["/helloworld/node_modules"],
  }
  # Add upstart for helloworld
  file { "/etc/init/helloworld.conf":
    ensure => "present",
    source => 'puppet:///modules/helloworld/helloworld.conf'
  }

  #snsure the service is running
  service { "helloworld":
    enable => true,
    ensure => running,
    require => File["/etc/init/helloworld.conf"],
  }

}

