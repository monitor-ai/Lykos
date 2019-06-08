import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

data = os.getcwd() + "/Sample-Data/"
weights = os.getcwd() + "/Sample-Weights/"

cred = credentials.Certificate("ml-parameter-firebase-adminsdk-kzlzj-689846709e.json")

firebase_admin.initialize_app(cred, {'databaseURL': 'https://ml-parameter.firebaseio.com/'})

username = "arnav"
model_name= "sample-model"
main_ref = db.reference('/')
users_ref = main_ref.child(username).child(model_name)

while True:    
    stop_flag = int(users_ref.child("stop_flag").get())
    start_flag = int(users_ref.child("start_flag").get())
    current_epoch = int(users_ref.child("current_epoch").get())
    total_epochs = int(users_ref.child("total_epochs").get())
    
    if start_flag == 1:
        users_ref.update({"start_flag":0})
        params = "python sample-train.py " + str(total_epochs) + " " + str(current_epoch) + " " + str(username) + " " + str(model_name) + " " + data + " " + weights 
        os.system(params)
        
        