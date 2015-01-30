crypton-docker
--------------

This project creates a very simple Docker image with a fully configured Crypton service (https://crypton.io/).

There are two ways to run this.  First, if you are already on a Linux system supporting Docker, you can go
directly to the "Docker" section below.  If you are not, then you can use the Vagrant section to help get
a Linux system up and running quickly.

Vagrant Method
--------------
If you want a VM to host your Crypton service on, then this is the easiest way to get developing quickly.

Install prereqs:

  * Install Vagrant (https://www.vagrantup.com/downloads.html)
  * Install VirtualBox (https://www.virtualbox.org/wiki/Downloads)
  * If you are on Windows, you need a bash environment -- Git for Windows has "Git Bash" which works well.
  * Install the latest Ubuntu Utopic64 image into Vagrant: `vagrant box add --name ubuntu/utopic64 https://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-amd64-vagrant-disk1.box`

Now these steps will get you up and running quickly:

  * Clone this repo: git clone https://github.com/Hack-A-Frog/crypton-docker.git
  * In a bash shell in the crypton-docker directory, bring up the VM: vagrant up
  * Now ssh to your new VM: vagrant ssh
  * Change into the crypton-docker directory: cd /vagrant
  * Proceed to the Docker Method below
  * You can now access Crypton on port 1025 of your local machine.  (Vagrant maps your local port 1025 to the VM.)

Docker Method
-------------
Now that you either have your new Linux VM ready to go with Docker, or you already have your Linux system prepared
in some other way, proceed with these commands in the cloned crypton-docker directory:

  ```
  $ docker build -t crypton:0.1 .
  $ docker run -i -t -p 1025:1025 crypton:0.1 /bin/bash
  ```

You can now access the crypton service locally on port 1025.  (Docker maps port 1025 on your Docker host to port
1025 in the container.)
