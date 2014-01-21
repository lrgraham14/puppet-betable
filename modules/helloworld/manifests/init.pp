class helloworld {
  include nodejs

#Add the repo to get a newer nodejs
  apt::ppa { 'ppa:richarvey/nodejs': }

#Add the python-software-properties package to install ppa
  package { 'python-software-properties':
    ensure => latest,
  }

  package { 'npm':
    ensure => latest,
  }

# Install nodejs and packages
  package { 'express':
    ensure   => present,
    provider => 'npm',
    require => Package['npm'],
  }

##create the /helloworld directory
  file { "/helloworld":
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
  # Add upstart for helloworld
  file { "/etc/init/helloworld.conf":
    ensure => "present",
    source => 'puppet:///modules/helloworld/helloworld.conf'
  }

  #snsure the service is running
  service { "helloworld":
    enable => true,
    ensure => running,
  }

}

