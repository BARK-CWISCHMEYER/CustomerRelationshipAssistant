#https://auth0.com/blog/developing-restful-apis-with-python-and-flask/
from barkutils.sql.sql_conns import get_redshift_dw_conn, sql_to_pandas
from sql_queries import *
from flask import Flask, jsonify, request

#from .models.entity import Session, engine, Base
#from .models.treatment import Treatment

app = Flask(__name__)

# @app.route("/")
# def hello_world():
#   return "Hello, World!"

# "anonymousId": "8d872292709c6fbe",
#     "customerId": "111111",
#     "subscriptionId": "222222",
#     "product": "eats",
#     "treatments": {

treatments = [
  {
      "eats_upsell": {
        "included": "0",
        "testControl": "0",
        "text": "Customer Eligible for Eats Xsell",
        "title": "customername\'s dogbreed dogname is eligible for Eats. Approximate cost : $XX / mo."
      },
      "play_upsell": {
        "included": "1",
        "testControl": "1",
        "text": "Customer Eligible for Eats Xsell",
        "title": "customername\'s dogbreed dogname is eligible for Play. productline is recomended."
      },
      "dog_birthday": {
        "included": "0",
        "testControl": "0",
        "text": "Dog Birthday Upcoming",
        "title": "customername's dogbreed dogname's birthday is in XX days. Eligible to recieve gwpname"
      }
  } 
]

#Gets treatments given the input

@app.route('/treatments', defaults-{'id': 0 , 'id_type': 'customer' , 'product': 'All' , 'source_system': 'All'}) ## need to validate inputs for id <> 0 unless this
@app.route('/treatments/<id>/<id_type>', defaults-{'product': 'All' , 'source_system': 'All'})
@app.route('/treatments/<id>/<id_type>/<source_system>', defaults-{'product': 'All'})
@app.route('/treatments/<id>/<id_type>/<source_system>/<product>')
def get_treatments(product,source_system, id, id_type):
  if(id==0):
    df  = sql_to_pandas("select * from common.retention_orders limit 1").to_json(orient="split")
  return jsonify(treatments)




@app.route('/treatments', methods=['POST'])
def add_treatment():
  treatments.append(request.get_json())
  return '', 204

@app.route('/sqltest')
def get_sql():
  df  = sql_to_pandas("select subscription_id from common.retention_orders limit 1").to_json(orient="split")

  return df
