import sys
from firebase_admin import db
import numpy as np
import firebase_admin
from firebase_admin import credentials
from keras.models import Sequential
from keras.layers import Dense, Activation
from keras.callbacks import Callback

total_epochs = int(sys.argv[1])
current_epoch = int(sys.argv[2])
username = str(sys.argv[3])
model_name = str(sys.argv[4])
data_path = str(sys.argv[5])
weights_path = str(sys.argv[6])

#print(sys.argv)

cred = credentials.Certificate("ml-parameter-firebase-adminsdk-kzlzj-689846709e.json")

firebase_admin.initialize_app(cred, {'databaseURL': 'https://ml-parameter.firebaseio.com/'})

X_train = np.load(data_path + "X_train.npy")
Y_train = np.load(data_path + "Y_train.npy")

class TrainingPlot(Callback):

    def __init__(self, username, model_name):
        super(Callback, self).__init__()
        self.username = username
        self.model_name = model_name

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
        self.acc.append(str(logs.get('acc')))
        #self.val_losses.append(logs.get('val_loss'))
        #self.val_acc.append(logs.get('val_acc'))
        main_ref = db.reference('/')
        users_ref = main_ref.child(self.username).child(self.model_name)
        users_ref.update({'acc':self.acc, 'loss':self.losses})                       

##Callback Pausing_Model for model pausing
class Pausing_Model(Callback):
    
    def __init__(self, username, model_name, weights_path):
        super(Callback, self).__init__()
        self.username = username
        self.model_name = model_name
        self.weights_path = weights_path
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag = self.users_ref.get()
        self.epoch=0

    def on_epoch_begin(self, epoch, logs={}):
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_path + 'model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("current_epoch")
            users_ref.set(self.epoch)
            print("training stopped-epoch begin %d" % epoch)
        else:
            self.epoch=self.epoch+1

    def on_epoch_end(self, epoch, logs={}):
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_path + 'model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("current_epoch")
            users_ref.set(self.epoch)
            print("training stopped-epoch end %d" % epoch)

    def on_batch_begin(self, batch, logs={}):
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_path + 'model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("current_epoch")
            users_ref.set(self.epoch)
            print("training stopped-batch begin %d" % batch)

    def on_batch_end(self, batch, logs={}):
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_path + 'model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("current_epoch")
            users_ref.set(self.epoch)
            print("training stopped-batch end %d" % batch)

    def on_train_begin(self, logs={}):
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_path + 'model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("current_epoch")
            users_ref.set(self.epoch)
            print("training stopped-train begin")
            
class Update_Epoch(Callback):            
    def __init__(self, username, model_name, current_epoch):
        super(Callback, self).__init__()
        self.username = username
        self.model_name = model_name
        self.current_epoch = current_epoch
        
    def on_epoch_begin(self, epoch, logs={}):
        main_ref = db.reference('/')
        users_ref = main_ref.child(username).child(model_name)
        users_ref.update({"current_epoch":(epoch+1)})
    
class ML_Parameter:
    
    def Loss_Monitor(username, model_name):
        history = TrainingPlot(username, model_name)
        return history
    def Pause_Model(username, model_name, weights_path):
        pause = Pausing_Model(username, model_name, weights_path)
        return pause
    def Update_Db_Epoch(username, model_name, current_epoch):
        update = Update_Epoch(username, model_name, current_epoch)
        return update
        
        
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

    model.compile(optimizer = 'Adam', loss = 'binary_crossentropy', metrics = ['accuracy'])

    return model

model = generateModel()
history = ML_Parameter.Loss_Monitor(username, model_name)
pause = ML_Parameter.Pause_Model(username, model_name, weights_path)
update = ML_Parameter.Update_Db_Epoch(username, model_name, current_epoch)

model.fit(X_train, Y_train, epochs=total_epochs-current_epoch, callbacks=[history, pause, update])            
