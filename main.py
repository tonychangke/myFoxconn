# -*- coding: cp936 -*-
from flask import Flask, jsonify, render_template,request
import types
import json
import os
import MySQLdb
import sqlite3
import string
from loc import localization

testserver=Flask(__name__)
#定义验证通过与否后，应该返回什么
def send_ok_json(data=None):
    if not data:
        data = {}
    ok_json = {'ok':True, 'loc':data}
    return json.dumps(ok_json)

def send_fail_json():
    fail_json = {'ok':False}
    return json.dumps(fail_json)

#定义查询位置所返回的数据
def query_ok_json(data=None):
    if not data:
        data = {}
    ok_json = {'ok':True, 'loc':data}
    return json.dumps(ok_json)

def query_fail_json():
    fail_json = {'ok':False}
    return json.dumps(fail_json)

#login函数实现的功能
#1、利用post方式直接向服务器传送用户名、密码、rss、身份、时间信息。
#2、stat表明是工人还是管理员,1为管理员，0工人
#3、如果通过认证，则返回位置数据，并记录下这个人的位置信息（包括时刻，位置，指纹）
@testserver.route('/login/',methods=['GET','POST'])
def login():
    if request.method=="POST":
        usern=request.form.get('username')
        passw=request.form.get('password')
        rss=request.form.get('rss')
        stat=request.form.get('status')
        time=request.form.get('time')
        rssv=string.atof(rss)#标量，暂时不是向量
        location=localization.loc(rss) #调用定位函数，根据RSS进行定位

        #连接数据库
        db=MySQLdb.connect(host='localhost',user='root',passwd='wuyou',db='noyou_db') 
        cursor=db.cursor()        
        #执行sql语句
        #核对用户
        sql="select * from account where username=%s and password=%s and status=%s"#判返回统计的数据记录数
        exist=cursor.execute(sql,(usern, passw, stat))#返回统计
        #往记录数据库里插入位置信息
        insertrec="insert into locrecord (username, rss, loc, time) values(%s, %s, %s, %s)"#往位置数据库里插入记录，记录位置、用户名、时间、rss
        if exist==1:#如果存在该用户密码正确，则插入记录
            cursor.execute(insertrec, (usern, rss, location, time))        
        db.commit()
        cursor.close()
        db.close()
        logfail='account does not exist'
        logsucess='%f' %(location)#
        if exist==1:       
            return send_ok_json(logsucess)
        if exist!=1:
            return send_fail_json(logfail)
        
       
    #在浏览器上做测试
    if request.method=="GET":
        return render_template('login.html')


#查询某个人在某个时间的位置.
#删除了qexist的判断！
@testserver.route('/query/',methods=['GET','POST'])
def query():
     #在浏览器上做测试
    if request.method=="GET":
        return render_template('query.html')
    if request.method=="POST":
        usern=request.form.get('username')
        passw=request.form.get('password')
        quser=request.form.get('quser')
        stat=request.form.get('status')
        time=request.form.get('time')
        #连接数据库
        db=MySQLdb.connect(host='localhost',user='root',passwd='wuyou',db='noyou_db') 
        cursor=db.cursor()        
        #执行sql语句
        #核对用户
        sql="select * from account where username=%s and password=%s and status=%s"#判返回统计的数据记录数
        quserv="select * from locrecord where username=%s"#检查指纹记录库里是否存在该用户。还可以加一条在啊count表里是否有他
        query="select * from locrecord where username=%s and time=%s"#查询时间设定暂没想好怎么弄
        exist=cursor.execute(sql,(usern, passw, stat))#返回统计
        qexist=cursor.execute(quserv,(quser))
        qtexist=cursor.execute(query,(quser, time))
        
        if exist==1 & qtexist==1:#如果通过验证并且是管理员,并且存在记录。记录不能是重复的（可修改）
            cursor.execute(query,(quser, time))
            qloc=cursor.fetchone()
            loca=qloc[0]
            qresult="%s" %(loca)
            cursor.close()
            db.close()
            return query_ok_json(qresult)
        else:
            cursor.close()
            db.close()
            return query_fail_json()#可多加几类判断





if __name__=='__main__':
  
    testserver.run(host='0.0.0.0', port=5000,debug=True)
