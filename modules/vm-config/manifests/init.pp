class vm-config ($user_home = "/home/vagrant/") {

   file { "${user_home}.vim":
       ensure => directory,
       source   => 'puppet:///modules/vm-config/.vim',
       recurse => true,
   }

   file {"${user_home}.bash_aliases":
       ensure => file,
       source   => 'puppet:///modules/vm-config/.bash_aliases',
   }
}
