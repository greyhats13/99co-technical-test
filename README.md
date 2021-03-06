# 99c-technical-test
99.co DevOps Technical Test

# Part A
1. Tell us about your main motivation to pursue a career in the software industry!
**Answer:**
I always believe that IT software industry is the next big things today. 
2. Tell us about your strengths that help your profession as a software engineer and how do
you take advantage of them to become a better engineer!
**Answer:**
- I am a fast learner. I believe with good fundamentals, good logics, and english, I can learn almost anything. So I am never afraid to invest for Linked Learning, Cloud Guru for 1 year subscription.
- I am good team player. I love to share ideas, coaching my apprentice, and join the Tech communities. It allow me to learn new things, pick some lesson, get new insights
3. Tell us about your weaknesses that give you challenges and what are your efforts to
overcome them!
- Most of the time, I forget time when working to debug an error that I can't solved for days especialy when the error is not available in Stackoverflow. So, when I feel I am in a dead end. I try to ask to the community, trying to reread the documentation, and share the error to my co-worker and ask for assistance.
- I am quite perfectionist. 
4. Tell us about the most challenging project that you have worked on and what efforts or
strategies you use to solve the problems you met in that project!
- Axis Modernization: Network Readiness. In this project, I must establish connection between AWS and XL onpremise datacenter and provision them using Terraform. I had little knowledge on Onpremise network and still green at using Terraform at the time and yet I must deliver them in strict timeline (it is about 2 weeks). My stategy was to cut my learning curves using medium.com and some in AWS docs to learn about AWS Transit Gateway, AWS S2S VPN and AWS DirectConnect.. Fortunately, I found the right use case in medium.com to deliver my task and I can make it in 2 weeks.
5. Tell us about external factors that you would consider ideal to help you become a more
effective engineer!
- Good environment and team that is open-minded and love to embrance new ideas.
- Good role model in my workplace that can help me to grow better, adapt new mindset and new framework as well as new insights.
- Company business model. I love to work on a company that make serious impact to the society. It encourages me to give my best. 
6. Tell us about how you see yourself in the next five years in software industry!
- I would love to see myself as Head of Engineer in the next five years or at least as DevOps Lead. So I can design the company technology roadmap for product, app, and infrastructure that is really fit the business model and user demand as well as adapting to the latest tech and in-line with industry best practises.
7. What do you think about DevOps ?
- DevOps is a culture that break the silo between Ops and Development. DevOps isn't simply adopting agile, CI/CD, automation, even those practices are certainly important. For me, DevOps is all about a shared understanding between developers and ops, and share responsibility for the software we build. It means increasing collaboration and transparancy across development, Ops, and business. DevOPs allow us to deliver product fast. If we go fast we are very likely to break things but we will break small.

# Part B
Part B
These are very simple technical questions to give us a bit overview on linux and computer network
skills.
1. When setting up a new website, the web can???t be accessed. On the Nginx error log returns
*/var/www/html/index.html is forbidden (13: Permission denied).*

Doing an ls -la on /var/www/html returns the following result:
```console
/var/www/html$ ls -al
total 12
drwxr-xr-x 2 root root 4096 Jul 8 09:47 .
drwxr-xr-x 3 root root 4096 Mei 29 11:27 ..
---------- 1 root root 612 Mei 29 11:27 index.html
```
Explain how you would solve this issue as detailed as you need it to be. Feel free to add
assumptions as needed.
**Answer:**

It is obvious that apache is lack of permission to read the index.html file.
The index.html is owned by root. It is not recommended settings.
It is likely that nginx doesnt belong to www-data group.
We can add nginx user to www-data group by issuing this command:
```console
sudo usermod -a -G www-data nginx
```
To verify that nginx is a part of www-data group, we can issue command:
```console
id nginx
```
It is recommended that the /var/www/html and the file inside belong to *www-data* group and user.
```console
sudo chown -R www-data:www-data /var/www/html
```
To align with the best practise, we should assign the 775 permission to the /var/www/html directory.
In numerical mode, if we map the number to the binary, 775 would stands for
```
Owner:  7 - 111 - read, write, and execute
Group:  5 - 101 - read and execute
Others: 5 - 101 - read and execute
```
Last but not least, /var/www/html/index.html must be assigned 644 permission
and 644 permission to the index.html which means
```
Owner:  6 - 110 - read and write,
Group:  4 - 100 - read only,
Others: 4 - 100 - read only
```
We can accomplished those in one command line below:
```console
sudo chmod /var/www/html 775 && sudo 644 chmod /var/www/html/index.html
```
Eventually, we can assure that Nginx will no longer encounter *permission denied* issue and our solution have followed the best practises.

2. There???s a production database on server A that can only be accessed from server B. A
database engineer needs to access the database regularly on server A but only has the
permission to connect to server B. Explain how you would set the environment for the
database engineer to connect to server A. You can be as detailed as possible and use
assumptions for the information that???s not given here.

**Answer:**

**Assumption**

Let's assume that the production server is 
- running in the public cloud AWS, 
- Database is managed Amazon RDS and running in port 3306, 
- and database engineer client is using Linux or MacOs, 
- Organization VPN IP range is 206.189.38.216/29
- VPC CIDR 10.0.0.0/16, Public Subnet CIDR: 10.0.0.0/24, Private Subnet: 10.0.1.0/24
- We must setup the environment as secure as possible. Server B will act as Bastion host and it will be placed in public subnet that is routed to the internet gateway
- Server A itslef will be placed in private subnet that will be routed to NAT gateway, and NAT gateway itself is routed to the internet gateway. So server A can't be accessed outside, but can perform update/patch to the internet. 
- Server A must be secured as possible.

The proposed solution based on assumption is depicted below.
<p align="center">
  <img src="img/database.svg" alt="database">
</p>

* Setup Database engineer client to Server B.

A database engineer have access to server B means ,at least, he/she has SSH access to the production server.
However, we want the database engineer to establish secure connection to the server B.
Database engineer need his/her own SSH key using OpenSSH using *ssh-keygen*.
His/Her private key must be assign with *chmod 400 ~/.ssh/id_rsa* and then put his/her public key to the *~/.ssh/authorized_keys* in server B.

* Restrict IP access to the Server B

Due to server B is accessible through the internet, Server B access must be limited to spesific public IP range that belong to the organization/company. As we assume that the server is running in the cloud, we can restrict the access to the server B using security group (firewall) to only allow inbound rule TCP 22 and 206.189.38.216/29.

* Server B access to the Server A (Production DB)

If Server A is our self-hosted MySQL database. We can allow Server B private IP to access TCP 22 to server A, but server A can be accessed with TCP 3306 (MySQL Port) from the internal network or VPC (Virtual Private Cloud) so the application can access the Server A.
As we assumed that the server A is managed database Amazon RDS. It is pretty unlikely that managed database allow SSH access the instance. So we must only allow the TCP 3306 open to the internal network or VPC.

* Secure database server A in transit and at rest.

As we know that, threat doesnt come not only from outside the organization, but it come come from inside such as internal malicious actor. So
we must secure our production DB both in transit and at rest. Our Database connection must enforce SSL/TLS to encrypt our connection to Production database. 
```console
mysql -u <DB_USER> -h <DB_HOST> -P 3306 ???ssl-ca=~/ssl-client/ca.pem ???ssl-cert=~/ssl-client/client-cert.pem ???ssl-key=~/ssl-client/client-key.pem -p<DB_PASS>
```
We must also encrypt our database storage using KMS (key management service).

3. Assume we have setup a service with the following layers:
<p align="center">
  <img src="img/502-bad-gateway.png" alt="502 bad gateway">
</p>

When the client receives error **502 Bad Gateway** , how would you like to troubleshoot to fix
the issue to point out the root problem? You can be as detailed as possible and use
assumptions for the information that???s not given here.

**Answer:**

**Assumption**
- The solution diagram proposed is deployed in AWS
- The firewall is using AWS Security Group
- PHP application is running on port 8080
- Virtual machine is running Ubuntu OS.

We can actually print the nginx log to figure out the problem by issuing this command:

```console
sudo tail -30 /var/log/nginx/error.log
```
However, let us identify the problem in every layer that might exist:

**Firewall**
- If the php application port behind nginx load balancer is blocked by the firewall security group. It is likely the nginx will throw an error
So, the security group inbound role must allow TCP 8080 to the load balancer.

**Nginx Configuration**
- Nginx configuration must proxy pass *http://localhost:8080/* 
we can check the nginx default configuration by issuing the command:
```console
sudo cat /etc/nginx/sites-enabled/default
```
Let's assume that the configuration output would be like this.
```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html
    index index.php index.html;
    server_name _;
    location / {
      proxy_set_header X-Request-Id $request_id;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header Host $host;
      proxy_pass http://localhost:8080/;
    }
}
```
**PHP Backend Service**
- If the backend service failed, Nginx will not received any data from it. It will result the 502 bad gateway because nginx is depend on backend service. We can restart the application to make the application work by issuing the following command.

```console
 kill -9 $(pgrep php-fpm)
 service php7-fpm restart
```

# Part C

This part helps us to understand how you would design and build a scalable system that could
serve millions of users per month.

<p align="center">
  <img src="img/part-c-diagram.png" alt="part c diagram">
</p>

Let???s imagine we are going to build a Restful API system that can be accessed securely from the
public, fast enough to respond with sufficient body size, and minimum down time (SLA 99.9%).
The system also will use common relational databases (such as MySQL, PostgreSQL). With those
conditions, tell us:

- how you would design the system given the requirements
- what technologies (open source or 3rd party) you are going to use
- how you would setup the deployment and namespacing strategy for each repo (1 colour is
1 repo, so there are 4 repos on the diagram); and
- the strategy/approach that you are going to use to handle high usage but keep the system
reaching uptime 99.9%.

Assume your solution is set up on Kubernetes in AWS EKS (don???t set up the
solution on real infrastructure by the way!!!). You can use diagrams to help illustrate your
explanation. Feel free to add assumptions.

**Answer:**

# A. Infrastructure Diagram
Here's diagram for the propposed solution
<p align="center">
  <img src="img/infrastructure-diagram.svg" alt="Infrastructure Diagram Images">
</p>
Image Link: https://lucid.app/lucidchart/2237664e-6e48-4393-b33c-91216df6e8de/edit?viewport_loc=478%2C42%2C3328%2C1646%2C0_0&invitationId=inv_639fc3d3-d6ad-45d3-800e-a0f01f6a23bb

# Assumption
Based what have been designed on the diagram.
- The solution is deployed on AWS
- Backend service is using golang and PHP
- Frontend service is using reactjs
- FrontEnd Service J, K, L, M and Backend service N, P, Q, R is legacy service because not leveraging API gateway.
- The infrastructure is deployed in AWS ap-southeast-1 region
## a. The design of our infrastructure based on systemr requirment:
Here's diagram for the propposed solution
<p align="center">
  <img src="img/infrastructure-diagram.svg" alt="Infrastructure Diagram Images">
</p>

# B. Technology Stack
- AWS for public cloud
- All our services will use docker container both backend and frontend.
- Kubernetes for Container orchestration
- Helm for kubernetes deployment
- Our Docker registry will use Amazon ECR.
- Github for SCM, and AWS Codepipeline with AWS Codebuild to build our containerized application, tag, and push them to Docke Registry
- Weave Flux for CD that is aligned with GitOps principle
- ElasticCloud for Observability such as realtime monitoring, analytics, APM, and logging.
- Flagger and Istio for service mesh and canary deployment.

## C. Setup deployment and namespace strategy
- There would be 4 namespace in our kubernetes for services which is
  1. backend (service e,f,g, h)
  2. frontend (service a,b,c,d)
  3. backend-legacy (service n,p,q,r)
  4. frontend-legacy (service j,k,l,m)
- There are 4 repositories and  contain 4 service in ea repository. Let's say the name of the repository is 99c-backend. We will set up deployment strategy for 99-backend for instance.
  1. 99-backend/service-e
  2. 99-backend/service-f
  3. 99-backend/service-g
  4. 99-backend/service-h
99c-backend will have 4 directory. So, our pipeline code will be on the root folder. 
- Our pipeline code in buildspec.yml (using AWS codebuild) will need to check which directory files that have changed in recent commit. We can use *git diff HEAD..<commit_hash>* to get the information. Piping  to filet the result with the associated service, and run the pipeline for that service:
```yaml
        if [ "$(git diff HEAD..$PREV | grep "diff --git" | grep "/services_e/")" != "" ]; then
          echo "Build, Tag, and Push Services F" &&
          cd $CODEBUILD_SRC_DIR/services_e &&
          cd $CODEBUILD_SRC_DIR/services_e/ &&
          docker build -t $SERVICE_E_URI:latest -f Dockerfile . &&
          docker tag $SERVICE_E_URI:latest $SERVICE_E_URI:$IMAGE_TAG &&
          docker push $SERVICE_E_URI:latest &&
          docker push $SERVICE_E_URI:$IMAGE_TAG &&
          cd helm &&
          helm lint helm/* &&
          cd helm/ && 
          helm package chart/ &&
          helm repo index --url=https://99co.github.io/service-e/helm/ .
        fi
```

Detail implementation can be seen in CI/CD section
Our Continous Integation will need to have conditional to detect changes 

## D. The strategy/approach that you are going to use to handle high usage but keep the system reaching uptime 99.9%.

- Our infrastructure must be highly available, fault tolerant, redundat that is designed for failure.
- All of our infrastructure must be elastic. It can scale automatically based on resources usage as the bussiness perform e.g running massive ads or event. The scaling must be placed in every layer such as Application workload, Horizontal Pod Autoscaling, Database Autoscaling,etc. So there will be no scenario our application is lack of resource.
- For mission critical, our infrastructure mas have Disaster Recovery Plan. To achieve high Recovery Point Objective and Recovery Time Obective under five minutes, we will implement Multi Site Strategy where our infrastructure is replicated to another region with the same workload class and Perform Region DNS Healthcheck (Route53).
- Our application must be able to self-healing due to any issues or error. We will deploy as container (docker) in kubernetes. Our docker images must align with DevOps Lean principle. We are using Alpine for our backend for Lean architecture. So, it can build, deploy, and heal faster for pod scheduling.
- We will implement circuit breaker and advance deployment strategy such as canary that can shift traffic to new application gradually. Should the application encounter major bugs, it won't impact that much because we can rollback to previous version. We need to implement Istio for canary deployment using Flagger for traffic shifting.
- We will secure our infrastructure at every layer as possible. Good security will mantain good SLA form any malicious actor that can compromise our application.
  - Strict Firewall in Security Group
  - Secure data in transit (SSL/TLS) and at rest by encript our storages
  - Implement API Gateway for rate limit, IP restriction, WAF,etc
  - Implement Service Mesh using Istio, so we can secure our inter-service communication even using SSL/TLS. also provide end-to-end visibility  for fine-grained metrics. Istio also can help for traffic shifting.
- Increase application performant database and cache, and also message broker(Kafka) to decoupling our services.

# IMPLEMENTATION OF THE DESIGN

Here is the part for implementation. Including code and fine-grained design. It won't cover all the details such as Disaster recovery Plan, Canary Deployment Istio for code implementaiton,etc.

## KEYPOINT
- Application, Redis, MySQL Database, and Kafka workload are deployed in two availability zones ap-southeast-1a and ap-southeast-1b to provide high availability, and fault tolerance
- All our infrastructure is designed elastically. The infrastructure will scale seamlessly should the bussiness perform such as massive ads that bring high traffics from million users.
- The infrastructure is designed for Disaster Recovery Plan with Multi Site Strategy. Thus, Region-wide failure will keep our application up. Our Route53 Healthcheck will make sure our application uptime reach 99.999%.
- The Infrastructure adopt naming standardization for all our cloud resources using
  - var.unit = It represent the business unit code e.g 99c (99.co)
  - var.code = it represent the service domain code e.g service
  - var.feature = it represent the service domain feature e.g e, f, g, h, etc
  - var.env = it represent the our staging environment.
- Infrastructure is secured by encrypting data in transit using SSL/TLS, and at rest using AWS KMS to encrypt our storages such as block(EBS) and object storages (S3)
- Kubernetes microservice is also implemented Horizontal Pod Autoscaler with minimum 2 and maximum 256 pod and will distributed in two AZs.
- Our kubernetes also will deploy Kong as ingress controller. By doing that, we can leverage Kong API gateway and its plugin for authentication in API gateway, rate limited, Geo IP restriction, etc.
- Our infrastructure and application will use ElasticCloud for observability. We will deploy filebeat as log aggregator and metricbeats as Daemon set. Filebeat will forward our log to Logstash. Logstash will parse our STDOUT using Grok Pattern to Elastic Document JSON to store in Elastic Search. So, we can query our them using Kibana to create Insightful Dashboard. We also will deployed APM Server to our EKS cluster.
- Our Continous Integration will leverage Github as SCM, AWS Codepipeline and AWS Codebuild for Continous delivery to produce docker images and push to ECR
- We will implement the Gitops for our continous delivery (Pull Model) using Flux. Flux will read our helm manifest that is stored on Github as the single source of truth. Flux will deployed desired state from Git to the actual state (k8s). It can also detect drift that will restore our actual state to the desired sate on git.
- We only cover sample code in Readme, you can explore more details code based on their directory accordingly


## Infrastructure Deployment
All our infrastructure will be deployed using Terraform. To aligh with GitOps princle, We will leverage Atlantis as Terraform CI/CD. As we use Weave Flux for Application deployment, git will be the source of truth.

Atlantis will detect any changes for adding new resources.
Here is the sample configuration for atlantis.yaml. Atlantis will detect changes on directory that is listed her in every Pull Request.
```yaml
version: 3
projects:
  - dir: service-deployment/99c-service-e
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
  - dir: service-deployment/99c-service-f
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
  - dir: service-deployment/99c-service-g
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
  - dir: service-deployment/99c-service-h
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
  - dir: cloud-deployment/vpc
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
  - dir: cloud-deployment/eks
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
  - dir: cloud-deployment/elasticache
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
  - dir: cloud-deployment/rds
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
```
All cloud and service deployment will invoke from terraform module that we create in module directory.
It is an example for adding CLoud deployment Amazon Elastic Kubernetes Service.

```yaml
- dir: cloud-deployment/eks
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
```
If we want to add new service, we can add this line below:
```yaml
- dir: service-deployment/99c-service-e
    apply_requirements: ["approved","mergeable"]
    autoplan:
      when_modified: ["*.tf*"]
      enabled: true
```

Service deployment will automatically provision the service Docker Registry ECR, CI/CD Codepipeline, Codebuild, etc.
If developer want to add new services for example. Developer will need to clone the terraform code. Add new atlantis config in atlantis.yaml. Furthermore, they will need to make PR request with Jira ticket as their branch name e.g OPS-001.
Atlantis will automatically will print the terraform plan for our new infra and services.
DevOps team then will review the changes on their Pull Request. After DevOps team approved the PR. Developer can then comment atlantis apply to apply the plan.
Unlike Weave Flux, Atlantis can revert the actual state to desired state based on Github if we perform infrastructure changes outside atlantis.

## Network
Here's our infrastructure terraform  for our AWS network.
Our VPC CIDR will use: **10.0.0.0/16**
The subnet CIDR will be derived using Terraform function
```terraform
cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1 * (length(data.aws_availability_zones.az.names)-1))
```
to generate **10.0.x.0/24 subnet CIDR block equally for public, node, app, and data nodes equally.
We also have configured the routing to NAT and Internet Gateway.
- Our kubernetes node worker be placed in node subnet
- Our kubernetes app (pod) will be placed in app subnet
- Last but not least, our Amazon Aurora MySQL, Elasticache Redis, and Our MSK Kafka will be placed in data subnet accordingly.
- Our subnet will span for two Availability Zones to provide High Availability and Fault Tolerance.

## Network Terraform Modular codes
It contains the terraform code for module and cloud deployment
### Network Module
All the code on network modules. This module will be invoke for cloud network deployment
**terraform/modules/network/variables.tf**
```terraform

**modules/network/vpc.tf**
```terraform
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature[0]}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[0]
    "Creator" = var.creator
  }
}
```
**terraform/modules/network/subnet.tf**
```terraform
data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_subnet" "public" {
  count             = length(data.aws_availability_zones.az.names) - 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 0 * (length(data.aws_availability_zones.az.names)-1))
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}-public-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = "subnet"
    "Sub"     = "${var.sub[1]}-public"
    "Zones"   = element(data.aws_availability_zones.az.names, count.index)
  }
}

resource "aws_subnet" "node" {
  count             = length(data.aws_availability_zones.az.names) - 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1 * (length(data.aws_availability_zones.az.names)-1))
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
  tags = {
    "Name"                                                  = "${var.unit}-${var.env}-network-subnet-node-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"                                                   = var.env
    "Code"                                                  = var.code
    "Feature"                                               = "subnet"
    "Sub"                                                   = "node"
    "Zones"                                                 = element(data.aws_availability_zones.az.names, count.index)
    "kubernetes.io/cluster/${aws_eks_cluster.cluster.name}" = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[0]}"
  }
}

resource "aws_subnet" "app" {
  count             = length(data.aws_availability_zones.az.names) - 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 2 * (length(data.aws_availability_zones.az.names)-1))
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}-app-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
    "Sub"     = "${var.sub[1]}-app"
    "Zones"   = element(data.aws_availability_zones.az.names, count.index)
  }
}

resource "aws_subnet" "data" {
  count             = length(data.aws_availability_zones.az.names) - 1
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 3 * (length(data.aws_availability_zones.az.names)-1))
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}-data-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
    "Sub"     = "${var.sub[1]}-data"
    "Zones"   = element(data.aws_availability_zones.az.names, count.index)
  }
}
```

**terraform/modules/network/igw.tf**
```terraform
resource "aws_internet_gateway" "igw" {
  vpc_id   = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.unit}-${var.env}-${var.code}-${var.feature[2]}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[2]
    "Creator" = var.creator
  }
}
```

**terraform/modules/network/nat.tf**
```terraform
resource "aws_eip" "eip" {
  count = var.total_eip
  vpc   = true

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature[3]}-${count.index}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[3]
    "Creator" = var.creator
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(aws_subnet.public_subnet)
  allocation_id = element(aws_eip.eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature[4]}-${element(data.aws_availability_zones.az.names, count.index)}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[4]
    "Creator" = var.creator
    "Zones"   = element(data.aws_availability_zones.az.names, count.index)
  }
}
```

**terraform/modules/network/route.tf**
```terraform
#Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature[5]}-public"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[5]
    "Creator" = var.creator
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

#App Route Table
resource "aws_route_table" "app_rt" {
  count    = length(aws_subnet.app_subnet)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature[5]}-app"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[5]
    "Creator" = var.creator
  }
}

resource "aws_route_table_association" "app_rta" {
  count          = length(aws_subnet.app_subnet)
  subnet_id      = element(aws_subnet.app_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.app_rt.*.id, count.index)
}

resource "aws_route_table_association" "cache_rta" {
  count          = length(aws_subnet.cache_subnet)
  subnet_id      = element(aws_subnet.cache_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.cache_rt.*.id, count.index)
}

#Database Route Table
resource "aws_route_table" "data_rt" {
  count    = length(aws_subnet.db_subnet)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature[5]}-data"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature[5]
    "Creator" = var.creator
  }
}

resource "aws_route_table_association" "data_rta" {
  count          = length(aws_subnet.db_subnet)
  subnet_id      = element(aws_subnet.db_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.db_rt.*.id, count.index)
}
```

### Cloud Deployment: Network. 
The module code above then will be invoked in Cloud Deployment - Network
```terraform
module "vpc" {
  source               = "../../modules/network"
  region               = "ap-southeast-1"
  unit                 = "99c"
  env                  = "prd"
  code                 = "network"
  feature              = "vpc"
  sub                  = ["main", "subnet", "nat-gw", "igw", "rt"]
  creator              = "tf"
  vpc_cidr             = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}
```

## EKS Terraform Modules codes
It contains the terraform code for module and cloud deployment
### EKS Module
The terraform code is based on our infrastructure diagram. In this code, we have implemented Node autoscaling with minimum 4 nodes and maximumm 256 nodes. It will scale should the business perform when running massive ads. Our EKS infrastructure will guarantee SLA 99.9% from our infrastructure deisgn.

**terraform/modules/compute/eks/eks.tf**
```terraform
resource "aws_iam_role" "eks_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[0]}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks_pods_sg_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_role.name
}

resource "aws_eks_cluster" "cluster" {
  name     = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[0]}"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = data.terraform_remote_state.network.outputs.network_app_subnet_id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_attachment,
    aws_iam_role_policy_attachment.eks_pods_sg_attachment,
  ]
}
```

**terraform/modules/compute/eks/node-groups.tf**
Our node group is on-demand.
```terraform
resource "aws_iam_role" "node_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_ecr_policy_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

resource "aws_eks_node_group" "ondemand" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.unit}-${var.env}-${var.code}-${var.feature}-${var.sub[1]}"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.terraform_remote_state.network.outputs.network_app_subnet_id
  scaling_config {
    desired_size = 4
    max_size     = 32
    min_size     = 4
  }

  update_config {
    max_unavailable = 2
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy_readonly,
  ]
}
```

**terraform/cloud_deployment/eks/main.tf**
Here's the implementation using module EKS.
```terraform
module "eks" {
  source                           = "../../modules/compute/ecs"
  region                           = "ap-southeast-1"
  unit                             = "99c"
  env                              = "prd"
  code                             = "compute"
  feature                          = ["eks"]
}
```

## Amazon RDS: MySQL
Our Aurora MySQL is 5x times performance compared to general MySQL engine. It also has been designed elastically, so it can scale elastically should the business perform. We have implement AWS App Autoscaling for Aurora RDS Read Replica.
Our database production also have been secured in transit using SQL so the application is enforced to use SSL connection and at rest using KMS to encrpyt the storages. Our database can only be accessed from internal VPC network.

**terraform/modules/compute/rds/aurora.tf**
```terraform
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier                  = "${var.unit}-${var.env}-${var.code}-${var.feature}-cluster-${var.region}"
  engine_mode                         = var.engine_mode
  engine                              = var.engine
  engine_version                      = var.engine_version
  availability_zones                  = [data.aws_availability_zones.az.names[0], data.aws_availability_zones.az.names[1]]
  master_username                     = var.master_username
  master_password                     = random_password.aurora_password.result
  port                                = var.port
  db_subnet_group_name                = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids              = [aws_security_group.sg.id]
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  preferred_backup_window             = var.preferred_backup_window
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-cluster"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      engine_version
    ]
  }
}

resource "aws_iam_role" "monitoring_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "monitoring_attach_policy" {
  role       = aws_iam_role.monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                           = var.number_of_instance
  identifier                      = "${var.unit}-${var.env}-${var.code}-${var.feature}-instance-${element(data.aws_availability_zones.az.names, count.index)}-${count.index}"
  cluster_identifier              = aws_rds_cluster.aurora_cluster.id
  instance_class                  = var.instance_class
  engine                          = aws_rds_cluster.aurora_cluster.engine
  engine_version                  = aws_rds_cluster.aurora_cluster.engine_version
  db_parameter_group_name         = aws_db_parameter_group.db_parameter_group.id
  promotion_tier                  = count.index
  availability_zone               = element(data.aws_availability_zones.az.names, count.index)
  ca_cert_identifier              = var.ca_cert_identifier
  tags = {
    "Name"    = "${var.unit}-${var.env}-${var.code}-${var.feature}-instance-${element(data.aws_availability_zones.az.names, count.index)}-${count.index}"
    "Env"     = var.env
    "Code"    = var.code
    "Feature" = var.feature
  }
}

resource "aws_appautoscaling_target" "autoscaling_target" {
  service_namespace  = var.service_namespace
  scalable_dimension = var.scalable_dimension
  resource_id        = "cluster:${aws_rds_cluster.aurora_cluster.id}"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

resource "aws_appautoscaling_policy" "autoscaling_policy" {
  name               = "${var.unit}-${var.env}-${var.code}-${var.feature}-autoscaling-policy"
  service_namespace  = aws_appautoscaling_target.autoscaling_target.service_namespace
  scalable_dimension = aws_appautoscaling_target.autoscaling_target.scalable_dimension
  resource_id        = aws_appautoscaling_target.autoscaling_target.resource_id
  policy_type        = var.policy_type

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }

    target_value       = var.target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}
```

**terraform/cloud_deplyment/rds/main.tf**

```terraform
terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-compute-rds-aurora-prd.tfstate"
    profile = "99c-prd"
  }
}

module "rds" {
  source                              = "../../modules/compute/rds"
  region                              = "ap-southeast-1"
  unit                                = "99c"
  env                                 = "prd"
  code                                = "compute"
  feature                             = "aurora"
  parameter_group_family              = "aurora-mysql5.7"
  engine_mode                         = "provisioned"
  engine                              = "aurora-mysql"
  engine_version                      = "5.7.mysql_aurora.2.10.0"
  master_username                     = "root"
  port                                = 3306
  backup_retention_period             = 5
  allow_major_version_upgrade         = true
  enabled_cloudwatch_logs_exports     = ["error", "general", "slowquery"]
  number_of_instance                  = 2 #for 1 write and 1 read
  instance_class                      = "db.r5x.large"
  monitoring_interval                 = 60
  ca_cert_identifier                  = "rds-ca-2019"
  scalable_dimension                  = "rds:cluster:ReadReplicaCount"
  service_namespace                   = "rds"
  min_capacity                        = 2
  max_capacity                        = 15
  policy_type                         = "TargetTrackingScaling"
  predefined_metric_type              = "RDSReaderAverageDatabaseConnections"
  target_value                        = 750  #750 connection for 16gb memory
}
```

## Continous Integration (Codepipeline) and Continous Delivery (Flux) using GitOps
Our Continous Integration leverage AWS codepipeline with Codebuild and Github as the Source Control Management.

Our Continous Delivery will adopt GitOps principle and Pull Model where Git would be the single source of truth. Our Continous Integration will use AWS Codepipeline and Codebuild to produce the artifact. Our CD will use Weave Flux. We will bootstrapping flux to our K8s cluster so Flux controller such as Source Controller and Helm controller will handle the deployment automatically. Flux will keep sync to our Github to examine the desired state, and automatically will deploy to the actual state  to our k8s cluster.
Here's our CI/CD diagram for the proposed solution

## Add new service using Terraform
As we add new service, we will need to provisione our Continous integration for our services such as Codebuild, codepipeline, and ECR repository for our services using Terraform.

**terraform/modules/service/codebuild.tf**
```terraform
resource "aws_iam_role" "codebuild_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_attach_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" #not best practise, for testing purpose
}

resource "aws_codebuild_project" "build_project" {

  name          = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = 60

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "STAGE"
      value = "BUILD"
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }

    environment_variable {
      name = "SERVICE_NAME"
      value = "${var.unit}-${var.env}-${var.code}-${var.feature}"
    }
  }

  cache {
    type = "LOCAL"
    modes = [
      "LOCAL_CUSTOM_CACHE",
      "LOCAL_DOCKER_LAYER_CACHE",
      "LOCAL_SOURCE_CACHE"
    ]
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  vpc_config {
    vpc_id             = data.terraform_remote_state.network.outputs.network_vpc_id
    subnets            = data.terraform_remote_state.network.outputs.network_app_subnet_id
    security_group_ids = [aws_security_group.sg.id]
  }
}
```

**terraform/modules/service/codepipeline.tf**
```terraform
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.unit}-${var.env}-${var.code}-${var.feature}-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" #not best practise, for testing purpose
}

resource "aws_codepipeline" "codepipeline" {
  name       = "${var.unit}-${var.env}-${var.code}-${var.feature}"
  role_arn   = aws_iam_role.codepipeline_role.arn
  depends_on = [aws_codebuild_project.build_project]

  artifact_store {
    location = data.terraform_remote_state.s3.outputs.s3_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["Source"]

      configuration = {
        Owner                = data.aws_ssm_parameter.github_owner.value
        OAuthToken           = data.aws_ssm_parameter.github_token.value
        Repo                 = github_repository.repo[0].name
        Branch               = "main"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["Source"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }
}
```

**terraform/modules/service/ecr.tf**
```terraform
##### ECR
resource "aws_ecr_repository" "ecr" {
  name        = "${var.unit}-${var.env}-${var.code}-${var.feature}"
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_php.name
  policy     = data.template_file.ecr_lifecycle_policy.rendered
}
```

**terraform/modules/service/github.tf**
```terraform
provider "github" {
  token        = data.aws_ssm_parameter.github_token.value
  owner        = data.aws_ssm_parameter.github_owner.value
}

resource "aws_codepipeline_webhook" "codepipeline_webhook" {
  name            = "webhook-codepipeline-${var.unit}-${var.env}-${var.code}-${var.feature}"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline.name

  authentication_configuration {
    secret_token = "webhook-secret-${var.unit}-${var.env}-${var.code}-${var.feature}"
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/main"
  }
}

resource "github_repository_webhook" "github_webhook" {
  repository = "99co-backend"
  configuration {
    url          = aws_codepipeline_webhook.codepipeline_webhook.url
    content_type = "json"
    insecure_ssl = true
    secret       = "webhook-secret-${var.unit}-${var.env}-${var.code}-${var.feature}"
  }
  events = ["push"]
}
```

Here's the example adding service-e:

**terraform/service_deployment/service-e/main.tf**
```terraform
module "deployment" {
  source                   = "../../modules/service"
  region                   = "ap-southeast-1"
  unit                     = "99c"
  env                      = "prd"
  code                     = "service"
  feature                  = "e"
}
```

<p align="center">
  <img src="img/ci-cd-diagram.png" alt="CI CD Diagram">
</p>

## Continous Integration
We have four repositories:

1. frontend -> services A, B, C, D
2. backend -> services E, F, G, H
3. frontend legacy -> J, K, L, M
4. backend legacy -> N, P, Q, R

Every repository will contain services folder name.
For instance for backend repository will contain four folder which is
- service_e
- service_f
- service_g
- service_h

Each service folder will have their own Dockerfile.

Sample Dockerfile for service E that located at /service_e/Dockerfile using Golang.
```dockerfile
FROM golang:1.15.2-alpine3.12 AS builder

RUN apk update && apk add --no-cache git

WORKDIR $GOPATH/src/service_e/

RUN go get github.com/go-sql-driver/mysql && go get github.com/gin-gonic/gin && go get github.com/jinzhu/gorm

COPY . .

RUN GOOS=linux GOARCH=amd64 go build -o /go/bin/service_e

FROM alpine:3.12

RUN apk add --no-cache tzdata

COPY --from=builder /go/bin/book /go/bin/service_e

#Just for an example. The environment variables will be defined in Configmap helm.
ENV PORT 8080
ENV DB_USER service_e
ENV DB_PASS pass
ENV DB_HOST db.99.co
ENV DB_PORT 3306
ENV DB_NAME service_e

EXPOSE 8080

ENTRYPOINT ["/go/bin/service_e"]
```

# Buildspec for our CI in Codebuild
Each repositories contain 4 services. So, Our CI need to detect which service directory that has changed. Our strategy to handle this is
- Check the different between Head and working directory in current commit
- if the file is changed in service_e, then our Codepipeline will build, tag, and push our docker image service to ECR.
- Perform helm lint, helm packages, and helm repo --index
- We can make our repository as Helm repository using Github Pages. It is not recommended, it is solely for simplicity in this technical test.

```yaml
version: 0.2
phases:
  install:
    commands:
      - echo install steps...
  pre_build:
    commands:
      - ls -la

      - echo Check AWS, Git, Python version
      - aws --version && git --version
      - echo Check ENV Variable
      - printenv
      - echo Logging into AWS ECR...
      - $(aws ecr get-login --no-include-email --region ap-southeast-1)
      - SERVICE_E_URI=xxxxxxxxxxxx.dkr.ecr.ap-southeast-1.amazonaws.com/99c-service-e-prd
      - SERVICE_F_URI=xxxxxxxxxxxx.dkr.ecr.ap-southeast-1.amazonaws.com/99c-service-f-prd
      - SERVICE_G_URI=xxxxxxxxxxxx.dkr.ecr.ap-southeast-1.amazonaws.com/99c-service-g-prd
      - SERVICE_G_URI=xxxxxxxxxxxx.dkr.ecr.ap-southeast-1.amazonaws.com/99c-service-h-prd
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=${COMMIT_HASH:=latest}
  build_push:
    commands:
      # Get Commit Hash from SCM
      - PREV=$(cat $CODEBUILD_RESOLVED_SOURCE_VERSION)
      # Check the different between Head and working directory in commit
      # Check the filechanged in which directory on Repository Backend
      # If the filechanged detect at /services_e for instances. CD to /services_e directory  and start build, tag, and push to Docker Registr ECR
      - |
        if [ "$(git diff HEAD..$PREV | grep "diff --git" | grep "/services_e/")" != "" ]; then
          echo "Build, Tag, and Push Services F" &&
          cd $CODEBUILD_SRC_DIR/services_e &&
          cd $CODEBUILD_SRC_DIR/services_e/ &&
          docker build -t $SERVICE_E_URI:latest -f Dockerfile . &&
          docker tag $SERVICE_E_URI:latest $SERVICE_E_URI:$IMAGE_TAG &&
          docker push $SERVICE_E_URI:latest &&
          docker push $SERVICE_E_URI:$IMAGE_TAG &&
          cd helm &&
          helm lint helm/* &&
          cd helm/ && 
          helm package chart/ &&
          helm repo index --url=https://99co.github.io/service-e/helm/ .
        fi
      - |
        if [ "$(git diff HEAD..$PREV | grep "diff --git" | grep "/services_f/")" != "" ]; then
          echo "Build, Tag, and Push Services F" &&
          cd $CODEBUILD_SRC_DIR/services_f &&
          cd $CODEBUILD_SRC_DIR/services_f/ &&
          docker build -t $SERVICE_F_URI:latest -f Dockerfile . &&
          docker tag $SERVICE_F_URI:latest $SERVICE_E_URI:$IMAGE_TAG &&
          docker push $SERVICE_F_URI:latest &&
          docker push $SERVICE_F_URI:$IMAGE_TAG &&
          cd helm &&
          helm lint helm/* &&
          cd helm/ && 
          helm package chart/ &&
          helm repo index --url=https://99co.github.io/service-f/helm/ .
        fi
      - |
        if [ "$(git diff HEAD..$PREV | grep "diff --git" | grep "/services_g/")" != "" ]; then
          echo "Build, Tag, and Push Services G" &&
          cd $CODEBUILD_SRC_DIR/services_g &&
          cd $CODEBUILD_SRC_DIR/services_g/ &&
          docker build -t $SERVICE_G_URI:latest -f Dockerfile . &&
          docker tag $SERVICE_G_URI:latest $SERVICE_E_URI:$IMAGE_TAG &&
          docker push $SERVICE_G_URI:latest &&
          docker push $SERVICE_G_URI:$IMAGE_TAG &&
          cd helm &&
          helm lint helm/* &&
          cd helm/ && 
          helm package chart/ &&
          helm repo index --url=https://99co.github.io/service-g/helm/ .
        fi
      - |
        if [ "$(git diff HEAD..$PREV | grep "diff --git" | grep "/services_h/")" != "" ]; then
          echo "Build, Tag, and Push Services H" &&
          cd $CODEBUILD_SRC_DIR/services_h &&
          cd $CODEBUILD_SRC_DIR/services_h/ &&
          docker build -t $SERVICE_H_URI:latest -f Dockerfile . &&
          docker tag $SERVICE_H_URI:latest $SERVICE_E_URI:$IMAGE_TAG &&
          docker push $SERVICE_H_URI:latest &&
          docker push $SERVICE_H_URI:$IMAGE_TAG &&
          cd helm &&
          helm lint helm/* &&
          cd helm/ && 
          helm package chart/ &&
          helm repo index --url=https://99co.github.io/service-f/helm/ .
        fi
```
# Helm Chart
Our kubernetes will use Helm chart. Flux controller will use the chart as our desired state in Github, and deploy them to the actual state in our kubernetes cluster (EKS)
**Deployment**
Our deployment automatically has been set to get Env from our Configmap and Secret.
Here's sample deployment for our Service E:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "99c-service-e.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "99c-service-e.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      annotations:
        {{- range $key, $value := .Values.podAnnotations }}
        {{ $key }}: {{ $value | quote }}
        {{- end }}
      labels:
        {{- include "99c-service-e.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: {{ .Values.image.repository }}
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          envFrom:
            - configMapRef:
                name: {{ .Release.Name }}
            - secretRef:
                name: {{ .Release.Name }}
          ports:
            - name: http
              containerPort: {{ .Values.service.dstPort }}
              protocol: TCP
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          livenessProbe:
            {{- toYaml .Values.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.readinessProbe | nindent 12 }}
      nodeSelector:
        {{- toYaml .Values.nodeSelector | nindent 8 }}
```

**Service**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.dstPort }}
      protocol: TCP
      name: http
  selector:
    {{- include "99c-service-e.selectorLabels" . | nindent 4 }}
```

**Ingress**

This our ingress template. Our ingress will use Kong Ingress controller for backend service that is used API gateway. Backend service that is not using API gateway will be assigned to Nginx Ingress class.
```yaml
{{- if .Values.ingress.enabled -}}
{{- $fullName := .Release.Name -}}
{{- $svcPort := .Values.service.port -}}
{{- if semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1
{{- else -}}
apiVersion: networking.k8s.io/v1
{{- end }}
kind: Ingress
metadata:
  name: {{ $fullName }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "99c-service-e.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  rules:
  {{- range .Values.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          - path: /
            backend:
              service:
                name: {{ $fullName }}
                port:
                  number: {{ $svcPort }}
            pathType: Prefix
  tls:
    - hosts:
        - {{ .host | quote }}
      secretName: {{ $fullName }}
  {{- end }}
{{- end }}
```

**Configmap**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
data:
   {{- range $key, $value := .Values.appConfig }}
   {{ $key }}: {{ $value | quote }}
   {{- end }}
```
**Secret**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
data:
{{- range $key, $val := .Values.appSecret }}
  {{ $key }}: {{ $val | b64enc | quote }}
{{- end }}
type: Opaque
```

**Horizontal Pod Autoscaler**
```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ .Release.Name }}
  minReplicas: {{ .Values.autoscaller.replicas.min }}
  maxReplicas: {{ .Values.autoscaller.replicas.max }}
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ .Values.autoscaller.utilization.cpu }}
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: {{ .Values.autoscaller.utilization.memory }}
```

**Values**

Here's the example for our Backend Service E for our Helm charts.
We can configure, deployment, service,ingress, HPA in the values.yaml as well as our service configmap and secrets.
One of our backend service not using API gateway, we can assign them to Nginx Ingress class, not Kong Ingress class.
Our service E is leveraging API gateway to secure their APIs. So we will assig "kong" as their ingress class.
We must assign Kong on the ingress annotation.
```yaml
replicaCount: 2

podAnnotations:
  prometheus.io/scrape: "true"

image:
  repository: xxxxxxxxxxxx.dkr.ecr.ap-southeast-1.amazonaws.com/99c-service-e-prd:latest
  pullPolicy: Always

nameOverride: ""
fullnameOverride: ""
appConfig:
  APP_PORT: 8080
  DB_HOST: db.99.co:3306
  DB_NAME: 99c
  DB_USER: 99c-service-e
  DB_PORT: 3306
  REDIS_HOST: cache.99.co:6379
appSecret:
  DB_PASS: service_e
  REDIS_PASS: service_e

service:
  type: ClusterIP
  port: 8080
  dstPort: 8080

ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: kong
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prd
    ingressClassName: kong
    konghq.com/plugins: kong-rate-limit
  hosts:
    - host: e.service.api.99.co
      paths: []
  tls:
    - secretName: 99c-service-e-ssl
      hosts:
        - e.service.api.99.co

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaller:
  replicas:
    min: 2
    max: 256
  utilization:
    cpu: 75
    memory: 75

livenessProbe:
  failureThreshold: 3
  httpGet:
    path: /
    port: 8080
    scheme: HTTP
  initialDelaySeconds: 10
  periodSeconds: 5
  successThreshold: 1
  timeoutSeconds: 3

readinessProbe:
  failureThreshold: 3
  httpGet:
    path: /
    port: 8080
    scheme: HTTP
  initialDelaySeconds: 10
  periodSeconds: 5
  successThreshold: 1
  timeoutSeconds: 3

nodeSelector:
  service: backend
```

# API Gateway and Ingress Controller
As we have assigned Kong as Ingress controller. We can add plugin by adding KongPlugin in our ingress annotation
```yaml
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: kong
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prd
    ingressClassName: kong
    konghq.com/plugins: kong-rate-limit
  hosts:
    - host: e.service.api.99.co
      paths: []
  tls:
    - secretName: 99c-service-e-ssl
      hosts:
        - e.service.api.99.co
```
If We can set Kong Plugin for rate limit to secure our API gateway
```yaml
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: kong-rate-limit
config: 
  second: 5
  hour: 10000
  policy: local
plugin: rate-limiting
```

# Flux CD
After kubernetes cluster is provisioned. It will automatically all the toolchain such as Flux, Kong, Nginx, etc

# Flux Installation in Kubernetes using Terraform
We will install Flux in our kuberetes cluster using Terraform after Kubernetes cluster is provisioned. So we don't have to manually install them via Flux CLI.

**modules/flux/fluxs.tf
```terraform
provider "kubernetes" {
  host  = data.terraform_remote_state.k8s.outputs.do_k8s_endpoint
  token = data.terraform_remote_state.k8s.outputs.do_k8s_kubeconfig0.token
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.k8s.outputs.do_k8s_kubeconfig0.cluster_ca_certificate
  )
}

provider "kubectl" {}

data "flux_install" "main" {
  target_path = var.target_path
}

data "flux_sync" "main" {
  target_path = var.target_path
  url         = var.github_url
  branch      = var.branch
}

# Kubernetes
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = local.known_hosts
  }
}

# GitHub
resource "github_repository" "main" {
  name       = var.gitub_repository
  visibility = "public"
  auto_init  = true
}

resource "github_branch_default" "main" {
  repository = github_repository.main.name
  branch     = "main"
}

resource "github_repository_deploy_key" "main" {
  title      = "production-cluster"
  repository = github_repository.main.name
  key        = tls_private_key.main.public_key_openssh
  read_only  = true
}
# Customize Flux
resource "github_repository_file" "kustomize" {
  repository = github_repository.main.name
  file       = data.flux_sync.main.kustomize_path
  content    = file("${path.module}/kustomization.yaml")
  branch     = var.branch
}

#Set PSP rule for Flux Deployment
resource "github_repository_file" "psp_patch" {
  repository = github_repository.main.name
  file       = "${dirname(data.flux_sync.main.kustomize_path)}/psp-patch.yaml"
  content    = file("${path.module}/psp-patch.yaml")
  branch     = var.branch
}
```

**toolchain-deployment/flux/main.tf**
```terraform
terraform {
  backend "s3" {
    bucket  = "99c-prd-storage-s3-terraform"
    region  = "ap-southeast-1"
    key     = "99c-compute-flux-prd.tfstate"
    profile = "99c-prd"
  }
}

module "flux" {
  source    = "../../modules/flux"
  namespace = "flux-system"
  github_url = "ssh://git@github.com/99c/99c-toolchain-flux.git"
}
```

we can also  customize our Flux setting 
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- gotk-components.yaml
- gotk-sync.yaml
- namespace.yaml
- nginx-ingress.yaml
patches:
  - path: psp-patch.yaml
    target:
      kind: Deployment
```
PSP_Patch
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: all-flux-components
spec:
  template:
    metadata:
      annotations:
        # Required by Kubernetes node autoscaler
        cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
    spec:
      securityContext:
        runAsUser: 10000
        fsGroup: 1337
      containers:
        - name: manager
          securityContext:
            readOnlyRootFilesystem: true
            allowPrivilegeEscalation: false
            runAsNonRoot: true
            capabilities:
              drop:
                - ALL
```
Heres' the workfow four our Helm Release using FLux
<p align="center">
  <img src="img/fluxcd-helm-operator-diagram.png" alt="Flux CD Diagram">
</p>

## Flux Configuration
Our flux folder structure would look like this:
<p align="center">
  <img src="img/flux-folder-structure.png" alt="Flux Folder structure">
</p>
Flux scan this sub-directory and determine which ressources definition they need to called.
The Deployment directory contain our resources definition using Kustomize. It???s here that we build the code to setup our services e.g service e,f,g,hand toolchain Helm chart e.g ingress-nginx

**flux/clusters/service.yaml
```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: service
  namespace: flux-system
spec:
  interval: 10m0s
  dependsOn:
    - name: common
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./deployment/services
  prune: true
  validation: client
  healthChecks:
    - apiVersion: apps/v1
      kind: Deployment
      name: service-e
      namespace: 99c
```

**flux/clusters/toolchain.yaml
```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: toolchain
  namespace: flux-system
spec:
  interval: 10m0s
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./toolchain/ingress-nginx
  prune: true
  validation: client
  healthChecks:
    - apiVersion: apps/v1
      kind: DaemonSet
      name: nginx-ingress-ingress-nginx-controller
      namespace: ingress-nginx
```

## Sample Flux configuration for Service-e

**deployment/services/sources/kustomization.yaml**
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: flux-system
resources:
  - service-e.yaml
```

**deployment/services/sources/service-e.yaml**
```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: HelmRepository
metadata:
  name: service-e
spec:
  interval: 30m
  url: https://99c.github.io/99co-backend/service-e/helm-chart/service-e.tgz
```

**deployment/services/service-e/kustomization.yaml**
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: 99c
resources:
  - namespace.yaml
  - service-e.yaml
```

**deployment/services/service-e/namespace.yaml**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: 99c
```
Instead to manually change the values.yaml, we will use Flux Helm release. We only change the value for image repository with their commit hash to mark new deployment for new images by Flux CD.

**deployment/services/service-e/service-e.yaml**
```yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: service-e
spec:
  releaseName: service-e
  chart:
    spec:
      chart: service-e
      sourceRef:
        kind: HelmRepository
        name: service-e
        namespace: flux-system
      version: "1.0.0"
  interval: 1h0m0s
  install:
    remediation:
      retries: 3
  values:
    image:
      repository: xxxxxxxxxxxx.dkr.ecr.ap-southeast-1.amazonaws.com/99co-service-e-prd:<commit_hash>
```
