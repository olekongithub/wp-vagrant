Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"
  config.vm.network "private_network", ip: "192.168.133.10"
  config.vm.network :forwarded_port, guest: 22, host: 2222, id: 'ssh', auto_correct: true

  # Configuration for Hosts Updater plugin. Modify this with your project's domain.
  config.vm.hostname = "readitforward.local"
  config.hostsupdater.aliases = ["www.readitforward.local"]
  config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=777", "fmode=666"]

  config.vm.provider "virtualbox" do |v|
          v.memory = 1024
          v.cpus = 2
  end

  config.vm.provision :shell, path: "./provision/bootstrap.sh"
end
