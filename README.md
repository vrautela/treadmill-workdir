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
	
13. Download pip and virtualenv
    Get Python>=3.4

14. Make a virtual environment (VENV)
	source VENV/bin/activate
	deactivate
	

TESTING LDAP SERVER

15. Created ldappwd.txt (only text is the password) 	

16. Command to create ldap server (w/ password from ldappwd.txt)
TREADMILL_LDAP_SUFFIX='dc=ms,dc=com' treadmill admin install --cell - --profile vagrant --distro $HOME/VENV/ --install-dir /tmp/test openldap --env dev --owner vagrant --uri ldap://$HOSTNAME:22389 --first-time -p `/usr/sbin/slappasswd -nT ldappwd.txt`	

17. Command to start ldap server (from VENV):
/tmp/test/bin/run.sh

Sample ldapsearch: ldapsearch -H ldap://dev:22389/  -vvv -x -D "cn=Manager,dc=ms,dc=com" -y ldappwd.txt

INSTALLING TREADMILL ON DEV VM (must run terminal as administrator on Windows)

18. Added to Vagrantfile (needed for Windows): 
  config.vm.provider 'virtualbox' do |v|
    v.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/tm_venv', '1']
  end

19. In Vagrantfile, add 
    srv.vm.synced_folder './build', '/opt/treadmill', id: 'tm_venv' 

    Creating a synced folder to be accessed from dev and tm-infra VMs (as well as host machine)

20. Create virtualenv (tm_venv) in Dev VM inside the shared folder (/opt/treadmill)
    (Must have python3)

    Follow this link to download Python3 on Centos
    https://realpython.com/installing-python/#centos

    (in .bashrc: alias python3="python3.6")    

20. Git clone treadmill repository from Morgan Stanley Github page (not in shared folder, put it in ~/ or something)

    (sudo) git clone https://github.com/Morgan-Stanley/treadmill.git

21. Enter tm_venv (source tm_venv/bin/activate) and download requirements for treadmill

    pip install -r /path/to/requirements.txt

22. Download treadmill (isn't going to work until requirements.txt stuff is downloaded)

    pip install -e /path/to/treadmill/

23. Possible errors:

    If wheel is not being created or gcc is failing:
      sudo yum install python36-devel (maybe just python3-devel)

    If permission denied during pip install -e /path/to/treadmill/:
      sudo chown -R $USER git (or whatever folder contains the cloned git repo)    

    vagrant up won't allow folder to be shared folder to be mounted:
      Upgrade vagrant and virtualbox
      (if that fails maybe add to Vagrantfile, srv.vm.synced_folder ".", '/vagrant', disabled: true)

    If VirtualBox GuestAdditions is giving errors:
      yum update
      yum groupinstall "Development Tools"
      yum install kernel-devel
      
    Nothing else works(???):
      pip install --upgrade setuptools, pip, wheel
      sudo yum install -y python36u python36u-libs python36u-devel python36u-pip
      sudo yum install python-kerberos krb5-devel



TO DO (next week):

Need to reassociate vagrant with Dev VM
(and push changes to repo)


Current status:

Able to run treadmill command in dev VM from virtualenv (tm_venv) in shared folder 

Can also run python command from tm-infra VM (Python 3.6.7)

Can't run treadmill command from tm-infra VM 
(Error: /opt/treadmill/tm_venv/bin/python3.4: error while loading shared libraries: libpython3.4m.so.1.0: cannot open shared object file: No such file or directory)

