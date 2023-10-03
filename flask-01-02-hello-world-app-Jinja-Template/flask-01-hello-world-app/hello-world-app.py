# Hello World App

from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "<h1>Hello world</h1>"

@app.route('/second')
def  second():
    return "<h2>This is the second page<h2>"

@app.route('/third/subthird')
def third():
    return "This is the subpage of third page"

@app.route("/forth/<string:id>")
def forth(id):
    return f"The id of this page is {id}"

# Run the flask app
app.run(debug=False)

