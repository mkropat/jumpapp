provision_ubuntu = <<EOF
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y devscripts equivs

chmod a+w /     # necessary for dpkg-genchanges to write to ..

cd /vagrant
mk-build-deps --install --tool='apt-get --no-install-recommends -y'
EOF

provision_fedora = <<EOF
sudo dnf install -y make rpmdevtools yum-utils
rpmdev-setuptree

cd /vagrant
sudo yum-builddep -y *.spec
EOF

Vagrant.configure(2) do |config|
  config.vm.define 'ubuntu' do |ubuntu|
    ubuntu.vm.box = 'ubuntu/xenial64'
    ubuntu.vm.provision 'shell', inline: provision_ubuntu
  end

  config.vm.define 'fedora' do |centos|
    centos.vm.box = 'bento/fedora-22'
    centos.vm.provision 'shell', privileged: false, inline: provision_fedora
  end
end
