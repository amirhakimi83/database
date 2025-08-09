from flask import Flask, render_template, request, jsonify, session
from flask_restful import Api
from wtforms import Form, PasswordField, StringField, SubmitField
from wtforms.validators import DataRequired
from werkzeug.datastructures import ImmutableMultiDict
from flask_mysqldb import MySQL
chat = ['UserID1', 'UserID2']
contacts = ['UserID', 'ContactUserID']
groupChat = ["GroupName", 'CreatorUserID']
GroupMembers = ['GroupChatID', 'UserID']
groupMessage = ['GroupChatID', 'SenderUserID', 'Content']
message = ['chatId', 'senderUserId', 'Content']
userAccount = ["FirstName", "LastName", "PhoneNumber", "Username", "pass_word"]

app = Flask(__name__)
app.secret_key = 'Amir1383@'
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Amir1383@'
app.config['MYSQL_DB'] = 'telegram2'
mysql = MySQL(app)
api = Api(app)


class LoginForm(Form):
    phone_number = StringField('Phone_Number', validators=[DataRequired()])
    psw = PasswordField('psw', validators=[DataRequired()])
    submit = SubmitField('Login')


class RegisterForm(Form):
    firstname = StringField('First Name', validators=[DataRequired()])
    lastname = StringField('Last Name', validators=[DataRequired()])
    phone_number = StringField('phone_number', validators=[DataRequired()])
    username = StringField('username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Submit')


class CreateGroup(Form):
    groupName = StringField('group name', validators=[DataRequired()])


def insert(table_name, table_columns, information: tuple):
    query_str = f"insert into {table_name} ("
    for column in table_columns:
        query_str += column + ','
    query_str = query_str.rstrip(query_str[-1])
    query_str += ') values ('
    for _ in range(len(table_columns)):
        query_str += '%s,'
    query_str = query_str.rstrip(query_str[-1])
    query_str += ')'
    cursor = mysql.connection.cursor()
    cursor.execute(query_str, information)
    mysql.connection.commit()
    cursor.close()


def read(table_name, column_names, condition, information):
    query_str = 'select '
    if column_names is None:
        query_str += '*'
    else:
        for column in column_names:
            query_str += column + ','
        query_str = query_str.rstrip(query_str[-1])
    query_str += f' from {table_name}'
    cursor = mysql.connection.cursor()
    if condition is None:
        pass
        cursor.execute(query_str)
    else:
        query_str += f"{condition}"
        cursor.execute(query_str, information)
    result = cursor.fetchone()
    cursor.close()

    return result


def update(table_name, change, condition, information):
    query_str = f'UPDATE {table_name} set {change}'
    cursor = mysql.connection.cursor()
    if condition is not None:
        query_str += f"{condition}"
    cursor.execute(query_str, information)
    mysql.connection.commit()
    cursor.close()


def delete(table_name, condition, information):
    query_str = f'delete from {table_name}'
    cursor = mysql.connection.cursor()
    if condition is None:
        cursor.execute(query_str)
    else:
        query_str += f"{condition}"
        cursor.execute(query_str, information)
    mysql.connection.commit()
    cursor.close()


@app.route('/')
def home():
    return render_template('index.html')


@app.route('/chat_group <username> <group_name>', methods=['POST', 'GET'])
def group_chat(username, group_name):
    if request.method == "POST":
        data = request.get_json()
        content = data['content']
        user_id = read("userAccount", ['userID'], ' where Username = %s', [username])
        group_id = read('groupchat', ['groupchatID'], ' where groupName = %s', [group_name])
        insert('groupmessage', message, (group_id, user_id, content))
        return jsonify('success'), 200


@app.route('/chat <username> <receiver_username>', methods=['POST', 'GET'])
def chat(username, receiver_username):
    if request.method == "POST":
        data = request.get_json()
        content = data['content']
        user_id = read("userAccount", ['userID'], ' where Username = %s', [username])
        receiver_user_id = read("userAccount", ['userID'], ' where Username = %s', [receiver_username])
        chat_id = read('chat', ['chatID'], ' where userID1 = %s and userID2 = %s', (user_id, receiver_user_id))
        insert('message', message, (chat_id, user_id, content))
        return jsonify('success'), 200


@app.route('/update_user <username> <column> <new_column>', methods=['POST', 'GET'])
def update_user(username, column, new_column):
    update('useraccount', f'{column} = %s', ' where username = %s', (new_column, username))
    return jsonify('succes'), 200


@app.route('/contact <username> <contact_user>', methods=['POST', 'GET'])
def contact(username, contact_user):
    if request.method == "POST":
        user_id = read("userAccount", ['userID'], ' where Username = %s', [username])
        contact_user_id = read("userAccount", ['userID'], ' where Username = %s', [contact_user])
        insert('contacts', contacts, (user_id, contact_user_id))
        return jsonify('success'), 200


@app.route('/add_member <group_name> <username>', methods=['POST', 'GET'])
def add_member(group_name, username):
    if request.method == 'POST':
        group_name = group_name.replace('_', " ")
        print(group_name)
        group_id = read('groupChat', ["GroupChatID"], ' where groupName = %s', [group_name])
        user_id = read("userAccount", ['userID'], ' where Username = %s', [username])
        insert('groupMembers', GroupMembers, (group_id, user_id))
        return jsonify('success'), 200
    else:
        return jsonify('failed'), 400


@app.route('/groupChat <username>', methods=['POST', 'GET'])
def choose_function(username):
    if request.method == "POST":
        data1 = request.get_json()
        form_input = ImmutableMultiDict(data1)
        create_chat_form = CreateGroup(form_input)
        result = read("userAccount", ['userID'], ' where Username = %s', [username])
        insert("groupchat", groupChat, (create_chat_form.groupName.data, result[0]))
        return jsonify('success'), 200


@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == "POST":
        data1 = request.get_json()
        form_input = ImmutableMultiDict(data1)
        login_form = LoginForm(form_input)
        if login_form.validate():
            result = read("userAccount", None, ' WHERE PhoneNumber = %s and pass_word = %s', (
                                                                                            login_form.phone_number.data
                                                                                            , login_form.psw.data))
            if result:
                print("logged in")
            else:
                session['error_message'] = 'phone number or password is incorrect'
        else:
            session['error_message'] = 'Invalid credentials'
        return render_template('login.html')
    return render_template('login.html')


@app.route('/signup', methods=['POST', 'GET'])
def signup():
    if request.method == "POST":
        data1 = request.get_json()
        form_input = ImmutableMultiDict(data1)
        register_form = RegisterForm(form_input)
        if register_form.validate():
            result = read('userAccount', None, ' WHERE PhoneNumber = %s or Username = %s', (register_form.phone_number.data, register_form.username.data))
            if result:
                session['error_message'] = 'There is an account with this number or username'
                return jsonify('There is an account with this number or username'), 400
            else:
                information_tuple = (register_form.firstname.data, register_form.lastname.data, register_form.phone_number.data, register_form.username.data, register_form.password.data)
                insert('userAccount', userAccount, information_tuple)
                return jsonify('success'), 200

    return render_template('sign up.html')


if __name__ == '__main__':
    app.run(debug=True)
