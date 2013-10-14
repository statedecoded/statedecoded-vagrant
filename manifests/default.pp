#global vars
$statedecoded_home = "/var/www/statedecoded"
$mysql_user = "statedecoded"
$mysql_db = "statedecoded"
$mysql_password = "changeMe"

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

# MySQL setup
# goal is to setup a db and a user who has access
class { 'mysql':
    root_password => 'auto',
}

mysql::grant { 'statedecoded':
    mysql_privileges => 'ALL',
    mysql_password =>  $mysql_password,
    mysql_db => $mysql_db,
    mysql_user => $mysql_user,
}

# solr install
file {"solr_home":
    name => "${statedecoded_home}/solr_home",
    ensure => directory,
    recurse => true,
    purge => true,
    source => "/vagrant/src/solr_home",
    owner => 'root',
    mode => 644,
    require => Class['apache'],
} ->
package { 'default-jdk': 
    ensure => 'installed',
       } ->
class { "solr::jetty":
    solr_home => "${statedecoded_home}/solr_home"
}

