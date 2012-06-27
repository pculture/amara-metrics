Vagrant::Config.run do |config|
  config.vm.host_name = "amara-metrics"
  config.vm.box = "lucid32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

  config.vm.network :hostonly, "10.10.10.44"

  # config.vm.network :bridged
  # config.vm.forward_port 80, 7777
  config.vm.forward_port 22, 2223

  config.vm.share_folder "metrics", "/opt/metrics", "."

  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/metrics", "1"]

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "vagrant.pp"
    puppet.options = ["--verbose", "--node_name_value", "vagrant"]
  end
end
