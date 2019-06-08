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

##Callback trainingplot for losses sending
class TrainingPlot(Callback):
    '''
    Callback Class for sending the loss and accuracy to firebase
    '''

    def __init__(self,username,model_name):
        '''
        Constructor
        '''
        super(Callback, self).__init__()
        self.username = username
        self.model_name=model_name

    # This function is called when the training begins
    def on_train_begin(self, logs={}):
        '''
        Inbuilt Callback Function which is called when training begins
        '''
        # Initialize the lists for holding the logs, losses and accuracies
        self.losses = []
        self.acc = []
        self.val_losses = []
        self.val_acc = []
        self.logs = []

    def on_train_batch_begin(self, *args, **kwargs):
        '''
        Inbuilt callback function which is called when training batch begins
        '''
        pass
    def on_train_batch_end(self, *args, **kwargs):
        '''
        Inbuilt Callback function which is called when training batch ends
        '''
        pass
    def on_batch_end(self,batch,logs={}):
        '''
        Inbuilt Callback function which is called when batch ends
        '''
        pass

    # This function is called at the end of each epoch
    def on_epoch_end(self, epoch, logs={}):
        '''
        Inbuilt callback function which is called when epoch ends
        '''
        # Append the logs, losses and accuracies to the lists
        self.logs.append(logs)
        self.losses.append(logs.get('loss'))
        self.acc.append(str(logs.get('accuracy')))
        self.val_losses.append(logs.get('val_loss'))
        self.val_acc.append(str(logs.get('val_accuracy')))
        main_ref = db.reference('/')
        users_ref = main_ref.child(self.username)
        if None in self.val_losses:
            users_ref.set({self.model_name:{'acc':self.acc,
                           'loss':self.losses}})
        else:
            users_ref.set({self.model_name:{'acc':self.acc,
                                            'loss':self.losses,
                                            'val_loss':self.val_losses,
                                            'val_acc':self.val_acc}
                         })


##Callback Pausing_Model for model pausing
class Pausing_Model(Callback):
    '''
    Callback Class for Pausing or Stopping the Model
    '''
    def __init__(self,username,model_name,weights_file):
        super(Callback, self).__init__()  ##Constructor Override for initializing custom parameters
        self.username = username
        self.model_name=model_name
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        self.epoch=0
        self.weights_file=weights_file

    def on_epoch_begin(self, epoch, logs={}):
        '''
        Inbuilt Callback Function which is called when loop begins
        '''
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_file)
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
            users_ref.set(self.epoch)
            print("training stopped-epoch begin %d" % epoch)
        else:
            self.epoch=self.epoch+1

    def on_epoch_end(self, epoch, logs={}):
        '''
        Inbuilt Callback Function which is called when loop ends
        '''
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_file)
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
            users_ref.set(self.epoch)
            print("training stopped-epoch end %d" % epoch)

    def on_batch_begin(self, batch, logs={}):
        '''
        Inbuilt Callback Function which is called when batch starts
        '''
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_file)
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
            users_ref.set(self.epoch)
            print("training stopped-batch begin %d" % batch)

    def on_batch_end(self, batch, logs={}):
        '''
        Inbuilt Callback Function which is called when batch ends
        '''
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_file)
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
            users_ref.set(self.epoch)
            print("training stopped-batch end %d" % batch)

    def on_train_begin(self, logs={}):
        '''
        Inbuilt Callback Function which is called when training begins
        '''
        #code to update flag from firebase
        self.main_ref = db.reference('/')
        self.users_ref = self.main_ref.child(self.username).child(self.model_name).child("stop_flag")
        self.stop_flag =self.users_ref.get()
        if self.stop_flag==1:
            self.model.stop_training = True
            self.model.save_weights(self.weights_file)
            main_ref = db.reference('/')
            users_ref = main_ref.child(self.username).child(self.model_name).child("epoch")
            users_ref.set(self.epoch)
            print("training stopped-train begin")



##Class resume Model for resuming the model after pausing. can be only used when pause callback is used
class Resume_Model:
    '''
    Class for Resuming the Model after Pause
    '''
    def __init__(self,username,model_name,epochs,model_object,weights_file):
        '''
        Constructor
        '''
        self.username=username
        self.model_name=model_name
        self.epochs=epochs
        self.model=model_object
        self.remaining_epochs=int(db.reference('/').child(self.username).child(self.model_name).child("epoch").get())
        self.weights_file=weights_file
    def resume(self):
        '''
        This Function is Called when The model needs to be resumed after it is paused using Pausing_Model Callback Class
        '''
        self.stop_flag_reference=db.reference('/').child(self.username).child(self.model_name).child("stop_flag")
        while True:
            if self.stop_flag_reference.get()==0:
                self.model.load_weights(self.weights_file)
                self.model.fit(X_train, Y_train, epochs=self.remaining_epochs,verbose=2)
                self.model.save_weights("my_model_1.h5")
                break
        return self.model



##Main API Class
class ML_Parameter:                ##Need to add Name of the Mobile Application Later and Change the Class Name to the App Name
    '''
    Library for Monitoring Training and Validation Losses,Accuracy Remotely through Mobile Application
    Along with the feature of Remotely Stopping the Model Through The application
    '''
    def Loss_Monitor(username,model_name):
        '''
        Funtion to send Losses and Accuracy which is observed in the Mobile Application

        Arguments:
        username:The Sign In Username used in the mobile application
        model_name:The name of the Model as set in the mobile application

        Returns:
        history:Callback object which has all the losses and accuracy

        Eg:
        history =ML_Parameter.Loss_Monitor("rahul","random_model")
        model.fit(X_train, Y_train, epochs=300, callbacks=[history])
        '''
        history=TrainingPlot(username,model_name)
        return history
    def Stop_Model(username,model_name,weights_file):
        '''
        Function to Stop the Model Remotely and Store weights

        Arguments:
        username:The Sign In Username used in the mobile application
        model_name:The name of the Model as set in the mobile application
        weights_file:Name of the Weights File which you want to keep after stopping the Model

        Returns:
        history:Callback object which has all the losses and accuracy

        Eg:
        history =ML_Parameter.Stop_Model("rahul","random_model","model_weights.h5")
        model.fit(X_train, Y_train, epochs=300, callbacks=[history])
        '''
        history=Pausing_Model(username,model_name,weights_file)
        return history
    '''
    def Resume_Model(username,model_name,epochs,model_object,weights_file):

        Function to Resume the Model after it has been stopped Remotely

        Note:Can Be Used only when Stop_Model Function of the class has been used

        Arguments:
        username:The Sign In Username used in the mobile application
        model_name:The name of the Model as set in the mobile application
        epochs:Total Number of epochs you want the model to run after resuming
        model_object:The Sequential or keras model reference object
        weights_file:Name of the Weights File which you have kept after stopping the Model

        Eg:
        history =ML_Parameter.Stop_Model("rahul","random_model")
        model.fit(X_train, Y_train, epochs=300, callbacks=[history])
        model_new=ML_Parameter.Resume_Model("rahul","random_model",10,model,'model_weights.h5')

        model=Resume_Model(username,model_name,epochs,model_object,weights_file).resume()
        return model
    '''
