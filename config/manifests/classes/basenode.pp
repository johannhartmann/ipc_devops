class basenode {
  user { 'puppet': 
    ensure => present,
    managehome => true
  }
  group { 'puppet':
    ensure => present
  }
  package { 'rubygems':
    ensure => installed
  }
  package { 'facter': 
    ensure => installed
  }
  package { 'puppet-module':
    provider => 'gem',
    ensure => installed,
    require => Package[[rubygems]]
  }
}
