data "aws_kms_alias" "kafka" {
  name = "alias/aws/kafka"
}

resource "aws_msk_configuration" "msk_config" {
  description       = "Enable kafka topic deletion"
  name              = "${var.unit}-msk-${var.env}"
  kafka_versions    = []
  server_properties = <<PROPERTIES
auto.create.topics.enable=false
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=true
zookeeper.session.timeout.ms=18000
delete.topic.enable=true
PROPERTIES
}

resource "aws_msk_cluster" "msk" {
  cluster_name           = "${var.unit}-msk-${var.env}"
  enhanced_monitoring    = "PER_TOPIC_PER_BROKER"
  number_of_broker_nodes = 2
  kafka_version          = "2.6.0"
  broker_node_group_info {
    instance_type   = "kafka.m5x.large"
    ebs_volume_size = 50
    az_distribution = "DEFAULT"
    client_subnets = aws_subnet.data_subnet.*.id
    security_groups = [aws_security_group.sg.id]
  }
  configuration_info {
    arn      = aws_msk_configuration.msk_config.arn
    revision = 1
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = data.aws_kms_alias.kafka.target_key_arn

    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
      in_cluster    = true
    }
  }
}