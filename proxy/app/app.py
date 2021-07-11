from flask import Flask
from tronpy import Tron
from tronpy.providers import HTTPProvider

app = Flask(__name__)
client = Tron(HTTPProvider("http://127.0.0.1:9090"))


@app.route("/")
def home():
    return client.get_block()
