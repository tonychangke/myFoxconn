# -*- coding: utf-8 -*-
import types
import json
import os
import MySQLdb
import sqlite3
import string

from localization import localization
from flask import Flask, jsonify, render_template,request,send_from_directory

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

@testserver.route("/", methods=['GET','POST'])
def index():
    """ Index page for login """
    if request.method == "POST":
        return render_template("map.html")
    else:
        return render_template("base.html")

@testserver.route('/login/', methods=['GET','POST'])
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
            return send_login_json(1, logsucess)
        if exist != 1:
            return send_login_json(0)

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
            return query_json(1, qresult)
        else:
            cursor.close()
            db.close()
            return query_json(0)



@testserver.route('/register/', methods=['GET','POST'])
def register():
    """  register function
         --------------

         register a new user. an Invitation code is needed. 未区分普通用户管理元注册，暂未添加邮箱库
    """
    if request.method == "GET":
        return render_template('register.html')
    if request.method == "POST":
        usern = request.form.get('username')
        passw = request.form.get('password')
        cpassw = request.form.get('cpassword')
        email = request.form.get('email')
        stat = request.form.get('status')
        cemail = request.form.get('cemail')
        code = request.form.get('invicode')
        # connect to db
        db = MySQLdb.connect(host='localhost', user='root', passwd='wuyou', db='noyou_db') 
        cursor = db.cursor()
        codeveri = "select * from invitation_code where invicode=%s"
        exist = cursor.execute(codeveri,(code))
        insert = "insert into account (username, password, status) values(%s, %s, %s)"
        searchname = "select * from account where username=%s"
        nexist = cursor.execute(searchname,(usern))
        if exist == 1:
            if nexist !=1:
                if (passw) == (cpassw):
                    #return ('right')
                    paconfirm = 1
                   # return ('gith')
                else:
                    paconfirm = 0
                    return ('two passwords are different')
                if (cemail) == (email):
                    emconfirm = 1
                    #return ('gith')
                else:
                    emconfirm = 0
                    return ('two emails are different')
                if paconfirm == 1:
                    if stat == '1' or stat == '0':
                        cursor.execute(insert,(usern, passw, stat))
                        db.commit()
                        cursor.close()
                        db.close()
                        return ('regi ok')
                    else:
                        return ('status invalid')
                else:
                    return ('fail')
            else:
                return ('your username has been used')
        else:
            return ('your code is invalid')



@testserver.route('/locimg/<location>', methods=['GET','POST'])
def locimg(location):
    """  locimg function
         --------------

         download the needed image of a certain location. filename should include the  extension
    """
    return send_from_directory(directory='static\img',filename=location, as_attachment=True)



if __name__=='__main__':
  
    testserver.run(host='0.0.0.0', port=5000,debug=True)
