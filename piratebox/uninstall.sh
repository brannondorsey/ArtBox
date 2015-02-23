echo "Stopping piratebox..."
sudo /etc/init.d/piratebox stop
echo "Removing piratebox daemon..."
sudo update-rc.d piratebox remove 
sudo rm -v /etc/init.d/piratebox
echo "Removing piratebox folder..."
sudo rm -rf -v /opt/piratebox 