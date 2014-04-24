include stdlib




class {'nginx': 
	conf_template => '/vagrant/puppet/files/nginx/nginx.conf.erb'
}

class vhostSetup {
	if $vhostValues == undef {
		$vhostValues = hiera_hash('vhost')
	}
	
	$servername = $vhostValues['servername']
	$devmode = $vhostValues['developer']['magento']
	
	file { '/etc/nginx/sites-available/default':
		ensure => 'present',
		content => template('/vagrant/puppet/files/nginx/vhost.erb')
	}
}

class {'vhostSetup':}










