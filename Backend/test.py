'''
MAIN MODULE
'''
from keras.models import Sequential
from keras.layers import Dense, Activation
from sklearn.preprocessing import StandardScaler
import pandas as pd
import numpy as np
from lykos import Lykos

email = "chintupokar@gmail.com"
password = "india123"
#model_key = "-Ljj2C8oeVTA4-SzMz6c"
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
lykos = Lykos(email, password)

#Run this after running above code
lykos.fit(model = model, X = X_train, Y = Y_train, epochs = 100, verbose=1)