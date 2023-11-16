# import modules
from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import text

# setup flask app
app = Flask(__name__)

# Configure required environmental variables for SQLite
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///./email.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Create the DB
db = SQLAlchemy(app)
app.app_context().push()

# - drop users table if exists, create new users table and add some rows for sample
drop_table = 'DROP TABLE IF EXISTS users;'
db.session.execute(text(drop_table))

users_table = """ 
CREATE TABLE users(
username VARCHAR NOT NULL PRIMARY KEY,
email VARCHAR);
"""
db.session.execute(text(users_table))

insert_data = """
INSERT INTO users
VALUES
    ("Yusuf", "yusuf@amazon.com"),
    ("Betul", "betul@google.com"),
    ("Sparkle", "sparkle@bmw.com"),
    ("Yildiz", "yildiz@mercedes.com"),
	("Mehmet", "mehmet@porche.com"),
    ("Tugba", "tugba@tesla.com"),
    ("Kemal", "kemal@samsung.com");
"""
db.session.execute(text(insert_data))

db.session.commit()

# - Write a function named `emails` which finds email addresses by keyword using `GET` and `POST` methods,
# - using template files named `emails.html` given under `templates` folder
# - and assign to the static route of ('/')
@app.route("/", methods=["GET", "POST"])
def emails():
    if request.method == "GET":
        return render_template("emails.html", show_result=False)
    else: # request.method == "POST"
        user_name = request.form.get("user_keyword")
        user_emails = find_emails(user_name)
        return render_template("emails.html", show_result=True, keyword=user_name, name_emails=user_emails)

# - Write a function named `find_emails` which find emails using keyword from the user table in the db,
# - and returns result as tuples `(name, email)`.
def find_emails(username):
    query = f"""
    SELECT * FROM users WHERE username like '%{username}%';
    """
    result = db.session.execute(text(query))
    user_emails = [(row[0], row[1]) for row in result]
    if not any(user_emails):
        user_emails = [("Not Found", "Not Found")]
    return user_emails 



# - Write a function named `add_email` which inserts new email to the database using `GET` and `POST` methods,
# - using template files named `add-email.html` given under `templates` folder
# - and assign to the static route of ('/add')
@app.route("/add", methods=["GET", "POST"])
def add_email():
    if request.method == "GET":
        return render_template("add-email.html", show_result=False)
    else:
        user_name = request.form["username"]
        user_email = request.form["useremail"]
        result = insert_email(user_name,user_email)
        return render_template("add-email.html", show_result=True, result_html=result)

# - Write a function named `insert_email` which adds new email to users table the db.
def insert_email(name,email):
    query = f"""
    SELECT * FROM users WHERE username like '{name}'
    """
    result = db.session.execute(text(query))
    response = ""
    if len(name) == 0 or len(email) == 0:
        response = 'Username or email can not be empty!!'
    elif not any(result):
        insert = f"""
        INSERT INTO users
        VALUES ('{name}', '{email}');
        """
        result = db.session.execute(text(insert))
        db.session.commit()
        response = f"User {name} and {email} have been added successfully"
    else:
        response = f"User {name} already exist"
    return response

# - Add a statement to run the Flask application which can be reached from any host on port 80.
if __name__ == "__main__":
    app.run()