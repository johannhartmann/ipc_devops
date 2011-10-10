class db inherits basenode {
  include mysql::server
  mysql_database { "silex": 
    ensure => present 
  }

  mysql_user{ "silex@%":
    password_hash => mysql_password("secret"),
    ensure => present,
  }

  mysql_grant {
    "silex@%":
      privileges => all
  }
}
