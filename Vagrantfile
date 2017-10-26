Vagrant.configure("2") do |config|
  ZFS_HOSTS=2
  (1..ZFS_HOSTS).each do |zfs|
    zfs_node_name = "zfs#{zfs}"
    config.vm.define zfs_node_name do |zfs_node|
      zfs_node.vm.box = "OracleZFS"
      #zfs_node.vm.network "private_network", ip: "192.168.47.#{100 + zfs}"
      zfs_node.vm.hostname = zfs_node_name
      zfs_node.vm.provider :virtualbox do |vbox|
          vbox.linked_clone = true
          vbox.name = zfs_node_name
      end
      if zfs == ZFS_HOSTS
          zfs_node.vm.provision :ansible do |ansible|
            ansible.limit = "all" # Connect to all machines
            ansible.playbook = "ozfs.yaml"
          end
      end
    end
  end
end
