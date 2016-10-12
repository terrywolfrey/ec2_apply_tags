#!/usr/bin/env bash

# This script assumes you already have the AWS command line installed and configured.
# It grabs a list of instance ID's filtered by the 'filter' variable in the user settings section.
# It formats them serially rather than as a column and places them into the variable 'id_list'. 
# The values you place in the 'tags' variable are then placed on the instances listed in 'id_list'.
# The script prompts you to verify these items during execution to assure you excute the actions you intend.
# It then comfirms excution is complete.

# This echos commands and output as they are executed. For debugging.
#set -x


##########################  BEGIN USER SETTINGS HERE  ##########################

# Set your filters here. Examples: "*.sngl.cm" and "*.singlecomm.com"
#filter="*.singlecomm.com"
filter="*.singlecomm.com"


# Set your tags here. Follow this format and edit the line below as needed.  EXAMPLES: "Key=Component,Value=Scripter Key=SubComp,Value=EC2"
#tags="Key=Component,Value=ACD Key=SubComp,Value=EC2"
tags="Key=ResType,Value=FS"

##########################  END USER SETTINGS HERE  ##########################


# Lists all instance ID's matching the filter variable in serial text format.
id_list=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --filters "Name=tag:Name,Values=${filter}" --output text --profile 7408 | paste -d " "  -s)

echo ${id_list}
echo

# This creates a yes/no confirmation dialog to continue with these ID's.
read -p "Continue with the ID's above? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo
	exit 0
fi

echo 
echo
echo
echo ${tags}
echo 

# This creates a yes/no confirmation dialog to continue with these tags.
read -p "Continue with the tags above? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo
	exit 0
fi

echo

#aws ec2 create-tags --resources ${id_list} --tags ${tags}
aws ec2 create-tags --resources ${id_list} --tags ${tags} --profile 7408

# REMOVE TAGS USING THE delete-tags COMMAND:
#aws ec2 delete-tags --resources ${id_list} --tags ${tags} --profile 7408

echo
echo SCRIPT COMPLETE
echo