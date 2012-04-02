#
define pki (
  $dest
  ) {

  file { $dest:
    source => "puppet:///modules/pki/easyrsa",
    recurse => true,
    replace => false,
  }

}
