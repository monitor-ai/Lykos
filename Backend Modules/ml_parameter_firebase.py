import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import keras
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation

##Application registration

cred=credentials.Certificate("ml-parameter-firebase-adminsdk-kzlzj-689846709e.json")

firebase_admin.initialize_app(cred, {'databaseURL': 'https://ml-parameter.firebaseio.com/'})

##Training Dataset for testing the API
X_train = np.random.rand(1000,40)
Y_train = np.random.randint(2, size=(1000,2))


##Callback trainingplot for losses sending                  Need To add Try Catch Statement for Exception handling and Docstrings for instruction Support..Will do later after full development
class TrainingPlot(keras.callbacks.Callback):
    
    def __init__(self,username,model_name):
        super(keras.callbacks.Callback, self).__init__()
        self.username = username
        self.model_name=model_name
        
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

    # This function is called at the end of each epoch
    def on_epoch_end(self, epoch, logs={}):                     ##Need to add try catch statement for val loss and accuracy as it cannot be put into firebase without it
        # Append the logs, losses and accuracies to the lists
        self.logs.append(logs)
        self.losses.append(logs.get('loss'))
        self.acc.append(str(logs.get('accuracy')))
        #self.val_losses.append(logs.get('val_loss'))
        #self.val_acc.append(logs.get('val_acc'))
        main_ref = db.reference('/')
        users_ref = main_ref.child(self.username)
        users_ref.set({self.model_name:{'acc':self.acc,
                       'loss':self.losses}})
                       # 'val_loss':self.val_losses,
                     #'val_acc':self.val_acc}})


##Main API Class
class ML_Parameter:
    def Loss_Monitor(username,model_name):
        history=TrainingPlot(username,model_name)
        return history
    def Pause_Model():
        pass
    def Resume_Model():
        pass


##Neural Network Model
def generateModel():
    
    model = Sequential()
    model.add(Dense(32,input_dim=(40)))
    model.add(Dense(64))
    model.add(Activation('relu'))
    model.add(Dense(32))
    model.add(Activation('relu'))
    model.add(Dense(16))
    model.add(Activation('relu'))
    
    model.add(Dense(2))
    model.add(Activation('softmax'))
    
    model.compile(optimizer='Adam',loss='binary_crossentropy', metrics=['accuracy'])
    
    return model


#Testing The Model
model = generateModel()

'''history = '''
history =ML_Parameter.Loss_Monitor("rahul","random_model")
model.fit(X_train, Y_train, epochs=10, callbacks=[history],)