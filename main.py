# -*- coding: utf-8 -*-
import types
import json
import os
import MySQLdb
import sqlite3
import string

from localization import localization
from flask import Flask, jsonify, render_template,request

testserver = Flask(__name__)

def send_login_json(flag, data=None):
    """  send login json
         ---------------

         - flag: 1 means that user exists while 0 that means not
         - data: position
         return json response
    """
    if flag:
        if not data:
            data = {}
        ok_json = {'ok':True, 'loc':data}
        return json.dumps(ok_json)
    else:
        fail_json = {'ok':False}
        return json.dumps(fail_json)

def query_json(flag, data=None):
    """ query json
        ----------

         - flag: 1 means that user exists while 0 that means not
         - data: position
         return json response
    """
    if flag:
        if not data:
            data = {}
        ok_json = {'ok':True, 'loc':data}
        return json.dumps(ok_json)
    else:
        fail_json = {'ok':False}
        return json.dumps(fail_json)


@testserver.route('/login/',methods=['GET','POST'])
def login():
    """  Login function
         --------------

         - post user's name, passwd, rss, id_num, timestamp to server
         - stat=1 represents admin while stat=0 means worker
         - if authorized, return position data and record the personal infomation (time, position, rss)
    """
    if request.method == "POST":
        usern = request.form.get('username')
        passw = request.form.get('password')
        rss = request.form.get('rss')
        stat = request.form.get('status')
        time = request.form.get('time')
        rssv = string.atof(rss)    # scalar not vector
        location = localization.loc(rss) # apply localization function

        # connect to db
        db = MySQLdb.connect(host='localhost', user='root', passwd='wuyou', db='noyou_db') 
        cursor = db.cursor()        
        # verify user info
        sql = "select * from account where username=%s and password=%s and status=%s"
        exist = cursor.execute(sql, (usern, passw, stat))

        # insert position into db
        insertrec="insert into locrecord (username, rss, loc, time) values(%s, %s, %s, %s)"
        if exist == 1:
            cursor.execute(insertrec, (usern, rss, location, time))        
        db.commit()
        cursor.close()
        db.close()
        logfail = 'account does not exist'
        logsucess = '%f' % (location)
        if exist == 1:       
            return send_login_json(flag=1, logsucess)
        if exist != 1:
            return send_login_json(flag=0)

    # return the login html template
    if request.method=="GET":
        return render_template('login.html')


@testserver.route('/query/', methods=['GET','POST'])
def query():
    """  query function
         --------------

         query on one's position at a certain moment
    """
    if request.method == "GET":
        return render_template('query.html')
    if request.method == "POST":
        usern = request.form.get('username')
        passw = request.form.get('password')
        quser = request.form.get('quser')
        stat = request.form.get('status')
        time = request.form.get('time')

        # connect to db
        db = MySQLdb.connect(host='localhost', user='root', passwd='wuyou', db='noyou_db') 
        cursor = db.cursor()        

        # verify user info
        sql = "select * from account where username=%s and password=%s and status=%s"
        quserv = "select * from locrecord where username=%s"
        query = "select * from locrecord where username=%s and time=%s"
        exist = cursor.execute(sql,(usern, passw, stat))
        qexist  = cursor.execute(quserv,(quser))
        qtexist = cursor.execute(query,(quser, time))
        
        if exist == 1 & qtexist == 1:
            cursor.execute(query,(quser, time))
            qloc = cursor.fetchone()
            loca = qloc[0]
            qresult = "%s" %(loca)
            cursor.close()
            db.close()
            return query_json(flag=1, qresult)
        else:
            cursor.close()
            db.close()
            return query_json(flag=0)



if __name__=='__main__':
  
    testserver.run(host='0.0.0.0', port=5000,debug=True)
