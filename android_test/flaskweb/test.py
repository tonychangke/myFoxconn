#coding:utf8
from flask import Flask,render_template,request,url_for,jsonify
import MySQLdb
import sqlite3
import string
import json
import types
import os
app=Flask(__name__)
@app.route('/')
def index():
    return render_template('1.html',nav_list=nav_list,username=username,blog=blog)
@app.route('/user',methods=['POST','GET'])
def user():
    #id = request.args.get('id')
    if request.method == 'GET':
        return 'hahaha'
    else:
        id = request.form['id']
        return 'hahaha ' + id

@app.route('/image_request',methods=['POST'])
def img_req():
    img = request.form['mapid']
    db = MySQLdb.connect(host='127.0.0.1',user='root',passwd='',db='helloworld')
    cursor = db.cursor()
    sql = "select mapurl from map_db where mapid="+img
    cursor.execute(sql)
    results = cursor.fetchall()
    
    return results[0][0]

if __name__ == '__main__':
    app.debug = True
    app.run(host="0.0.0.0",port=80)

