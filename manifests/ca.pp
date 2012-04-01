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
    $base_dir
) {

  $key_cn = $name
  Exec { environment => "KEY_CN=${key_cn}" }

  easyrsa { $title: base_dir => $base_dir, }

  file { "${base_dir}/vars":
    mode    => 700,
    content => template("easyrsa/vars.erb"),
    before  => Pkitool["Generate CA at ${base_dir}"],
    require => Easyrsa[$title],
  }

  exec { "Clean All at ${base_dir}":
    cwd     => $base_dir,
    command => "/bin/bash -c \"(source $base_dir/vars > /dev/null; ${base_dir}/clean-all)\"",
    creates => "${base_dir}/keys/serial",
    require => [ Easyrsa[$title], File["${base_dir}/vars"] ],
  }

  Pkitool { base_dir => $base_dir, environment => "KEY_CN=${key_cn}" }
  pkitool { "Generate CA at ${base_dir}":
    command => "--initca",
    creates => "${base_dir}/keys/ca.crt",
    require => Exec["Clean All at ${base_dir}"],
  }

  exec { "Build DH at ${base_dir}":
    cwd     => $base_dir,
    command => "/bin/bash -c \"(source $base_dir/vars > /dev/null; ${base_dir}/build-dh ${key_size})\"",
    creates => "${base_dir}/keys/dh${key_size}.pem",
    require => Pkitool["Generate CA at ${base_dir}"],
  }

}
