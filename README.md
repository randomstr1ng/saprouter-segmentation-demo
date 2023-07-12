# Terraform deployment for SAProuter Demo environemnt

This Terraform scripts deploy a small environment which can be used to demonstrate vulnerabilities caused by misconfigured SAPRouter Instances inside of a company.

The Setup consist of the following components:

* Attacker VM (Ubuntu 20.04)
* SAPRouter VM (Ubuntu 20.04)
* Internal Server VM (Ubuntu 20.04)
* FortiGate VM



## Network Diagram

```vim
                                                      DMZ Net
                                                   +----------------+
                                                   |                |
                                        +----------+  SAPRouter VM  |
                                        |          |                |
   Public Net                           |          +----------------+
+---------------+          +------------+---+
|               |          |                |
|  Attacker VM  +----------+  FortiGate VM  |
|               |          |                |
+---------------+          +------------+---+         Internal Net
                                        |          +--------------------+
                                        |          |                    |
                                        +----------+  Internal Server   |
                                                   |                    |
                                                   +--------------------+
```



## Deploy demo environment

- Fillout the required variables within `terraform.tfvars` (Example: terraform.tfvarsexample)

```terraform
subscription_id = ""
client_id = ""
client_secret = ""
tenant_id = ""
size = ""
adminusername = ""
adminpassword = ""
flexvm_token = ""
```

* enter a valid license into `./configurations/license.txt` or provide a FortiFlex license token.
* Initilize terraform environment

```bash
$ terraform init
```

* Check & Deploy the demo environment

```bash
$ terraform plan
...[snip]...
$ terraform apply
...[snip]...
```

* After a successfull deployment, you will be provided with the necessary IP address and login credentials.
* You can login to the Attacker VM via SSH key and the public IP (Example)

```bash
$ ssh -i ssh_key.pem saprouter-demo-admin@4.3.2.1
```

* In addition, you can logon to FortiGate via the username/password & public IP address provided by terraform. 

## Demo scenario description

[Demo documentation/How-to guide](./documentation/README.md)

