class ci inherits basenode {
  include apache
  include apache::php
  include jenkins

  exec { "pear_autodiscover":
      command => "/usr/bin/pear config-set auto_discover 1",
  }

  package { ["php5-cli", "phpunit", "php5-curl", "php5-dev", "php5-gd", "php5-imagick", "php5-mcrypt", "php5-mysql", "php5-xdebug","php5-suhosin", "php-pear", "php-codesniffer" ]:
    ensure => present,
  }

  package { ["Text_Highlighter", "PhpDocumentor" ]:
    ensure => latest,
    provider => "pear",
  }

  package { "pear.pdepend.org/PHP_Depend":
    ensure => latest,
    provider => "pear",
    require => Exec["pear_autodiscover"]
  }

  package { "pear.phpmd.org/PHP_PMD":
    ensure => latest,
    provider => "pear",
    require => Exec["pear_autodiscover"]
  }

  package { ["pear.phpunit.de/PHP_CodeBrowser", "pear.phpunit.de/PHPUnit_MockObject", "pear.phpunit.de/PHPUnit_Selenium", "pear.phpunit.de/PHP_CodeCoverage", "pear.phpunit.de/PHP_Timer", "pear.phpunit.de/phpcpd", "pear.phpunit.de/phploc"]:
    ensure => latest,
    provider => "pear",
    require => Exec["pear_autodiscover"]
  }
}
