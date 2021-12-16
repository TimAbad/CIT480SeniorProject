import requests
import json
import pandas as pd
import folium

#jprint function for printing which we only use for testing
def jprint(obj):
        # create a formatted string of the Python JSON object
        text = json.dumps(obj, sort_keys=True, indent=4)
        print(text)

#Retrieve api data
response =  requests.get('https://corona.lmao.ninja/v2/countries?yesterday&sort')

#Create json object from jason data
json_data = json.loads(response.text)

#Create DataFrame using pandas to organize our data
#First create a dataframe with all the data
corona_df = pd.DataFrame(json_data)

#2. Create dataframe with only countryInfo since the lat long values are nested inside countryInfo
cdf = corona_df['countryInfo']

#3. Create dataframe of active cases
active_df = corona_df[['active']]

#4 Create dataframe of countries
country_df = corona_df[['country']]

#Create a list to store lat long values
a_list = []

#Loop through cdf dataframe to pull lat long values and add them to the list
for item in cdf:
        a_dict = {'lat': item['lat'], 'long':item['long']}
        a_list.append(a_dict)

#Create dataframe from our newly populated list
df = pd.DataFrame(a_list)

#Insert active and country columns into df dataframe and insert our active and country dataframes
df['active'] = active_df
df['country'] = country_df

#function to find top confirmed
#We can write other functions to display different data.  This is the example that is displayed in the table to the left of the homepage.
def find_top_confirmed(n = 15):
	corona_df = pd.DataFrame(json_data)
	by_country = corona_df.groupby('country').sum()[['active', 'deaths', 'recovered', 'cases']]
	cdf = by_country.nlargest(n, 'active')[['active']]
	return cdf

cdf=find_top_confirmed()

#Create pairs for our table
pairs=[(country, active) for country, active in zip(cdf.index,cdf['active'])]

#Create map using folium
m=folium.Map(location=[34.223334,-82.461707],
	tiles='Stamen terrain',
	zoom_start=8)
#Create cirles around confirmed cases
def circle_maker(x):
	folium.Circle(location=[x[0],x[1]],
        radius=float(x[2])*.1,
        color="red",
        popup='{}\n confirmed cases:{}'.format(x[3],x[2])).add_to(m)

#Apply map to our dataframe
df = df[['lat','long','active','country']].apply(lambda x:circle_maker(x),axis=1)

html_map=m._repr_html_()

#flask configuration
from flask import Flask,render_template
app=Flask(__name__)
@app.route('/')
#This is our home page which is named home.html  We can also define other pages here.
def home():
    return render_template("home.html",table=cdf, cmap=html_map,pairs=pairs)
if __name__=="__main__":
    app.run(debug=True)
