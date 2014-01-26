class helloworld {
  include nodejs

#Add the repo to get a newer nodejs
exec { "add-apt-repository ppa:richarvey/nodejs && apt-get update":
    path => "/bin:/sbin:/usr/bin:/usr/sbin",
    alias => "nodejs_repository",
    require => Package["python-software-properties"],
    creates => "/etc/apt/sources.list.d/richarvey-nodejs-precise.list",
    subscribe => Package["python-software-properties"],
}


#Add the python-software-properties package to install ppa
  package { ['python-software-properties','npm']:
    ensure => latest,
  }

# Install nodejs and packages
  package { 'express':
    ensure   => present,
    provider => 'npm',
    require => Exec['nodejs_repository'],
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

  #ensure the service is running
  service { "helloworld":
    enable => true,
    ensure => running,
    require => File["/etc/init/helloworld.conf"],
  }

  #Setup resolv.conf to point to google servers
  file { "/etc/resolv.conf":
    ensure => "present",
    source => 'puppet:///modules/helloworld/resolv.conf'
  }

  #Setup firewall to allow port 80 and 22
  firewall { '100 allow http acesss':
    port   => 80,
    proto  => tcp,
    action => accept,
  }
  firewall { '101 allow ssh acesss':
    port   => 22,
    proto  => tcp,
    action => accept,
  }

  firewall { "999 drop all other requests":
    action => "drop",
  }
}

