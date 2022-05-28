resource "aws_elastic_beanstalk_application" "timeoff_mgmt_app" {
  name        = "timeoff-management-application"
  description = "Timeoff management app"
}

# resource "aws_elastic_beanstalk_environment" "timeoff_mgmt_env" {
#   name = "timeoff-env"
#   application = aws_elastic_beanstalk_application.timeoff_mgmt_app.name
#   cname_prefix = "luisguerra-timeoff"
#   solution_stack_name = "64bit Amazon Linux 2 v3.4.16 running Docker"

#   setting {
#     namespace = "aws:autoscaling:launchconfiguration"
#     name      = "DisableIMDSv1"
#     value     = "true"
#   }

#   setting {
#     namespace = "aws:autoscaling:launchconfiguration"
#     name      = "EC2KeyName"
#     value     = "mac-key"
#   }

#   setting {
#     namespace = "aws:autoscaling:launchconfiguration"
#     name      = "IamInstanceProfile"
#     value     = "aws-elasticbeanstalk-ec2-role"
#   }

#   setting {
#     namespace = "aws:autoscaling:launchconfiguration"
#     name      = "InstanceType"
#     value     = "t2.micro"
#   }

#   setting {
#     namespace = "aws:autoscaling:launchconfiguration"
#     name      = "SSHSourceRestriction"
#     value     = "tcp,22,22,0.0.0.0/0"
#   }

#   setting {
#     namespace = "aws:autoscaling:launchconfiguration"
#     name      = "SecurityGroups"
#     value     = "${aws_security_group.app_sg.id}"
#   }

#   setting {
#     namespace = "aws:ec2:instances"
#     name      = "InstanceTypes"
#     value     = "t2.micro, t2.small"
#   }

#   setting {
#     namespace = "aws:ec2:instances"
#     name      = "SupportedArchitectures"
#     value     = "x86_64"
#   }

#   setting {
#     namespace = "aws:ec2:vpc"
#     name      = "AssociatePublicIpAddress"
#     value     = "false"
#   }

#   setting {
#     namespace = "aws:ec2:vpc"
#     name      = "ELBScheme"
#     value     = "public"
#   }

#   setting {
#     namespace = "aws:ec2:vpc"
#     name      = "ELBSubnets"
#     value     = "${module.vpc.public_subnets}"
#   }

#   setting {
#     namespace = "aws:ec2:vpc"
#     name      = "Subnets"
#     value     = "${module.vpc.private_subnets}"
#   }

#   setting {
#     namespace = "aws:ec2:vpc"
#     name      = "VPCId"
#     value     = "${module.vpc.vpc_id}"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:command"
#     name      = "IgnoreHealthCheck"
#     value     = "true"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "LoadBalancerType"
#     value     = "application"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "ServiceRole"
#     value     = "aws-elasticbeanstalk-service-role"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:environment:proxy"
#     name      = "ProxyServer"
#     value     = "nginx"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:healthreporting:system"
#     name      = "SystemType"
#     value     = "enhanced"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:managedactions"
#     name      = "ManagedActionsEnabled"
#     value     = "true"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:managedactions"
#     name      = "PreferredStartTime"
#     value     = "Sat:18:00"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:managedactions"
#     name      = "ServiceRoleForManagedUpdates"
#     value     = "aws-elasticbeanstalk-service-role"
#   }

#   setting {
#     namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
#     name      = "UpdateLevel"
#     value     = "minor"
#   }
# }