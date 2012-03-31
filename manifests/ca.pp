#
define easyrsa::ca (
  $key_size     = '1024',
  $ca_expire    = '3650',
  $key_expire   = '3650',
  $key_country  = 'US',
  $key_province = 'OR',
  $key_city     = "Portland",
  $key_email    = "admin@foo.bar",
  $key_org      = "TechOps",
  $key_cn       = "changeme",
  $key_name     = "changeme",
  $key_ou       = "changeme",
  $base_path
) {

  file { "${base_path}/vars":
    mode    => 700,
    content => template("easyrsa/vars.erb")
  }

  exec { "Clean All at ${base_path}":
    cwd         => $base_path,
    command     => "/bin/bash -c \"(source $base_dir/vars > /dev/null; ${base_path}/clean-all)\"",
    creates     => "${base_path}/keys/serial",
    before      => Pkitool["Generate CA at ${base_path}"],
  }

  Pkitool { base_dir => $base_dir }
  pkitool { "Generate CA at ${base_path}":
    command => "--initca",
    creates => "${base_dir}/keys/ca.crt",
  }

}
