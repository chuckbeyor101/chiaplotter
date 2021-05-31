#change Permissions
sudo sed -i 's/ALL=(ALL:ALL) ALL/ALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers
sudo sed -i 's/ALL=(ALL) ALL/ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers

#Update System
sudo apt update
sudo apt upgrade -y
sudo apt install git -y


#change System Settings
gsettings set org.gnome.desktop.session idle-delay 0
sudo systemctl enable rsync


#Install XRDP
sudo apt install xrdp -y

#Install iftop
sudo apt-get install iftop -y

#Install SSH
sudo apt install openssh-server
ssh-keygen -t rsa
ssh-copy-id user@192.168.1.200

#Install Samba
sudo apt install samba -y
sudo smbpasswd -a user password admin

#Install Chia
git clone https://github.com/Chia-Network/chia-blockchain.git -b latest --recurse-submodules
cd /home/user/chia-blockchain
sh install.sh
. ./activate
chia init
chia keys add -f /home/user/Desktop/keys.txt

#Install Plotman
pip install git+https://github.com/ericaltendorf/plotman@main
plotman config generate
sudo sed -i 's/tmp_overrides:/#tmp_overrides:/g' /home/user/.config/plotman/plotman.yaml
sudo sed -i 's/tmpdir_max_jobs: 5/#tmpdir_max_jobs: 5/g' /home/user/.config/plotman/plotman.yaml
sudo sed -i 's@"/mnt/tmp/00":@#"/mnt/tmp/00":@g' /home/user/.config/plotman/plotman.yaml
sudo sed -i 's/rsyncd_host:.*/rsyncd_host: 192.168.1.200/g' /home/user/.config/plotman/plotman.yaml
sudo sed -i 's@log:.*@log: /home/user/Desktop/Logs@g' /home/user/.config/plotman/plotman.yaml
sudo sed -i 's/rsyncd_module:.*/rsyncd_module: chia/g' /home/user/.config/plotman/plotman.yaml
sudo sed -i 's@rsyncd_path:.*@rsyncd_path: /media/user@g' /home/user/.config/plotman/plotman.yaml
sudo sed -i 's/rsyncd_user:.*/rsyncd_user: user/g' /home/user/.config/plotman/plotman.yaml
sudo sed -i 's/n_threads:.*/n_threads: 2/g' /home/user/.config/plotman/plotman.yaml
#sudo sed -i '$!N;s@tmp:.*@tmp: /home/user/Desktop/Temp@g' /home/user/.config/plotman/plotman.yaml
#sudo sed -i '$!N;s@dst:.*@dst: /media/user/easystore@g' /home/user/.config/plotman/plotman.yaml

#Create Directories
mkdir /home/user/Desktop/Temp
mkdir /home/user/Desktop/Logs
mkdir /home/user/Desktop/Scripts
mkdir /home/user/.config/autostart

#Create Plotter File
cat << EOF > /home/user/Desktop/Scripts/plotter.sh
rm /home/user/Desktop/Temp/*
rm /home/user/.local/share/Trash/*
cd /home/user/chia-blockchain
. ./activate
plotman plot
EOF
sudo chmod 777 /home/user/Desktop/Scripts/plotter.sh

#Create Dashboad File
cat << EOF > /home/user/Desktop/Scripts/dashboard.sh
cd /home/user/chia-blockchain
. ./activate
echo Please Wait .....
sleep 30
plotman interactive
EOF
sudo chmod 777 /home/user/Desktop/Scripts/dashboard.sh

#create Launch Dashboard File
cat << EOF > /home/user/Desktop/Launch_Dashboard.sh
gnome-terminal --window --maximize -e /home/user/Desktop/Scripts/dashboard.sh $SHELL
EOF
sudo chmod 777 /home/user/Desktop/Launch_Dashboard.sh

#create Launch Network Explorer File
cat << EOF > /home/user/Desktop/Network_Explorer.sh
sudo iftop -n 
EOF
sudo chmod 777 /home/user/Desktop/Network_Explorer.sh

#create Auto Mount File
cat << EOF > /home/user/Desktop/Scripts/automount.sh


EOF
sudo chmod 777 /home/user/Desktop/Launch_Dashboard.sh

#Create Edit Config File
cat << EOF > /home/user/Desktop/edit_config.sh
nano /home/user/.config/plotman/plotman.yaml
EOF

#Create RSync Config File
cat << EOF > /home/user/Desktop/rsyncd.conf
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid

# don't change the port, plotman (as of version 0.2) has the port hard coded
port = 12000

# rsync module name
[chia]
    # Path with your mounted drives
    path = /media/user
    comment = Chia
    # Use the username that you log into Ubuntu with or create a new one
    uid = user
    # User group (by default same as username)
    gid = user
    read only = no
    list = yes
    # dont uncomment this, 
    #auth users = none
    # plotman does not work with authentication
    #secrets file = none
    # since we dont use auth only accept connections from plotter's ip
    hosts allow = 192.168.1.0/24
EOF
sudo mv /home/user/Desktop/rsyncd.conf /etc/


#Create Plotter Auto Launch File
cat << EOF > /home/user/.config/autostart/plotter.sh.desktop
[Desktop Entry]
Type=Application
Exec=/home/user/Desktop/Scripts/plotter.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Plotter
Name=Plotter
Comment[en_US]=
Comment=
EOF

#Create Dashboard Auto Launch File
cat << EOF > /home/user/.config/autostart/Launch_Dashboard.sh.desktop
[Desktop Entry]
Type=Application
Exec=/home/user/Desktop/Launch_Dashboard.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Dashboard
Name=Dashboard
Comment[en_US]=
Comment=
EOF

#Create Auto Mount Launch File
cat << EOF > /home/user/.config/autostart/automount.sh.desktop
[Desktop Entry]
Type=Application
Exec=/home/user/Desktop/Scripts/automount.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Dashboard
Name=Dashboard
Comment[en_US]=
Comment=
EOF

#Open Config for user editing
sudo chmod 777 /home/user/Desktop/edit_config.sh
gnome-terminal --window -e /home/user/Desktop/edit_config.sh

#Final User Instructions
echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
echo "--------- Do the remaining steps to finish setup ----------------------"
echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
echo "-----------------------------------------------------------------------"
echo "1. Please edit plotter config file"
echo "2. Reboot system"
