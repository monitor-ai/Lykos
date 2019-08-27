import pyrebase
import datetime
from keras.callbacks import Callback
import time

class Lykos:
    def __init__(self, email, password, model_key):
        config = {
          "apiKey": "AIzaSyByFcG5hKP9GfDjcADHpM1LOL8Y4_IadNI",
          "authDomain": "ml-parameter.firebaseapp.com",
          "databaseURL": "https://ml-parameter.firebaseio.com/",
          "storageBucket": "ml-parameter.appspot.com"
        }
        self.firebase = pyrebase.initialize_app(config)
        self.email = email
        self.password = password
        self.model_key = model_key

    def Loss_Monitor(self):
        history = TrainingPlot(self.firebase, self.email, self.password, self.model_key)
        return history
    def fit(self, model, X, Y, epochs = 10, verbose = 1):        
        history = self.Loss_Monitor()
        if(X_train is None):
            raise Exception("Please add independent variable!")
        if(Y_train is None):
            raise Exception("Please add dependent variable!")
        if(epochs is None):
            raise Exception("Please add epochs variable!")

        model.fit(X_train, Y_train, epochs=epochs, callbacks=[history], verbose = verbose)
        
    '''
    def Pause_Model(username, model_name, weights_path):
        pause = Pausing_Model(email, model_name, weights_path)
        return pause
    def Update_Db_Epoch(username, model_name, current_epoch):
        update = Update_Epoch(email, model_name, current_epoch)
        return update
    '''
    
class TrainingPlot(Callback):
    
    def __init__(self, firebase, email, password, model_key):
        super(Callback, self).__init__()
        self.auth = firebase.auth()
        self.db = firebase.database()
        self.username = self.authenticate(email, password)
        self.model_key = model_key
        
    def authenticate(self, email, password):
        try:
            user = self.auth.sign_in_with_email_and_password(email, password)
        except:
            raise Exception("There is no user with that credentials. Please try and correct it.")
        return user['localId']
    
    # This function is called when the training begins
    def on_train_begin(self, logs={}):
        # Initialize the lists for holding the logs, losses and accuracies
        self.losses = []
        self.acc = []
        self.val_losses = []
        self.val_acc = []
        self.logs = []

    def on_train_batch_begin(self, *args, **kwargs):
        pass
    def on_train_batch_end(self, *args, **kwargs):
        pass
    def on_batch_end(self,batch,logs={}):
        pass
    '''
    def on_epoch_begin(self, batch, logs=[]):
        self.epoch_time_start = time.time()
    '''
    # This function is called at the end of each epoch
    def on_epoch_end(self, epoch, logs={}):                     ##Need to add try catch statement for val loss and accuracy as it cannot be put into firebase without it
        # Append the logs, losses and accuracies to the lists
        self.logs.append(logs)
        self.losses.append(logs.get('loss'))
        self.acc.append(logs.get('acc'))
        #self.val_losses.append(logs.get('val_loss'))
        #self.val_acc.append(logs.get('val_acc'))
        main_ref = self.db
        users_ref = main_ref.child(self.username).child("models").child(self.model_key)
        users_ref.update({'acc':self.acc, 'loss':self.losses, 'lastUpdatedOn': str(datetime.datetime.now().isoformat())})

'''
MAIN MODULE
'''
from keras.models import Sequential
from keras.layers import Dense, Activation
from sklearn.preprocessing import StandardScaler
import pandas as pd
import numpy as np

email = "chintupokar@gmail.com"
password = "india123"
model_key = "-Ljj2C8oeVTA4-SzMz6c"
total_epochs = 100
current_epoch = 1

data = pd.read_csv('data.csv')
X_train = np.array(data.iloc[:, [2, 3]])
Y_train = np.array(data.iloc[:, 4])

sc = StandardScaler()
X_train = sc.fit_transform(X_train)

def generateModel():

    model = Sequential()
    model.add(Dense(2,input_dim=(2)))
    model.add(Dense(16))
    model.add(Activation('sigmoid'))
    model.add(Dense(1))
    model.add(Activation('sigmoid'))
    model.compile(optimizer = 'adadelta', loss = 'binary_crossentropy', metrics = ['accuracy'])
    return model

model = generateModel()
model.summary()
lykos = Lykos(email, password, model_key)
lykos.fit(model = model, X = X_train, Y = Y_train, epochs = 100, verbose=1)
#pause = ML_Parameter.Pause_Model(username, model_name, weights_path)
#update = ML_Parameter.Update_Db_Epoch(username, model_name, current_epoch)

