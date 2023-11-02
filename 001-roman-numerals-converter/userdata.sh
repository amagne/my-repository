#!/bin/bash -x

# Updating the operating system
yum update -y

# Installin Python and Flask
yum install python3 -y
yum install pip -y
pip3 install flask

# Installing the application's sources codes
FOLDER="https://raw.githubusercontent.com/amagne/my-repository/main/001-roman-numerals-converter"

cd /home/ec2-user
wget ${FOLDER}/app.py
mkdir templates
cd templates
wget ${FOLDER}/templates/index.html
wget ${FOLDER}/templates/result.html
cd ..

# Run the application
python3 app.py