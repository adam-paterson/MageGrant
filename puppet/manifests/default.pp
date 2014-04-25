include stdlib

# Ensure Nginx users exist
Exec {
	path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
}
group { 'puppet':   ensure => present }
group { 'www-data': ensure => present }
group { 'www-user': ensure => present }

user { ['nginx', 'www-data']:
  shell  => '/bin/bash',
  ensure => present,
  groups => 'www-data',
  require => Group['www-data']
}

# Change default nginx config to use template suggested by Magento
class {'nginx': 
	conf_template => '/vagrant/puppet/files/nginx/nginx.conf.erb'
}

# Create vhost using Magento's suggested nginx server block
class vhostSetup {
	if $vhostValues == undef {
		$vhostValues = hiera_hash('vhost')
	}
	
	file { '/etc/nginx/sites-available/default':
		ensure => 'present',
		content => template('/vagrant/puppet/files/nginx/vhost.erb')
	}
}

class {'vhostSetup':}

# MySQL settings
class {'mysql::server':
	root_password => '110990ap'
}

# MySQL Database object
define mysqlDb (
	$user,
	$password,
	$host,
	$grant = [],
	$sqlFile = false
) {
	if $name == '' or $password == '' or $host == '' {
		fail( 'MySQL DB requires a name, password and host to be set. Please check the config.json')
	}
	
	mysql::db { $name:
		user		=> $user,
		password 	=> $password,
		host 		=> $host,
		grant		=> $grant,
		sql			=> $sqlFile
	}
}

$mysqlValues = hiera('mysql', false)

# Create database from config
if is_hash($mysqlValues['database']) {
	create_resources(mysqlDb, $mysqlValues)
}

# PHP Manifest
$phpValues = hiera('php', false)
include nginx::params
class { 'php': }
package { "php5-cli": ensure => present }
package {"curl": ensure => present }

# n98-magerun install
class { 'n98magerun': 
	config_file => '/vagrant/puppet/files/.n98-magerun.yaml'
}