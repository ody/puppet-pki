#
define easyrsa::ca (
    $key_size     = '1024',
    $ca_expire    = '3650',
    $key_expire   = '3650',
    $key_country  = 'US',
    $key_province = 'OR',
    $key_city     = "Portland",
    $key_email    = "admin@foo.bar",
    $key_org      = "Acme",
    $key_name     = "Root",
    $key_ou       = "TechOps",
    $pki_dir,
    $source_key   = '',
    $source_cert  = ''
) {


  $key_cn = $name
  $dest   = "${pki_dir}/${key_cn}"

  anchor { "ca::${key_cn}::start": }
  -> anchor { "ca::${key_cn}::ready": }
  -> anchor { "ca::${key_cn}::end": }

  Exec { environment => "KEY_CN=${key_cn}" }

  easyrsa { $title:
    dest   => $dest,
    before => Anchor["ca::${key_cn}::start"],
  }

  file { "${dest}/vars":
    mode    => 700,
    content => template("easyrsa/vars.erb"),
    require => Anchor["ca::${key_cn}::start"],
    before  => Anchor["ca::${key_cn}::ready"],
  }

  exec { "Clean All at ${dest}":
    cwd     => $dest,
    command => "/bin/bash -c \"(source $dest/vars > /dev/null; ${dest}/clean-all)\"",
    creates => "${dest}/keys/serial",
    require => Anchor["ca::${key_cn}::ready"],
    before  => Anchor["ca::${key_cn}::end"],
  }

  Pkitool {
    base_dir    => $dest,
    environment => "KEY_CN=${key_cn}",
    require     => Anchor["ca::${key_cn}::end"],
  }

  if ( $source_key != '' and $source_cert != '' ) {

    file { "${dest}/keys/ca.crt":
      source  => $source_cert,
      mode    => 0644,
      require => Anchor["ca::${key_cn}::end"],
    }
    file { "${dest}/keys/ca.key":
      source => $source_key,
      mode   => 0644,
      require => Anchor["ca::${key_cn}::end"],
    }

  } else {

    pkitool { "Generate CA at ${dest}":
      command => "--initca",
      creates => "${dest}/keys/ca.crt",
    }

  }

  exec { "Build DH at ${dest}":
    cwd     => $dest,
    command => "/bin/bash -c \"(source $dest/vars > /dev/null; ${dest}/build-dh ${key_size})\"",
    creates => "${dest}/keys/dh${key_size}.pem",
    require => Anchor["ca::${key_cn}::end"],
  }

}

