#!/bin/bash

# Read the .env file and extract the DOMAIN_NAME variable
while IFS= read -r line; do
    if [[ "$line" == "DOMAIN_NAME="* ]]; then
        domain_name="${line#*=}"
        break
    fi
done < .env

# Define the directory path
directory_path="./certbot/conf/live/$domain_name/"

# Define the list of required files
required_files=("cert.pem" "chain.pem" "fullchain.pem" "privkey.pem")

# Check if all required files exist in the directory
missing_files=0
for file in "${required_files[@]}"; do
    file_path="$directory_path$file"
    if [[ ! -f "$file_path" ]]; then
        echo "Error: $file does not exist in $directory_path"
        missing_files=1
    fi
done

# If any files are missing, exit with an error
if [[ $missing_files -eq 1 ]];
    then
	exit 1
    else
	# Replace "#server_name ;" with the DOMAIN_NAME in conformance_idp.conf
	sed -i "s/#server_name ;/server_name $domain_name;/" conformance_idp.conf

	# Replace "#server_name ;" with the DOMAIN_NAME in conformance_idp_ssl.conf
	sed -i "s/#server_name ;/server_name $domain_name;/" conformance_idp_ssl.conf

	# Define SSL certificate and key configurations
	cert_config="ssl_certificate /opt/bitnami/nginx/ssl/live/$domain_name/cert.pem;"
	key_config="ssl_certificate_key /opt/bitnami/nginx/ssl/live/$domain_name/privkey.pem;"

	# Replace "#ssl_certificate ;" with the actual certificate configuration
	sed -i "s|#ssl_certificate ;|$cert_config|" conformance_idp_ssl.conf

	# Replace "#ssl_certificate_key ;" with the actual key configuration
	sed -i "s|#ssl_certificate_key ;|$key_config|" conformance_idp_ssl.conf
	
	cat conformance_idp_ssl.conf >> conformance_idp.conf
	chmod -R go+rx ./certbot/conf
	docker restart reverseproxy
	echo "please check https://$domain_name/simplesaml/module.php/admin in few minutes"
fi
