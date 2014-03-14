exec { 'apt_update':
  command => 'apt-get update',
  path    => '/usr/bin'
}
