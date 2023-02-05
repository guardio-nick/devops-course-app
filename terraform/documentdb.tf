resource "aws_docdb_subnet_group" "service" {
  name       = local.documentdb_name
  subnet_ids = module.vpc.private_subnets
}

resource "aws_docdb_cluster_instance" "service" {
  count              = 1
  identifier         = "${local.documentdb_name}-${count.index}"
  cluster_identifier = aws_docdb_cluster.service.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster" "service" {
  skip_final_snapshot             = true
  db_subnet_group_name            = aws_docdb_subnet_group.service.name
  cluster_identifier              = local.documentdb_name
  engine                          = "docdb"
  master_username                 = "mongo"
  master_password                 = "mongo123"
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.service.name
  #  vpc_security_group_ids          = ["${aws_security_group.service.id}"]
}

resource "aws_docdb_cluster_parameter_group" "service" {
  family = "docdb4.0"
  name   = local.documentdb_name

  parameter {
    name  = "tls"
    value = "disabled"
  }
}
