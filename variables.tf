## Ocean Variables ##
variable "name" {
	type 		= string
	default 	= null
	description = "The Ocean cluster name."
}
variable "cluster_name" {
	type 		= string
	description = "The ECS cluster name."
}
variable "region" {
	type 		= string
	description = "The region the cluster will run in."
}
variable "max_size" {
	type 		= number
	default 	= 1000
	description = "The upper limit of instances the cluster can scale up to."
}
variable "min_size" {
	type 		= number
	default 	= 0
	description = "The lower limit of instances the cluster can scale down to."
}
variable "desired_capacity" {
	type 		= number
	default 	= null
	description = "The number of instances to launch and maintain in the cluster."
}
variable "subnet_ids" {
	type 		= list(string)
	description = "A comma-separated list of subnet identifiers for the Ocean cluster. Subnet IDs should be configured with auto assign public ip."
}
variable "tags" {
	type        = map(string)
	default     = null
	description = "Optionally adds tags to instances launched in an Ocean cluster."
}
variable "whitelist" {
	type 		= list(string)
	default 	= null
	description = "Instance types allowed in the Ocean cluster, Cannot be configured if blacklist is configured."
}
#variable "blacklist" {
#	type 		= list(string)
#	default 	= null
#	description = "Instance types allowed in the Ocean cluster, Cannot be configured if whitelist is configured."
#}
variable "user_data" {
	type 		= string
	default 	= null
	description = "Base64-encoded MIME user data to make available to the instances."
}
variable "image_id" {
	type 		= string
	default 	= null
	description = "ID of the image used to launch the instances."
}
variable "security_group_ids" {
	type 		= list(string)
	description = "One or more security group ids."
}
variable "key_pair" {
	type 		= string
	default 	= null
	description = "The key pair to attach the instances."
}
variable "iam_instance_profile" {
	type 		= string
	default 	= null
	description = "The instance profile iam role"
}
variable "associate_public_ip_address" {
	type 		= bool
	default 	= null
	description = "Configure public IP address allocation."
}
variable "utilize_reserved_instances" {
	type 		= bool
	default 	= true
	description = "If Reserved instances exist, Ocean will utilize them before launching Spot instances."
}
variable "draining_timeout" {
	type 		= number
	default 	= 120
	description = "The time in seconds, the instance is allowed to run while detached from the ELB. This is to allow the instance time to be drained from incoming TCP connections before terminating it, during a scale down operation."
}
variable "monitoring" {
	type 		= bool
	default 	= false
	description = "Enable detailed monitoring for cluster. Flag will enable Cloud Watch detailed monitoring (one minute increments). Note: there are additional hourly costs for this service based on the region used."
}
variable "ebs_optimized" {
	type 		= bool
	default 	= true
	description = "Enable EBS optimized for cluster. Flag will enable optimized capacity for high bandwidth connectivity to the EB service for non EBS optimized instance types. For instances that are EBS optimized this flag will be ignored."
}
variable "spot_percentage" {
	type 		= number
	default 	= null
	description = "The percentage of Spot instances"
}
variable "utilize_commitments" {
	type 		= bool
	default 	= null
	description = "If savings plans exist, Ocean will utilize them before launching Spot instances."
}
variable "http_tokens" {
	type 		= string
	default 	= null
	description = "Determines if a signed token is required or not. Valid values: optional or required."
}
variable "http_put_response_hop_limit" {
	type 		= number
	default 	= null
	description = "An integer from 1 through 64. The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further the instance metadata requests can travel."
}
###################

## Block Device Mappings ##
variable "block_device_mappings" {
	type 								= object({
		device_name						= string
		delete_on_termination 			= bool
		encrypted 						= bool
		kms_key_id 						= string
		snapshot_id 					= string
		volume_type 					= string
		iops							= number
		volume_size						= number
		throughput						= number
		no_device 						= string
	})
	default 							= null
	description 						= "Block Device Mapping Object"
}
variable "dynamic_volume_size" {
	type 					  			= object({
		base_size						= number
		resource 						= string
		size_per_resource_unit			= number
	})
	default 							= null
	description 						= "dynamic_volume_size Object"
}
##################

## optimize images ##
variable "perform_at" {
	type 		= string
	default 	= "always"
	description = "Needs to be one of the following values: never/always/timeWindow."
}
variable "time_windows" {
	type 		= list(string)
	default 	= null
	description = "Example: ['Sun:02:00-Sun:12:00', 'Wed:01:01-Fri:02:03']"
}
variable "should_optimize_ecs_ami" {
	type 	= bool
	default = true
}
##################

## Auto Scaler ##
variable "autoscaler_is_enabled" {
	type 		= bool
	default 	= true
	description = "Enable the Ocean ECS autoscaler."
}
variable "autoscaler_is_auto_config" {
	type 		= bool
	default 	= true
	description = "Automatically configure and optimize headroom resources."
}
variable "cooldown" {
	type 		= number
	default 	= null
	description = "Cooldown period between scaling actions."
}
###################

## Headroom ##
variable "cpu_per_unit" {
	type 		= number
	default 	= 0
	description = "Optionally configure the number of CPUs to allocate the headroom. CPUs are denoted in millicores, where 1000 millicores = 1 vCPU."
}
variable "memory_per_unit" {
	type 		= number
	default 	= 0
	description = "Optionally configure the amount of memory (MB) to allocate the headroom."
}
variable "num_of_units" {
	type 		= number
	default 	= 0
	description = "The number of units to retain as headroom, where each unit has the defined headroom CPU and memory."
}
###################

## Down ##
variable "max_scale_down_percentage" {
	type 		= number
	default 	= 10
	description = "Would represent the maximum % to scale-down. Number between 1-100."
}
variable "max_vcpu" {
	type 		= number
	default 	= null
	description = "The maximum cpu in vCPU units that can be allocated to the cluster."
}
variable "max_memory_gib" {
	type 		= number
	default 	= null
	description = "The maximum memory in GiB units that can be allocated to the cluster."
}
variable "auto_headroom_percentage" {
	type 		= number
	default 	= null
	description = "The auto-headroom percentage. Set a number between 0-200 to control the headroom % of the cluster. Relevant when isAutoConfig= true."
}
###################

## Update Policy ##
variable "should_roll" {
	type 		= bool
	default 	= false
	description = "Enables the roll."
}
variable "conditional_roll" {
	type 		= bool
	default 	= false
	description = "Spot will perform a cluster Roll in accordance with a relevant modification of the cluster’s settings. When set to true , only specific changes in the cluster’s configuration will trigger a cluster roll (such as AMI, Key Pair, user data, instance types, load balancers, etc)."
}
variable "auto_apply_tags" {
	type 		= bool
	default 	= false
	description = "will update instance tags on the fly without rolling the cluster."
}
variable "batch_size_percentage" {
	type 		= number
	default 	= 20
	description = "Sets the percentage of the instances to deploy in each batch."
}
variable "batch_min_healthy_percentage" {
	type 		= number
	default 	= 50
	description = "Indicates the threshold of minimum healthy instances in single batch. If the amount of healthy instances in single batch is under the threshold, the cluster roll will fail. If exists, the parameter value will be in range of 1-100. In case of null as value, the default value in the backend will be 50%. Value of param should represent the number in percentage (%) of the batch."
}
###################

## Scheduled Task ##
variable "scheduled_task" {
	type 							= object({
		shutdown_is_enabled 		= bool
		shutdown_time_windows 		= list(string)
		taskscheduling_is_enabled 	= bool
		cron_expression 			= string
		task_type 					= string
	})
	default 						= null
	description 					= "Scheduled Tasks Block"
}

#####################

## S3 Logging ##
variable "data_integration_id" {
    type 		= string
	default 	= null
	description = "The identifier of The S3 data integration to export the logs to."
}