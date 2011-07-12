define php::module($source = undef, $content = undef, $require = undef) {
    include php

    package { "php-${name}":
        name => $operatingsystem ? {
            /(Ubuntu|Debian)/ => "php5-${name}",
            default           => "php-${name}",
        },
        ensure  => present,
        notify  => $php::params::notify,
        require => $require,
    }

    file { "${name}.ini":
        path    => "${php::params::conf_dir}${name}.ini",
        mode    => 644,
        owner   => root,
        group   => root,
        ensure  => present,
        notify  => $php::params::notify,
        source  => $source ? {
            undef   => undef,
            default => "${source}${name}.ini",
        },
        content => $content ? {
            undef   => undef,
            default => template("${content}${name}.ini.erb"),
        },
        require => [
            Class["php::config"],
            Package["php-${name}"],
        ],
    }
}