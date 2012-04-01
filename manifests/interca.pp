# $rootca is the location of the Root CAs base directory
# $dest is the destination that we will be creating this ca
define easyrsa::interca (
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
    $rootca
) {

  $key_cn = $name
  $dest   = "${pki_dir}/${key_cn}"

  # Build the Intermediate CA and sign it with the root CA
  pkitool { "Generate Intermediate CA for ${key_cn} at ${rootca}":
    command     => "--inter ${key_cn}",
    creates     => "${rootca}/keys/${key_cn}.crt",
    base_dir    => $rootca,
    environment => "KEY_CN=${key_cn}",
    require     => Easyrsa["Root"],
  }

  # Build a using the Key/Cert signed by the RootCA
  easyrsa::ca { $key_cn:
    ca_expire    => $ca_expire,
    key_size     => $key_size,
    key_expire   => $key_expire,
    key_country  => $key_country,
    key_province => $key_province,
    key_city     => $key_city,
    key_email    => $key_email,
    key_org      => $key_org,
    key_name     => $key_name,
    key_ou       => $key_ou,
    pki_dir      => $pki_dir,
    source_key   => "${rootca}/keys/${key_cn}.key",
    source_cert  => "${rootca}/keys/${key_cn}.crt",
    require      => Pkitool["Generate Intermediate CA for ${key_cn} at ${rootca}"],
  }

}

