# This is start of our puppet configuration

class {'vm-config':} 

# executes apt-get update before any package install
exec { 'apt-get update':
  command => '/usr/bin/apt-get update'
}
Exec['apt-get update'] -> Package <| |>

# required packages for statedecoded
package {['vim', 
	 'build-essential',
	 'tidy',
	 'zip',
	 'git',
	 ]:
     ensure => present 
}

class { 'apache': 
	admin_email => "nskelsey@gmail.com",
}

# PHP dependencies
class { 'php': }

php::module { 'php5-mysql': }
php::module { 'php5-cli': }
php::module { 'php5-curl': }
php::module { 'php5-intl': }
php::module { 'php5-mcrypt': }
php::module { 'php5-mysqlnd': }
php::module { 'php5-tidy': }

class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}

php::ini { 'php':
  value   => ['date.timezone = "America/New_York"'],
  target  => 'php.ini',
  service => 'apache',
}

# xdebug for debuging php
class { 'xdebug':
  service => 'apache',
}

xdebug::config { 'cgi':
  remote_autostart => '0',
  remote_port      => '9000',
}
xdebug::config { 'cli':
  remote_autostart => '0',
  remote_port      => '9000',
}

