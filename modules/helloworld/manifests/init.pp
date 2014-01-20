class helloworld {
  include nodejs

#Add the python-software-properties package to install ppa
  package { 'python-software-properties':
    ensure => latest,
  }

  package { 'npm':
    ensure => latest,
  }


#Add the repo to get a newer nodejs
apt::ppa { 'ppa:richarvey/nodejs': }

# Install nodejs and packages
  package { 'express':
    ensure   => present,
    provider => 'npm',
    require => Package['npm'],
  }

}

