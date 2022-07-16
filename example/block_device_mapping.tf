#### Create Ocean ECS Cluster ####
module "ocean_ecs" {
  source = "stevenfeltner/ecs-ocean/spotinst"

  cluster_name                    = "ECS-Workshop"
  min_size                        = 1
  region                          = "us-west-2"
  subnet_ids                      = ["subnet-0a60fdfc059cc0c55, subnet-00dd3842d49f32f7e, subnet-013f06cd493bb19b5, subnet-041991572bdbe4edc"]
  security_group_ids              = ["sg-000da0e1cf896a176"]
  iam_instance_profile            = "arn:aws:iam::303703646777:instance-profile/ecsInstanceRole"

  block_device_mappings = {
    device_name						= "/dev/xvda"
    delete_on_termination 			= true
    encrypted 						= true
    kms_key_id 						= "717e36d8-f059-454b-8634-48ad08b4efe6"
    snapshot_id 					= null
    iops                            = null
    volume_type 					= "gp2"
    volume_size						= 100
    throughput						= null
    no_device 						= null
  }

  tags = {CreatedBy = "terraform"}
}