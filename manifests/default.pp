exec {"apt-get update":
    path => "/usr/bin"
}

class {"ruby":
    require => Exec["apt-get update"],
    ruby_package => "ruby1.9.1-full",
    rubygems_package => "rubygems1.9.1",
    gems_version => "latest"
}

package {"bundler":
    require => Class["ruby"],
    ensure => installed,
    provider => "gem"
}

package {"build-essential":
    require => Exec["apt-get update"],
    ensure => installed
}

exec {"bundle install":
    require => Package["bundler"],
    path => "/usr/local/bin",
    cwd => "/vagrant"
}