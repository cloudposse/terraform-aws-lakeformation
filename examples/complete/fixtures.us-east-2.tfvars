region = "us-east-2"

namespace = "eg"

environment = "ue2"

stage = "test"

name = "example"

lakeformation_tags = {
  left  = ["test1", "test2"]
  right = ["test3", "test4"]
}

resources = {
  database = {
    name = "example_db_1"
    tags = {
      left = "test1"
    }
  }
}
