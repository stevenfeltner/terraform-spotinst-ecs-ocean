terraform {
  required_providers {
    spotinst = {
      source = "spotinst/spotinst"
    }
  }
}

provider spotinst {
  token    = "redacted"
  account  = "redacted"
}

#### Create Ocean ECS Cluster ####
module "ocean_ecs" {
  source = "stevenfeltner/ecs-ocean/spotinst"

  cluster_name                    = "ECS-Workshop"
  desired_capacity                = 0
  min_size = 1
  region                          = "us-west-2"
  subnet_ids                      = ["subnet-123456789, subnet-123456789, subnet-123456789, subnet-123456789"]
  security_group_ids              = ["sg-123456789"]
  iam_instance_profile            = "arn:aws:iam::123456789:instance-profile/ecsInstanceRole"

  block_device_mappings = {
    device_name						= "/dev/xvda"
    delete_on_termination 			= true
    encrypted 						= true
    kms_key_id 						= "717e36d8-f059-454b-8634-123456789"
    snapshot_id 					= null
    iops                            = null
    volume_type 					= "gp2"
    volume_size						= 100
    throughput						= null
    no_device 						= null
  }

  tags = {CreatedBy = "terraform"}
}

output "ocean_id" {
  value = module.ocean_ecs.ocean_id
}