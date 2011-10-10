import "classes/*"
node "webserver01" {
  include web
}
node "dbserver01" {
  include db
}

node "ciserver01" {
  include ci
}
