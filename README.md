1. Install VirtualBox from https://www.virtualbox.org/wiki/Downloads and Vagrant from https://www.vagrantup.com/downloads.html

2. Git clone https://github.com/craighurley/vagrant-cloud-init (this will get you set up with cloud-init 0.7.9) onto your machine

3. Edit boxes.yaml to have Dev, LDAP and ZK VMs (also change provision fields)

4. Create user-data.yaml files for Dev, LDAP and ZK (and clear meta-data file)

5. Include the following in cloud-init-ldap.sh: 
   /sbin/semanage  port -a -t ldap_port_t -p tcp 22389
   /sbin/semanage  port -a -t ldap_port_t -p udp 22389
   
6. Edit user-data-ldap.yaml
   packages:
     - openldap
     - openldap-clients 
     - openldap-servers

7. Include the following in Vagrantfile:
   config.vm.network 'private_network', type:'dhcp'

8. Install Git on Dev VM and git clone https://github.com/Morgan-Stanley/treadmill-deploy

9. Run make rpm under s6 and zookeeper

10. Create local yum repo
	 
11.  
    