import 'site_setup.pp'

#global vars
$statedecoded_home = "/var/www/statedecoded"
# these are refrences to the variables in config-sample.inc.php
# if you change these here make sure they there as well
$mysql_user = "username"
$mysql_password = "password"
$mysql_db = "statedecoded"

# executes apt-get update before any package install
exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
}
Exec['apt-get update'] -> Package <| |>

# required packages for statedecoded
package {[
	 'build-essential',
	 'tidy',
	 'zip',
	 'git',
	 ]:
     ensure => present 
}

# pacakges that are unessecary but useful for development
package {[
     'vim',
     'curl',
     'lynx',
    ]:
    ensure => present
} ->
# adds some syntax highlighting/changes bash prompt
class {'vm-config':} 



class { 'apache': 
	admin_email => "nskelsey@gmail.com",
    statedecoded_home => $statedecoded_home,
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

# Finally we configure as much statedecoded as we can!
class { "statedecoded":
    home    => $statedecoded_home,
    require => [Class['apache'], Class['mysql'], Class['php']],
} ->

package { 'default-jdk': 
    ensure => 'installed',
} ->

# We have to install solr last since it needs a working solr home
class { "solr::jetty":
    solr_home => "${statedecoded_home}/solr_home"
}


