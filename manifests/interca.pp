#
define easyrsa::interca (
) {

  $key_cn = $name
  Pkitool { base_dir => $base_dir, environment => "KEY_CN=${key_cn}" }
  pkitool { "Generate Intermediate CA for ${key_cn} at ${base_dir}":
    command => "--inter ${key_cn}",
    creates => "${base_dir}/keys/${key_cn}.crt",
  }

}
