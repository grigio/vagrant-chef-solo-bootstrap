root      = File.expand_path("..", __FILE__)
solo_json = File.join(root, "solo.json")

Vagrant::Config.run do |config|

  config.vm.box = "precise32"

  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  config.vm.forward_port 22,   2222
  config.vm.forward_port 80,   8080
  config.vm.forward_port 3000, 3030
  config.vm.forward_port 9998, 9998
  config.vm.forward_port 5080, 5080 # Red5 HTTP
  config.vm.forward_port 1935, 1935 # Red5 RTMP[T]
  config.vm.network :hostonly, "22.22.22.22"

  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)

  #config.vm.provision :chef_solo do |chef|
  #  chef.cookbooks_path = "cookbooks"
  #  chef.json = JSON.parse(File.open(solo_json, &:read))
  #  chef.json["user"] = "vagrant"
  #  chef.json["run_list"].each do |recipe_name|
  #    chef.add_recipe recipe_name
  #  end
  #end

end
