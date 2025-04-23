variable "parameters_nonsecure" {
  type = map(string)
  default = {
    "/whatsapp/user1" = "test1"
    "/whatsapp/user2" = "test2"
    "/whatsapp/user3" = "test3"
    "/whatsapp/user4" = "test4"
    "/insta/user5"    = "sudharshan"
    "/insta/user6"    = "sudharshan2"

  }
}

variable "parameters_secure" {
  type = map(string)
  default = {
    "/whatsapp/pass1" = "test@12"
    "/whatsapp/pass2" = "test@1234"
    "/whatsapp/pass3" = "test@12345"
    "/facebook/pass4" = "test@123456"
    "/insta/pass5"    = "instapass"
  }
}