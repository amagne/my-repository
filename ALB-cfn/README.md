# Cloudformation script for an autoscaling group with a load balancer and policy
The present project is an AWS CloudFormation script that orchestrates the creation of an autoscaling group with a load balancer and policy

The script begins by defining parameters such as subnets, VPC, key pair, and image ID. It then creates security groups for the load balancer and EC2 instances, followed by the configuration of an application load balancer with associated listener and target group.

A launch template is set up to specify the configuration for EC2 instances, including the installation of Apache server and customization of index.html file. The autoscaling group is then established, referencing the launch template and target group, with specified capacities and health checks.

Additionally, a scaling policy is defined to automatically adjust the number of instances based on CPU utilization.

Overall, this script efficiently deploys a scalable and resilient web application infrastructure on AWS.
