import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import keras
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Activation
from tensorflow.keras.callbacks import Callback
##Application registration

cred=credentials.Certificate("ml-parameter-firebase-adminsdk-kzlzj-689846709e.json")

firebase_admin.initialize_app(cred, {'databaseURL': 'https://ml-parameter.firebaseio.com/'})

##Training Dataset for testing the API
X_train = np.random.rand(1000,40)
Y_train = np.random.randint(2, size=(1000,2))


##Callback trainingplot for losses sending
##Need To add Try Catch Statement for Exception handling and Docstrings for instruction Support..Will do later after full development
class TrainingPlot(Callback):

    def __init__(self,username,model_name):
        super(Callback, self).__init__()
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


##Callback Pausing_Model for model pausing
class Pausing_Model(Callback):
    def __init__(self,username,model_name):
        super(Callback, self).__init__()
        self.username = username
        self.model_name=model_name
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        self.epoch=0

    def on_epoch_begin(self, epoch, logs={}):
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights('model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
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
            self.model.save_weights('model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
            users_ref.set(self.epoch)
            print("training stopped-epoch end %d" % epoch)

    def on_batch_begin(self, batch, logs={}):
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights('model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
            users_ref.set(self.epoch)
            print("training stopped-batch begin %d" % batch)

    def on_batch_end(self, batch, logs={}):
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights('model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
            users_ref.set(self.epoch)
            print("training stopped-batch end %d" % batch)

    def on_train_begin(self, logs={}):
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights('model_weights.h5')
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
            users_ref.set(self.epoch)
            print("training stopped-train begin")



##Class resume Model for resuming the model after pausing. can be only used when pause callback is used
class Resume_Model:
    def __init__(self,username,model_name,epochs,model_object,weights_file):
        self.username=username
        self.model_name=model_name
        self.epochs=epochs
        self.model=model_object
        self.remaining_epochs=int(db.reference('/').child(self.username).child(self.model_name).child("epoch").get())
        self.weights=weights_file
    def resume(self):
        self.stop_flag_reference=db.reference('/').child(self.username).child(self.model_name).child("stop_flag")
        while True:
            if self.stop_flag_reference.get()==0:
                self.model.load_weights(self.weights)
                self.model.fit(X_train, Y_train, epochs=self.remaining_epochs,verbose=2)
                self.model.save_weights("my_model_1.h5")
                break
        return self.model



##Main API Class
class ML_Parameter:
    def Loss_Monitor(username,model_name):
        history=TrainingPlot(username,model_name)
        return history
    def Pause_Model(username,model_name):
        history=Pausing_Model(username,model_name)
        return history
    def Resume_Model(username,model_name,epochs,model_object,weights_file):
        model=Resume_Model(username,model_name,epochs,model_object,weights_file).resume()
        return model



##Neural Network Model for testing
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


#Testing The Model and callbacks
model = generateModel()

'''history = '''
history =ML_Parameter.Pause_Model("rahul","random_model")
model.fit(X_train, Y_train, epochs=300, callbacks=[history],)
model_new=ML_Parameter.Resume_Model("rahul","random_model",10,model,'model_weights.h5')
