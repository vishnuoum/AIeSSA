from unittest import result
from flask import Flask,request
import json
import util
from datetime import datetime
import os
import pymysql

#db connect
hostname = 'localhost'
username = 'root'
password = ''
database = 'aiessa'
myconn = pymysql.connect( host=hostname, user=username, passwd=password, db=database ,cursorclass=pymysql.cursors.DictCursor)
conn = myconn.cursor()

# specify upload folder
UPLOAD_FOLDER = './uploads'
AUDIO_UPLOAD_FOLDER = './audioUploads'

# init flask
app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['AUDIO_UPLOAD_FOLDER'] = AUDIO_UPLOAD_FOLDER

# recognize gesture
@app.route('/recognize', methods=['POST'])
def recognize():
    print(request.files)
    if request.method == 'POST':
        if 'video' not in request.files:
            return json.dumps({"status":"error"})
        now=datetime.now()
        file1 = request.files['video']
        path = os.path.join(app.config['UPLOAD_FOLDER'], now.strftime("%d%m%Y%H%M%S")+file1.filename)
        file1.save(path)
        result=util.recognize(path)
        if(result=="error"):
            return json.dumps({"status":"error"})
        conn.execute("""Insert into signprocessing(id) values(null)""")
        myconn.commit()
        return json.dumps({"sentence":result,"status":"done"})

# to extract values from lab report
@app.route('/uploadAudio', methods=['POST'])
def uploadAudio():
    print(request.files)
    if request.method == 'POST':
        if 'audio' not in request.files:
            return "error"
        now=datetime.now()
        file1 = request.files['audio']
        path = os.path.join(app.config['AUDIO_UPLOAD_FOLDER'], now.strftime("%d%m%Y%H%M%S")+file1.filename)
        file1.save(path)
        count=conn.execute("""Insert into audio(userId,label,path) Values((Select id from users where mail=%s),%s,%s)""",[request.form.get("mail"),request.form.get("label"),path])
        myconn.commit()
        if(count==1):
            return "done"
        else:
            return "error"

# to extract values from lab report
@app.route('/classifyAudio', methods=['POST'])
def classifyAudio():
    print(request.files)
    if request.method == 'POST':
        try:
            if 'audio' not in request.files:
                return "error"
            now=datetime.now()
            file1 = request.files['audio']
            path = os.path.join(app.config['AUDIO_UPLOAD_FOLDER'], now.strftime("%d%m%Y%H%M%S")+file1.filename)
            file1.save(path)
            conn.execute("""Select label, path from audio where userId=(Select id from users where mail=%s)""",[request.form.get("mail")])
            result = conn.fetchall()
            label = util.audioClassifier(path=path,pathList=result)
            return label
        except Exception as e:
            print(e)
            return "error"

if __name__ == '__main__':
    app.run(debug=True,port=3001,host="0.0.0.0")