node default {
  resources { "firewall":
    purge => true
  }
  include helloworld
}
