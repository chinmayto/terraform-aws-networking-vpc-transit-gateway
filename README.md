# VPC Transit Gatway connection between multiple VPCs in single region using Terraform

Deploying a VPC Transit Gatway connection between multiple VPCs in single region using Terraform

A transit gateway is a network transit hub that you can use to interconnect your virtual private clouds (VPCs) and on-premises networks. As your cloud infrastructure expands globally, inter-Region peering connects transit gateways together using the AWS Global Infrastructure. All network traffic between AWS data centers is automatically encrypted at the physical layer.

Architecture Diagram:

![alt text](/images/diagram.png)

Step 1: Create three VPCs with non-overlapping cidrs.

Step 2: Host EC2 instances in each VPC

Step 3: Create a VPC transit gateway with routes between three VPCs and TGW

Terraform Plan Output:
```
Plan: 28 to add, 0 to change, 0 to destroy.
```

Terraform Apply Output:
```
Apply complete! Resources: 28 added, 0 changed, 0 destroyed.

Outputs:

transit_gateway_id = "tgw-06f795ea438d9e040"
vpc_a_public_host_IP = "3.95.224.131"
vpc_b_public_host_IP = "54.173.114.74"
vpc_c_public_host_IP = "44.203.198.154"
```

VPCs Created with exclusive CIDRs

![alt text](/images/vpcs.png)

Transit Gateway

![alt text](/images/tgw.png)

Transit Gateway Attachments

![alt text](/images/tgwattach.png)

Transit Gateway Route Table

![alt text](/images/tgwrtable.png)

Route Tables showing rote to Transit Gateway

![alt text](/images/rtable1.png)

![alt text](/images/rtable2.png)

![alt text](/images/rtable3.png)

Connecting to VPC-B and VPC-C Instance from VPC-A Instance

![alt text](/images/vpcAtoBC.png)

Connecting to VPC-C and VPC-A Instance from VPC-B Instance

![alt text](/images/vpcBtoCA.png)

Connecting to VPC-A and VPC-B Instance from VPC-C Instance

![alt text](/images/vpcCtoAB.png)

EC2 Instances in VPC A,B and C

![alt text](/images/ec2a.png)

![alt text](/images/ec2b.png)

![alt text](/images/ec2c.png)

Terraform Destroy Output:
```
Plan: 0 to add, 0 to change, 28 to destroy.

Destroy complete! Resources: 28 destroyed.
```