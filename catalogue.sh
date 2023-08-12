script=$(realpath "$0")
script_path=$(dir_name $"Script")
source ${script_path}/common.sh

func_print_head "Configuring NodeJS Repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

func_print_head "Install NodeJS"
yum install nodejs -y

func_print_head "Add Application User"
useradd roboshop

func_print_head "Create Application Directory"
rm -rf /app
mkdir /app

func_print_head "Download App Content "
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

func_print_head "Unzip App Content"
unzip /tmp/catalogue.zip

func_print_head" Add NodeJS Dependencies"
npm install

func_print_head "Copy Catalogue SystemD file"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

func_print_head "Start Catalogue Service"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

func_print_head "Copy Mongodb repo"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

func_print_head "install MongoDb Client"
yum install mongodb-org-shell -y

func_print_head "Load Schema"
mongo --host mongodb-dev.madhavi91.online </app/schema/catalogue.js