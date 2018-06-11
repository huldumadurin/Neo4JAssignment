echo "Destroying vagrant..."
vagrant destroy
echo "Gone!"
sleep 5
echo "Bringing up Vagrant"
vagrant up
echo "Up!"
sleep 5
echo "Sshhhhh..."
vagrant ssh
