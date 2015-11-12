#!/usr/bin/env bash
#[ `whoami` = root ] || exec sudo -E bash $0
os=$(uname)
host=$(hostname)
metal_hosts=(doublev tiny slab-linux)
chef_client=$(which chef-client)
echo $chef_client
role_name=""

git remote update origin
git pull origin master
git submodule init
git submodule update
git submodule foreach git pull origin master

if [ $os = 'Linux' ]; then
  sudo apt-get update
  #apt-get install -y curl git libxslt-dev libxml2-dev
  #apt-get install -y ruby ruby-dev build-essential
  sudo apt-get install -y chef-zero
  role_name="linux_workstation"
fi

for h in "${metal_hosts[@]}"
do
    if [ "$h" == $host ]; then
      role_name="linux_desktop"
    fi
done

if [ $os = 'Darwin' ]; then
  port install ruby19
  role_name="osx_workstation"
fi

#gem inst bundler --no-ri --no-rdoc
#gem inst chef --no-ri --no-rdoc
#bundle install
#librarian-chef install

#sudo chef-solo -j $node_config -c .chef/solo-bootstrap.rb
echo "running ${role_name}..."
sudo $chef_client -z -o "role[${role_name}]"
