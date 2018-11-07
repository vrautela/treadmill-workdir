## GETTING STARTED WITH TREADMILL ##

1. Install VirtualBox from https://www.virtualbox.org/wiki/Downloads and Vagrant from https://www.vagrantup.com/downloads.html

2. Git clone https://github.com/craighurley/vagrant-cloud-init onto your machine (this will get you set up with cloud-init 0.7.9)

3. Edit boxes.yaml to have Dev, LDAP and ZK VMs (also change provision fields)

4. Create user-data.yaml files for Dev, LDAP and ZK (and clear meta-data file)
   Run vagrant up dev, you should now have a working Dev VM

5. Include the following in cloud-init-ldap.sh: 
   /sbin/semanage  port -a -t ldap_port_t -p tcp 22389
   /sbin/semanage  port -a -t ldap_port_t -p udp 22389
   
6. Include the following in user-data-ldap.yaml
   packages:
     - openldap
     - openldap-clients 
     - openldap-servers
	 
   Afterwards, run vagrant up ldap, you should now have a working LDAP VM
	 
7. Include the following in Vagrantfile:
   config.vm.network 'private_network', type:'dhcp'

8. Install Git on Dev VM and git clone https://github.com/Morgan-Stanley/treadmill-deploy

9. Run make rpm under s6 and zookeeper

10. Create local yum repo (elaborate on this, include links and actually add the rpms to the yum repo)

11. Include the following in user-data-zk.yaml:
    packages:
      - [zookeeper, 3.4.12-5] 
      - [skarnet, 2.7.1.1]
	 
11. On Dev machine run python -m SimpleHTTPServer (if python version is >= 3.0, then run python -m http.server), 
    this will create a web server that you can access by typing in 127.0.0.1:8000
	
12. While server is running, run vagrant up zk
    You should now have a working Zookeeper VM
	
13.

. Download pip and virtualenv

. Get Python>=3.4


    