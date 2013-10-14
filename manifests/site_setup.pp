
# a bare bones class for representing the configuration of the statedecoded
class statedecoded (
    $home = '/var/www/statedecoded',
    $apache_user = "www-data",
) {
    File {
        owner => $apache_user,
    }

    file { "${statedecoded_home}":
        ensure => directory,
        # need owner
        before => [File['php_includes'], File['htdocs'], File['solr_home']],
    } 

    file {"htdocs":
        name => "${statedecoded_home}/htdocs",
        ensure => directory,
        recurse => true,
        purge => true,
        source => "/vagrant/src/htdocs",
        mode => '0644'
    } 

    # solr install
    file {"solr_home":
        name => "${home}/solr_home",
        ensure => directory,
        recurse => true,
        purge => true,
        source => "/vagrant/src/solr_home",
        mode => '0644',
    } 

    file { "php_includes":
        name => "${statedecoded_home}/includes",
        ensure => directory,
        recurse => true,
        purge => true,
        source => "/vagrant/src/includes",
        mode => '0644'
    } ->

    file {'config.inc.php':
        ensure => present, 
        name   => "${home}/includes/config.inc.php",
        mode   => '0644',
        source => "${home}/includes/config-sample.inc.php",
    } ->
    
    file {"${home}/includes/class.State.php":
        ensure => present,
        mode   => '0644',
        source => "${home}/includes/class.State-sample.inc.php"
    }

}


