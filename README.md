# 99co-technical-test
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
- DevOps is a culture that break the silo between Ops and Development.
- DevOPs allow us to deliver product fast. If we go fast we are very likely to break things but we will break small.

# Part B
Part B
These are very simple technical questions to give us a bit overview on linux and computer network
skills.
1. When setting up a new website, the web can’t be accessed. On the Nginx error log returns
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

2. There’s a production database on server A that can only be accessed from server B. A
database engineer needs to access the database regularly on server A but only has the
permission to connect to server B. Explain how you would set the environment for the
database engineer to connect to server A. You can be as detailed as possible and use
assumptions for the information that’s not given here.

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
mysql -u <DB_USER> -h <DB_HOST> -P 3306 –ssl-ca=~/ssl-client/ca.pem –ssl-cert=~/ssl-client/client-cert.pem –ssl-key=~/ssl-client/client-key.pem -p<DB_PASS>
```
We must also encrypt our database storage using KMS (key management service).

3. Assume we have setup a service with the following layers:
<p align="center">
  <img src="img/502-bad-gateway.png" alt="502 bad gateway">
</p>

When the client receives error **502 Bad Gateway** , how would you like to troubleshoot to fix
the issue to point out the root problem? You can be as detailed as possible and use
assumptions for the information that’s not given here.

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

**Nginx Load Balancer**
Nginx configuration must proxy pass *http://localhost:8080/* 
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
If the backend service failed, Nginx will not received any data from it. It will result the 502 bad gateway because nginx is depend on backend service. We can restart the application to make the application work by issuing the following command.

```console
 kill -9 $(pgrep php-fpm)
 service php7-fpm restart
```

# Part C

This part helps us to understand how you would design and build a scalable system that could
serve millions of users per month.

<p align="center">
  <img src="img/database.svg" alt="database">
</p>

Let’s imagine we are going to build a Restful API system that can be accessed securely from the
public, fast enough to respond with sufficient body size, and minimum down time (SLA 99.9%).
The system also will use common relational databases (such as MySQL, PostgreSQL). With those
conditions, tell us:

- how you would design the system given the requirements
- what technologies (open source or 3rd party) you are going to use
- how you would setup the deployment and namespacing strategy for each repo (1 colour is
1 repo, so there are 4 repos on the diagram); and
- the strategy/approach that you are going to use to handle high usage but keep the system
reaching uptime 99.9%.

Assume your solution is set up on Kubernetes in Google Cloud Platform or GKE (don’t set up the
solution on real infrastructure by the way!!!). You can use diagrams to help illustrate your
explanation. Feel free to add assumptions.

## Infrastructure Diagram
<p align="center">
  <img src="img/infrastructure-diagram.png" alt="Infrastructure Diagram Images">
</p>
Image Link: https://lucid.app/lucidchart/2237664e-6e48-4393-b33c-91216df6e8de/edit?viewport_loc=478%2C42%2C3328%2C1646%2C0_0&invitationId=inv_639fc3d3-d6ad-45d3-800e-a0f01f6a23bb