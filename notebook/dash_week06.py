
from dash import Dash, html, dcc # import the needed dash tools
#import plotly.express as px
import pandas as pd
import json
import re
import plotly.express

app = Dash('gapminder') # instantiate a Dash object called app
app.layout = html.Div(children=[
    html.H1(children='Gap Minder Analysis'),

    dcc.Graph(
        id='Stations',
        figure=plotly.io.read_json('station_position.json')
    ),

    dcc.Graph(
        id='countries',
        figure=plotly.io.read_json('avg_temp_country.json')
    ),

    dcc.Graph(
        id='station 27',
        figure=plotly.io.read_json('Variation_temperature_station_27.json')
    ),

    dcc.Graph(
        id='station berlin',
        figure=plotly.io.read_json('Variation_temperature_station_berlin-mitte.json')
    ),

    dcc.Graph(
        id='germany',
        figure=plotly.io.read_json('Gemany_station.json')
    )
    
    ])

if __name__ == '__main__':
    app.run_server(debug=False) # runs a local server for the dashboard app to run on
