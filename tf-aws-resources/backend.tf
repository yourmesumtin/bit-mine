terraform {
  cloud {
    organization = "bit-coin"

    workspaces {
      name = "bit-coin-user"
    }
  }
}
