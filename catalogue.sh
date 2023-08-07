echo -e "\e[36m>>>>> Configuring NodeJS Repos <<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>> Install NodeJS <<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>> Add Application User <<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>> Create Application Directory <<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>> Download App Content <<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>> Unzip App Content <<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>> Add NodeJS Dependencies <<<<<\e[0m"
npm install

echo -e "\e[36m>>>>> Copy Catalogue SystemD file <<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>> Start Catalogue Service <<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>> Copy Mongodb repo <<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>> Install Mongodb Client <<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>> Load Schema <<<<<\e[0m"
mongo --host mongodb-dev.madhavi91.online </app/schema/catalogue.js