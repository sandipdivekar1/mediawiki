#!/bin/bash 

##
# Variable block
##
user_ansible="ec2-user"
host_line="$ipaddress   ansible_connection=ssh        ansible_user=$user_ansible      ansible_ssh_private_key_file=$pemfile_path"

##
# Confirmation of access key and secret keys
##
echo -e "\nBefore proceeding further have you set access key and secret key inside ~/.aws/credentials file? OR Have you added them as a environment variable as follows?"
echo -e "export AWS_ACCESS_KEY_ID=XXXX"
echo -e "export AWS_SECRET_ACCESS_KEY=XXXX"
printf "If not added enter 'no' and export the variables first. provide appropriate response(yes/no):"
read response
if [ "$response" == "yes" ]; then
  echo -e "\nProceeding with installation\n"
elif [ "$response" == "no" ]; then
  exit 0
else
  exit 1
fi

##
# Input section
##
printf "Enter absolute path of pem file(default:/root/tungsten.pem):"
read pemfile_path
if [ -z "$pemfile_path" ]
then
  pemfile_path="/root/tungsten.pem"
fi

printf "Enter aws key pair name for launching instances.(default:tungsten):"
read pemname
if [ -z "$pemname" ]
then
  pemname="tungsten"
fi


printf "Enter ami id for launching instances.(default:ami-034fffcc6a0063961):"
read amiid
if [ -z "$amiid" ]
then
  amiid="ami-034fffcc6a0063961"
fi



printf "Enter Region for for launching instances.(default:eu-central-1):"
read region
if [ -z "$region" ]
then
  region="eu-central-1"
fi


printf "Enter availability zone for launching instances.(default:eu-central-1a):"
read zone
if [ -z "$zone" ]
then
  zone="eu-central-1a"
fi

##
# Create terraform tfvar file
##
echo "region = \"$region\"" > terraform/terraform.tfvars
echo "availabilityZone = \"$zone\"" >> terraform/terraform.tfvars
echo "prefix = \"berlin\"" >> terraform/terraform.tfvars
echo "media_instance_type = \"t2.small\"" >> terraform/terraform.tfvars
echo "database_instance_type = \"t2.small\"" >> terraform/terraform.tfvars
echo "key_name = \"$pemname\"" >> terraform/terraform.tfvars
echo "mediaami = \"$amiid\"" >> terraform/terraform.tfvars
chmod +x terraform/terraform.tfvars

##
# Execution of terraform script
##
cd terraform
terraform init
terraform apply -auto-approve=true
media_hosts=`terraform output media_public_ips`
db_hosts=`terraform output database_public_ip`
elburl=`terraform output elburl`
ip1=`echo $media_hosts | cut -d "," -f1`
ip2=`echo $media_hosts | cut -d "," -f2 | sed 's/ //g'`

##
# Add media hosts in hosts file
##
echo -e "[media]" > hosts
echo -e "$ip1   ansible_connection=ssh        ansible_user=$user_ansible      ansible_ssh_private_key_file=$pemfile_path" >> hosts 
echo -e "$ip2   ansible_connection=ssh        ansible_user=$user_ansible      ansible_ssh_private_key_file=$pemfile_path" >> hosts 

##
# Add database host in hosts file 
##
echo -e "[database]" >> hosts
echo -e "$db_hosts   ansible_connection=ssh        ansible_user=$user_ansible      ansible_ssh_private_key_file=$pemfile_path\n" >> hosts 

mv hosts ../ansible/
cd ../ansible
ansible-playbook -i hosts deploy-media-wiki.yml --extra-vars "database_ip=10.0.1.30" --ask-vault-pass

echo -e "\nAccess following url for visiting mediawiki webpage:"
echo "$elburl/mediawiki"
