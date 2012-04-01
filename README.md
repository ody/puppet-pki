# PKI Management with Puppet

## Usage

### Generate the Root CA

    easyrsa::ca { "TestCA":
      base_dir     => $base_dir,
      key_email    => "ssl@example.com",
      key_size     => 2048,
      key_country  => "US",
      key_province => "OR",
      key_city     => "Portland",
      key_org      => "TestCo",
    }

### Generate the Intermediate CAs

    easyrsa::interca { "VPN": }
    easyrsa::interca { "MCollective": }
    easyrsa::interca { "Puppet": }
    easyrsa::interca { "TechOps": }


