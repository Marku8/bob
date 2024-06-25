# AWS Architecture Diagram

## High-Level Description of the Architecture

### Virtual Private Cloud (VPC)
A VPC is a logically isolated network within the AWS cloud where you can launch AWS resources. It contains the following resources:

#### Public Subnet
- A subnet within the VPC that is accessible from the internet.
- Hosts resources that need to be accessible publicly, such as NAT Gateways or web servers.
- Route tables for the public subnet direct outbound traffic to the IGW.

#### Private Subnet
- Hosts resources that should not be accessible publicly, such as backend servers or databases.
- Ensures internal resources are protected from direct internet access, enhancing security.
- Route tables for the private subnet direct outbound traffic to the NAT Gateway.

### Internet Gateway (IGW)
- VPC component that allows communication between instances in the VPC and the internet.
- Provides a target in the VPC route tables for internet-routable traffic.
- Enables instances in the public subnet to communicate with the internet.

### NAT Gateway
- A managed network address translation (NAT) service.
- Allows instances in the private subnet to initiate outbound traffic to the internet without exposing them to inbound traffic.
- Provides internet connectivity for instances in private subnets without exposing them to inbound internet traffic.

### EC2 Instance
- A virtual server in AWS.
- Runs applications or other workloads.

### S3 Bucket
- Object storage service.
- Used for storing CloudTrail logs, backups, or other data securely.

### CloudTrail
- A service that enables governance, compliance, and operational and risk auditing of your AWS account.
- Logs, continuously monitors, and retains account activity related to actions across your AWS infrastructure.
- Provides visibility into user activity and API usage, ensuring compliance and detecting potential security risks.

### Security Groups
- Acts as virtual firewalls to control inbound and outbound traffic to resources.

### Route Tables
- Route tables determine how network traffic is directed within and outside of your AWS VPC.
- They route the traffic between subnets, internet gateways, virtual private gateways, NAT devices, and more.

## Security Considerations

### Internet Gateway to Public Subnet
- Instances with public access: Ensure only necessary ports are open using security groups.

### EC2 Instances in Private Subnet
- Security groups and network ACLs can be used to control traffic flow.

### Network ACLs
- A network access control list (ACL) allows or denies specific inbound or outbound traffic at the subnet level.
- Provides an additional layer of security to your VPC, similar to the rules for your security groups.

### Route Tables
- Properly configure route tables to ensure correct routing of traffic.

```
+------------------------------------------------+
|                     AWS VPC                    |
| +---------------------+  +-------------------+ |
| |  Public Subnet      |  |  Private Subnet   | |
| |  +---------------+  |  |  +--------------+ | |
| |  | Internet      |  |  |  | EC2 Instance | | |
| |  | Gateway (IGW) |  |  |  |              | | |
| |  +-------^-------+  |  |  +--------------+ | |
| +----------|----------+  +--------|----------+ |
|            |                      |            |
|            |  +--------------+    |            |
|            +->| NAT Gateway  |<---+            |
|               +-------^------+                 |
| +-----------------------------------------+    |
|                          CloudTrail            |
| | +-----------+          +---------+           |
| | | S3 Bucket | <------- | Logging |           |
| | +-----------+          +---------+           |
 +-----------------------------------------------+ 
```

## Terraform Code

### Terraform Project Structure
```
|-- main.tf
|-- variables.tf
|-- outputs.tf
```

### Documentation for Terraform Project Structure
- **vpc:** Contains resources related to VPC, subnets, IGW, NAT gateway, and route tables. Variables are used to configure the CIDR blocks and availability zone.
- **ec2:** Will contain resources related to EC2 instance configuration (not detailed here but should include instance type, AMI, key pair, etc.).
- **s3:** Will contain resources related to S3 bucket configuration (not detailed here but should include bucket policies, logging configuration, etc.).
- **cloudtrail:** Will contain resources related to CloudTrail configuration (not detailed here but should include trail creation, log delivery, etc.).

The `main.tf` file is the entry point for Terraform, and it calls the different modules, passing the necessary variables. This modular approach ensures that each component is reusable and configurable.

## Next Steps
1. **Deploy the infrastructure:** Use `terraform init`, `terraform plan`, and `terraform apply` commands to deploy the designed infrastructure.
2. **Review and Test Security Configurations:** Verify the security settings for each component and test for potential vulnerabilities.
3. **Document Any Additional Security Measures:** If additional security measures or configurations are needed based on testing, document and implement them.
