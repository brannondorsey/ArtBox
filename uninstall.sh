echo "Stopping EmptyBox..."
sudo /etc/init.d/emptybox stop
echo "Removing EmptyBox daemon..."
sudo update-rc.d emptybox remove 
sudo rm -v /etc/init.d/emptybox
echo "Removing EmptyBox folder..."
sudo rm -rf -v /opt/emptybox