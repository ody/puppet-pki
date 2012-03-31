#
define easyrsa (
  $base_dir
  ) {

  file { $base_dir:
    source => "puppet:///modules/easyrsa/easyrsa",
    recurse => true,
    replace => false,
  }

}
