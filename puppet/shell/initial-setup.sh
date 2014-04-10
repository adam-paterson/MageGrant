#!/bin/bash

if [[ ! -d /.puppet-setup ]]; then
	mkdir /.puppet-setup
	echo "Created directory /.puppet-setup"
fi

if [[ ! -f /.puppet-setup/apt-setup ]]; then
	echo "Running apt-get update"
	apt-get update >/dev/null
	echo "Done!"
	touch /.puppet-setup/apt-setup
	
	echo "Updating Ruby!"
	gem update --system >/dev/null
	gem install haml >/dev/null
	echo "Done!"
fi

if [[ ! -f /.puppet-setup/ubuntu-required ]]; then
	echo "Installing basic curl packages"
    apt-get install -y libcurl3 libcurl4-gnutls-dev curl >/dev/null
	echo "Done!"
	touch /.puppet-setup/ubuntu-required
fi