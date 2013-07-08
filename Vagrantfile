Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "192.168.56.101"
    config.vm.network :forwarded_port, guest: 80, host: 8080 
    config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", "statedecoded"]
  end

  
  config.vm.synced_folder "./statedecoded/", "/var/www", id: "vagrant-root" 
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.options = ['--verbose']
  end

  # Install the required plugins
  def require_plugin plugin
    puts `cd ~/ >/dev/null && vagrant plugin install #{plugin}` unless `cd ~/ && vagrant plugin list`.chomp.split("\n").select{|x| x.include? plugin}.length > 0
  end
  
  require_plugin = "vagrant-hostsupdater"

  config.vm.hostname = "statedecoded.dev"
  config.vm.network :private_network, :ip => "192.168.56.101"
  config.hostsupdater.aliases = %w{www.statedecoded.dev}
  config.hostsupdater.remove_on_suspend = true

end
