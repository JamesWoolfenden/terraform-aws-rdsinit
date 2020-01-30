



# The SQL script that gets evaluated on new database instances.
# Clearly, you will want to change this!
data "template_file" "sql_script" {
  template = "${file("${path.module}/sql/create_user.sql")}"
}