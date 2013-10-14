class apache ($admin_email = "noone@nowhere",
              $statedecoded_home = "/var/www/statedecoded")  {

    $apache = '/etc/apache2'
    $sites_en = '/etc/apache2/sites-enabled'
    $sites_avail = '/etc/apache2/sites-available'
    $conf = "${sites_avail}/statedecoded.conf"

    file { "${conf}":
        ensure => file,
        content => template("apache/statedecoded.conf.erb"),
        owner => 'root',
        group => 'root',
        mode => 644,
    }

    file { "${sites_en}/statedecoded.conf":
        ensure => link,
        target => "${conf}",
    }

    file { "${sites_en}/":
        ensure => directory,
        purge  => true,
        recurse => true,
    }

    file { "${statedecoded_home}":
        ensure => directory,
        # need owner
    }

    $mod_rewrite = "${apache}/mods-enabled/rewrite.load"
        file { "${mod_rewrite}":
        ensure => link,
        target => "${apache}/mods-available/rewrite.load"
    }

    file { "php_includes":
        name => "${statedecoded_home}/includes",
        ensure => directory,
        recurse => true,
        purge => true,
        source => "/vagrant/src/includes",
        owner => 'root',
        mode => 644
    }

    file {"htdocs":
        name => "${statedecoded_home}/htdocs",
        ensure => directory,
        recurse => true,
        purge => true,
        source => "/vagrant/src/htdocs",
        owner => 'root',
        mode => 644
    }

    $apache_files = [File["${conf}"], File["${sites_en}/statedecoded.conf"], File["${sites_en}/"], 
		     File["${mod_rewrite}"], File['htdocs'], File['php_includes'], File["${statedecoded_home}"],]

    package { 'apache2':
        ensure => installed,
        provider => 'apt',
        before => $apache_files,
    }
    service { 'apache':
        name   => 'apache2',
        ensure => running,
        enable => true,
        subscribe => $apache_files,
        #need to specify owner
    }
}
