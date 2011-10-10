
package {
  "apache2": 
    ensure => running;
  "memcached": 
    ensure => running;
  "php5-mysql":
    ensure  => present;
  "mysql-server": 
    ensure => running;
  "mysql-client":
    ensure  => present;
  "php5-memcached":
    ensure => present;
}
