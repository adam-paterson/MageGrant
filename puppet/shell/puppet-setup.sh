#!/bin/bash

if [[ ! -f /.puppet-setup/puppet ]]; then
	echo "Downloading Puppet!"
	wget --quiet --tries=5 --connect-timeout=10 -O "/.puppet-setup/puppetlabs-release-precise.deb" "https://apt.puppetlabs.com/puppetlabs-release-precise.deb"
	echo "Done!"
	
	dpkg -i "/.puppet-setup/puppetlabs-release-precise.deb" >/dev/null
	
	echo "Updating Puppet"
	apt-get update >/dev/null
	echo "Done!"
	
	echo "Updating it again to 3.4.x"
	apt-get install -y puppet=3.4.3-1puppetlabs1 puppet-common=3.4.3-1puppetlabs1 >/dev/null
	VERSION=$(puppet help | grep "Puppet v")
	echo "Updated to ${VERSION}"
	
	touch /.puppet-setup/puppet
	echo "Created /.puppet-setup/puppet"
fi

# Directory librarian-puppet should use for modules
PUPPET_DIR=/etc/puppet

$(which git > /dev/null 2>&1)
FOUND_GIT=$?

if [ "${FOUND_GIT}" -ne '0' ] && [ ! -f /.puppet-setup/puppet/librarian-installed ]; then
	echo "Installing git"
	apt-get -q -y install git-core >/dev/null
	echo "Done!"	
fi

if [[ -d "${PUPPET_DIR}" ]]; then
	mkdir -p "${PUPPET_DIR}"
	echo "Created ${PUPPET_DIR}"
fi

cp "/vagrant/puppet/Puppetfile" "${PUPPET_DIR}"
echo "Copied local Puppetfile to VM"

if [[ ! -f /.puppet-setup/librarian-gem ]]; then
	echo "Updating libgemplugin-ruby"
	apt-get install -y libgemplugin-ruby >/dev/null
	echo "Done!"
	
	touch /.puppet-setup/librarian-gem
fi

if [[ ! -f /.puppet-setup/librarian-puppet-installed ]]; then
	echo "Installing librarian-puppet"
	gem install librarian-puppet >/dev/null
	echo "Done!"
	
	echo "Initial librarian-puppet"
	cd "${PUPPET_DIR}" && librarian-puppet update >/dev/null
	echo "Done!"
	
	touch /.puppet-setup/librarian-puppet-installed
fi

if [[ ! -f /.puppet-setup/templates-copied ]]; then
	echo "Copying puppet templates"
	cp -R "/vagrant/puppet/files" "${PUPPET_DIR}/templates"
	
	touch /.puppet-setup/templates-copied
fi