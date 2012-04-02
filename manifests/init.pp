#
define pki (
  $dest
  ) {

  file { $dest:
    source => "puppet:///modules/easyrsa/easyrsa",
    recurse => true,
    replace => false,
  }

}
