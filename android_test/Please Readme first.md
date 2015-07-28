#This file is the test-android-program for map loading by Henry Lee

When use this file:

requirement:
	Python + Flask + MySQLdb;
	MySQL;
	Android Studio
	
1)
	make sure your android phone and your computer have linked to the same wifi,check your computer's ip addr and replace the variable "URL_Service (may be http://192.168.1.100/ because that is my computer's ip under family wifi)" in the android java file "BLConstants"  

2)
	make sure you have set up the python+flask environment,and run the flask web server,the test images are saved at "/static/images/" , 
	

3)
	run the MySQL  at  -u root -p    (user:root pw:NULL)
	set up MySQL with the script; 
	you can also add some picture and update the database with the form like:
	insert into map_db values("the map id you want","the picture file name you want");

4)
	run the program on your phone, click "Login";
	Search the mapid I set up or you set up then the picture will be display.