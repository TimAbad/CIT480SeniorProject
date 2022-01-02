import sys
import streamlit as st
import pandas as pd
import numpy as np
from PIL import Image
import plotly.express as px
from plotly.subplots import make_subplots
import plotly.graph_objects as go
import requests
import json

st.title('Covid-19 Global Cases')
st.write("A Snapshot of ***Cornavirus Cases*** around the world")
st.sidebar.title("Selector")
st.markdown('<style>body{background-color: lightblue;}</style>',unsafe_allow_html=True)

#print(sys.path)
#print('Hello dashboard!')
#Loading the data
#response

response =  requests.get('https://corona.lmao.ninja/v2/countries?yesterday&sort')
json_data = json.loads(response.text)
df = pd.DataFrame(json_data)

visualization = st.sidebar.selectbox('Select a Chart type',('Bar Chart','Pie Chart','Line Chart'))
country_select = st.sidebar.selectbox('Select a country',df['country'].unique())
status_select = st.sidebar.radio('Covid-19 patient status',('cases','active','recovered','deaths'))
selected_country = df[df['country']==country_select]
st.markdown("## **Country level analysis**")

row_id = 0
data_top = selected_country.head()
for row in data_top.index:
        row_id = row

print(row_id)
def get_total_dataframe(df):
        total_dataframe = pd.DataFrame({
        'Status':['cases', 'recovered', 'deaths', 'active'],
        'Number of cases':(df.iloc[0]['cases'],
        df.iloc[0]['recovered'],
        df.iloc[0]['deaths'],df.iloc[0]['active'])})
        return total_dataframe

country_total = get_total_dataframe(selected_country)


#print(country_total)
if visualization == 'Bar Chart':
        country_total_graph = px.bar(country_total, x='Status',y='Number of cases',
                                        labels={'Number of cases':'Number of cases in %s' % (country_select)}, color='Status')
        st.plotly_chart(country_total_graph)
elif visualization == 'Pie Chart':
	if status_select == 'cases':
		st.title("Total Confirmed Cases ")
		fig = px.pie(df, values=df['cases'], names=df['country'])
		st.plotly_chart(fig)
	elif status_select=='active':
		st.title("Total Active Cases ")
		fig = px.pie(df, values=df['active'], names=df['country'])
		st.plotly_chart(fig)
	elif status_select=='deaths':
                st.title("Total Death Cases ")
                fig = px.pie(df, values=df['deaths'], names=df['country'])
                st.plotly_chart(fig)
	else:
                st.title("Total Recovered Cases ")
                fig = px.pie(df, values=df['recovered'], names=df['country'])
                st.plotly_chart(fig)
elif visualization == 'Line Chart':
	if status_select == 'deaths':
		st.title("Total Death Cases Among Countries")
		fig = px.line(df, x='country', y=df['deaths'])
		st.plotly_chart(fig)
	elif status_select =='cases':
        	st.title("Total Confirmed Cases Among Countries")
        	fig = px.line(df,x='country',y=df['cases'])
        	st.plotly_chart(fig)
	elif status_select =='recovered':
		st.title("Total Recovered Cases Among Countries")
		fig = px.line(df,x='country',y=df['recovered'])
		st.plotly_chart(fig)
	else:
		st.title("Total Active Cases Among Countries")
		fig = px.line(df,x='country',y=df['active'])
		st.plotly_chart(fig)

def get_table():
	datatable = df[['country', 'cases', 'recovered', 'deaths', 'active']].sort_values(by=['cases'],ascending=False)
	return datatable

datatable = get_table()
st.dataframe(datatable)
