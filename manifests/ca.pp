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
  $base_dir
) {

  easyrsa { $title:
    base_dir => $base_dir,
    before   => Pkitool["Generate CA at ${base_dir}"],
  }

  file { "${base_dir}/vars":
    mode    => 700,
    content => template("easyrsa/vars.erb"),
    before  => Pkitool["Generate CA at ${base_dir}"],
  }

  exec { "Clean All at ${base_dir}":
    cwd         => $base_dir,
    command     => "/bin/bash -c \"(source $base_dir/vars > /dev/null; ${base_dir}/clean-all)\"",
    creates     => "${base_dir}/keys/serial",
    before      => Pkitool["Generate CA at ${base_dir}"],
  }

  Pkitool { base_dir => $base_dir }
  pkitool { "Generate CA at ${base_dir}":
    command => "--initca",
    creates => "${base_dir}/keys/ca.crt",
  }

}
