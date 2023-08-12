script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Configuring NodeJS Repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
func_stat_check $?

func_print_head "Install NodeJS"
yum install nodejs -y &>>$log_file
func_stat_check $?

func_print_head "Add Application User"
useradd roboshop &>>$log_file
func_stat_check $?

func_print_head "Create Application Directory"
rm -rf /app &>>$log_file
mkdir /app &>>$log_file
func_stat_check $?

func_print_head "Download App Content "
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>$log_file
cd /app
func_stat_check $?

func_print_head "Unzip App Content"
unzip /tmp/catalogue.zip &>>$log_file
func_stat_check $?

func_print_head" Add NodeJS Dependencies"
npm install &>>$log_file
func_stat_check $?

func_print_head "Copy Catalogue SystemD file"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$log_file
func_stat_check $?

func_print_head "Start Catalogue Service"
systemctl daemon-reload &>>$log_file
systemctl enable catalogue &>>$log_file
systemctl restart catalogue &>>$log_file
func_stat_check $?

func_print_head "Copy Mongodb repo"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_stat_check $?

func_print_head "install MongoDb Client"
yum install mongodb-org-shell -y &>>$log_file
func_stat_check $?

func_print_head "Load Schema"
mongo --host mongodb-dev.madhavi91.online </app/schema/catalogue.js &>>$log_file
func_stat_check $?