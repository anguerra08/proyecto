Vagrant.configure("2") do |config|   
   config.vm.define :servidorHa1 do |servidorHa1|
   servidorHa1.vm.box = "bento/ubuntu-20.04"
   servidorHa1.vm.network :private_network, ip: "192.168.100.2"   
   servidorHa1.vm.hostname = "servidorHa1"      
   servidorHa1.vm.provision :shell, path: "Scripts/script.sh"
   servidorHa1.vm.provision :shell, path: "Scripts/script_haproxy.sh"
   end   
   config.vm.define :servidorweb1 do |servidorweb1|
   servidorweb1.vm.box = "bento/ubuntu-20.04"
   servidorweb1.vm.network :private_network, ip: "192.168.100.3"   
   servidorweb1.vm.hostname = "servidorweb1"   
   servidorweb1.vm.provision :shell, path: "Scripts/script_webs.sh"
   servidorweb1.vm.provision :shell, path: "Scripts/script_web1.sh" 
   end   
   config.vm.define :servidorweb2 do |servidorweb2|
   servidorweb2.vm.box = "bento/ubuntu-20.04"
   servidorweb2.vm.network :private_network, ip: "192.168.100.4"   
   servidorweb2.vm.hostname = "servidorweb2"   
   servidorweb2.vm.provision :shell, path: "Scripts/script_webs.sh"
   servidorweb2.vm.provision :shell, path: "Scripts/script_web2.sh" 
   end   
   config.vm.define :servidorweb1bck do |servidorweb1bck|
   servidorweb1bck.vm.box = "bento/ubuntu-20.04"
   servidorweb1bck.vm.network :private_network, ip: "192.168.100.5"   
   servidorweb1bck.vm.hostname = "servidorweb1bck"   
   servidorweb1bck.vm.provision :shell, path: "Scripts/script_webs.sh"
   servidorweb1bck.vm.provision :shell, path: "Scripts/script_web1bck.sh" 
   end   
   config.vm.define :servidorweb2bck do |servidorweb2bck|
   servidorweb2bck.vm.box = "bento/ubuntu-20.04"
   servidorweb2bck.vm.network :private_network, ip: "192.168.100.6"   
   servidorweb2bck.vm.hostname = "servidorweb2bck"   
   servidorweb2bck.vm.provision :shell, path: "Scripts/script_webs.sh"
   servidorweb2bck.vm.provision :shell, path: "Scripts/script_web2bck.sh" 
   end   
end 