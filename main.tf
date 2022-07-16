#Create Spot.io Ocean ECS Cluster
resource "spotinst_ocean_ecs" "ocean_ecs" {
    name                                = var.name == null ? var.cluster_name : var.name
    cluster_name                        = var.cluster_name
    region                              = var.region
    min_size                            = var.min_size
    max_size                            = var.max_size
    desired_capacity                    = var.desired_capacity
    subnet_ids                          = var.subnet_ids

    lifecycle {
        ignore_changes = [
            desired_capacity
        ]
    }
    # Default Provider Tags
    dynamic tags {
        for_each = data.aws_default_tags.default_tags.tags
        content {
            key = tags.key
            value = tags.value
        }
    }
    # Additional Tags
    dynamic tags {
        for_each = var.tags == null ? {} : var.tags
        content {
            key = tags.key
            value = tags.value
        }
    }
    whitelist 						    = var.whitelist
    #blacklist                           = var.blacklist
    user_data                           = var.user_data != null ? var.user_data : <<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
    EOF

    image_id                            = var.image_id == null ? data.aws_ami.ecs_ami.id : var.image_id
    security_group_ids                  = var.security_group_ids
    key_pair                            = var.key_pair
    iam_instance_profile                = var.iam_instance_profile
    associate_public_ip_address         = var.associate_public_ip_address
    utilize_reserved_instances          = var.utilize_reserved_instances
    draining_timeout                    = var.draining_timeout
    monitoring                          = var.monitoring
    ebs_optimized                       = var.ebs_optimized
    spot_percentage                     = var.spot_percentage
    utilize_commitments                 = var.utilize_commitments

    ## S3 Logging ##
    dynamic "logging" {
        for_each = var.data_integration_id != null ? [var.data_integration_id] : []
        content {
            export {
                s3 {
                    id = var.data_integration_id
                }
            }
        }
    }

    dynamic "instance_metadata_options" {
        for_each = (var.http_tokens != null && var.http_put_response_hop_limit != null) ? [1] : []
        content {
            http_tokens                     = var.http_tokens
            http_put_response_hop_limit     = var.http_put_response_hop_limit
        }
    }

    ## Block Device Mappings ##
    dynamic "block_device_mappings" {
        for_each = var.block_device_mappings != null ? [var.block_device_mappings] : []
        content {
            device_name = block_device_mappings.value.device_name
            no_device                   = block_device_mappings.value.no_device
            ebs {
                delete_on_termination       = block_device_mappings.value.delete_on_termination
                encrypted                   = block_device_mappings.value.encrypted
                iops                        = block_device_mappings.value.iops
                kms_key_id                  = block_device_mappings.value.kms_key_id
                snapshot_id                 = block_device_mappings.value.snapshot_id
                volume_type                 = block_device_mappings.value.volume_type
                volume_size                 = block_device_mappings.value.volume_size
                throughput                  = block_device_mappings.value.throughput
                dynamic dynamic_volume_size {
                    for_each = var.dynamic_volume_size != null ? [var.dynamic_volume_size] : []
                    content {
                        base_size               = dynamic_volume_size.value.base_size
                        resource                = dynamic_volume_size.value.resource
                        size_per_resource_unit  = dynamic_volume_size.value.size_per_resource_unit
                    }
                }
            }
        }
    }

    optimize_images {
        perform_at                      = var.perform_at
        time_windows                    = var.time_windows
        should_optimize_ecs_ami         = var.should_optimize_ecs_ami
    }

    ## Autoscaler Settings ##
    autoscaler {
        is_enabled                      = var.autoscaler_is_enabled
        is_auto_config                  = var.autoscaler_is_auto_config
        cooldown                        = var.cooldown
        headroom {
            cpu_per_unit                = var.cpu_per_unit
            memory_per_unit             = var.memory_per_unit
            num_of_units                = var.num_of_units
        }
        down {
            max_scale_down_percentage   = var.max_scale_down_percentage
        }
        resource_limits {
            max_vcpu                    = var.max_vcpu
            max_memory_gib              = var.max_memory_gib
        }
    }

    ## Update Policy ##
    update_policy {
        should_roll                     = var.should_roll
        roll_config {
            batch_size_percentage       = var.batch_size_percentage
        }
    }

    dynamic "scheduled_task" {
        for_each = var.scheduled_task != null ? [var.scheduled_task] : []
        content {
            shutdown_hours{
                is_enabled              = scheduled_task.value.is_enabled
                time_windows            = scheduled_task.value.time_windows
            }
            tasks {
                cron_expression         = scheduled_task.value.cron_expression
                is_enabled              = scheduled_task.value.is_enabled
                task_type               = scheduled_task.value.task_type
            }
        }
    }
}