# CIT480SeniorProject
Project files for CIT480 Senior Design

Covid API Tracking Application:
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

###CIT481 Spring 2022:########################################

We have moved application development from flask to streamlit.
Streamlit gives us a range of visualization options that work well with our covid data set.
Streamlit also allowed us to develop our front end with user interaction in mind:

-We now have the option for users to select individual countries and display relevant covid data about that specific country using a bar chart.

-We also now have the option to display country-wise covid data using a pie chart and gives the user a range of countries to select from.

-We have included a line chart as well which displays our covid data set using X and Y ranges for country specific covid data.

-A table has also been included in lieu of the geographic map from last semester which ranks the countries' infection rate from high to low.

The application is located in the dashboard/ folder.

To run the application the requirements must first be installed (requirements.txt)

How to use PIP to install application requirements:
sudo -H pip3 install -r requirements.txt

Command to run the application:
streamlit run app.py

This will create a running web application on the localhost:
http://127.0.0.1:8501

