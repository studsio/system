
# Change here for more or less memory/cores
VM_MEMORY=8192
VM_CORES=4

Vagrant.configure('2') do |config|
	config.vm.box = 'debian/jessie64'

  # share host studs/ dir
  config.vm.synced_folder "../", "/home/vagrant/studs"

  # better job of keeping time synced with host
  config.vm.provider 'virtualbox' do |vb|
     vb.customize ["guestproperty", "set", :id,
       "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000]
  end

	config.vm.provider :vmware_fusion do |v, override|
		v.vmx['memsize'] = VM_MEMORY
		v.vmx['numvcpus'] = VM_CORES
	end

	config.vm.provider :virtualbox do |v, override|
		v.memory = VM_MEMORY
		v.cpus = VM_CORES
	end

	config.vm.provision 'shell' do |s|
		s.inline = 'echo Setting up machine name'

		config.vm.provider :vmware_fusion do |v, override|
			v.vmx['displayname'] = "Studs"
		end

		config.vm.provider :virtualbox do |v, override|
			v.name = "Studs"
		end
	end

end
