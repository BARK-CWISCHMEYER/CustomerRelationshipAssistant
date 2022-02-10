#https://auth0.com/blog/developing-restful-apis-with-python-and-flask/
from barkutils.sql.sql_conns import get_redshift_dw_conn, sql_to_pandas

from flask import Flask, jsonify, request

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


@app.route('/treatments')
def get_treatments():
  return jsonify(treatments)


@app.route('/treatments', methods=['POST'])
def add_treatment():
  treatments.append(request.get_json())
  return '', 204


@app.route('/sql')
def get_sql():
  conn = get_redshift_dw_conn()
  df  = sql_to_pandas("select * from common.retention_orders limit 1").to_json(orient="split")
  return df

