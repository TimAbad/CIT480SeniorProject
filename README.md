# CIT480SeniorProject
Project files for CIT480 Senior Design

Covid API Tracking Appliation:
Our application tracks Covid data from a public API and displays an interactive map to the user 
as well as displays a table of Covid statistics for the top 25 countries around the world.

We plan to develop more user interactivity that allows the user to sort through the data in order to find specific information.

Our application is composed of app.py as well as two directories.
The static directory contains the style.css file and the templates directory
contains base.html and home.html. It also contains a logs directory for error logs.

To run the app locally on your machine:
You will need to have python installed as well as a few other modules:

flask (web)
pandas (Dataframes)
folium (Mapping)
requests (API Calls)

These packages can be installed by using PIP which is a package-management system written in Python used to install and manage software packages.

How to use PIP to install application requirements:
sudo -H pip3 install -r requirements.txt

Command to run the application:
python3 app.py

This will create a running web application on the localhost:
http://127.0.0.1:5000

##Notes##
#Moved app to basic-flask-app directory
