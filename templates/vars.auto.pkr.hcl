variable "box_version" {
  type    = string
  default = "${env("VERSION")}"
}
