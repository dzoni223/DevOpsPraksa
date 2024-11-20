# DevOpsPraksa

# Setup
 
Create git repository on GitHub. ------------------


Configure SSH key for GitHub account.
-----------------
ssh-keygen -t ed25519 -C "your_email@example.com"
//add the pub key to GitHub account

eval "$(ssh-agent -s)" //start ssh agent in background
ssh-add ~/.ssh/id_ed25519 //add ssh key to agent
-----------------

Configure PGP key for GitHub account.
-----------------
gpg --full-generate-key //generate gpg key
gpg --list-secret-keys --keyid-format=long //list the full key
gpg --armor --export yourkeyhere //print the key id in ascii format
//add the key to GitHub account
-----------------

Install and configure git locally.
------------------
git config --global user.name "username"
git config --global user.email "email"
------------------

Create AWS account. --------------------

Create EC2 instance. --------------------

Configure SSH for EC2 instance.
------------------
//create a key pair when creating a EC2 instance
------------------

Install docker with cloud-init.
------------------
#cloud-config
package_update: true
package_upgrade: true
packages:
  - docker.io
runcmd:
  - systemctl start docker
  - systemctl enable docker
-------------------

Install Jenkins on EC2 and test SSH port forwarding.
-------------------
sudo apt install fontconfig openjdk-17-jre  // install java

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

//enable port 8080 on ec2 security group
ssh -i KEY -L 8080:localhost:8080 ubuntu@EC2IP  //ssh to ec2 port forwarding 8080
-------------------

Configure lambda shutdown function.
-------------------
//Create IAM role with EC2 control policy.
//Create Lambda function and attach the role
//Add shutdown code
import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instance_id = 'yourinstanceid'

    try:
        # Stop the instance
        response = ec2.stop_instances(InstanceIds=[instance_id])
        print(f"Successfully stopped instance: {instance_id}")
        return {
            "statusCode": 200,
            "body": f"Instance {instance_id} has been stopped.",
            "response": response
        }
    except Exception as e:
        print(f"Error stopping instance {instance_id}: {e}")
        return {
            "statusCode": 500,
            "body": f"Failed to stop instance {instance_id}: {e}"
        }
-------------------
