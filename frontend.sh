script=$(realpath "$0")
script_path=$(dir_name $"Script")
source ${script_path}/common.sh

func_print_head "Install Nginx"
yum install nginx -y

func_print_head "Copy roboshop Config file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

func_print_head "Clean Old App content"
rm -rf /usr/share/nginx/html/*

func_print_head "Download App Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

func_print_head "Extracting App Content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

func_print_head "Start Nginx"
systemctl restart nginx
systemctl enable nginx