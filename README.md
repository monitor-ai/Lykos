# Lykos [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
An app to get the information about various ML parameters during training on the go!
![Lykos](https://raw.githubusercontent.com/monitor-ai/Lykos/master/Frontend/logo.png)

## Currently supported frameworks
- Keras 

## Setup for demo project

1. Install Lykos App and register a new account.
2. Clone this repository.
3. Navigate to Backend directory.
4. Open test.py file.
5. Replace **email** variable with your email address, similarly replace **password** variable with your password.
6. Run the code till line number **33**
```python
lykos = Lykos(email, password)
```
7. A QR Code will be generated.
8. Scan this QR Code using the Mobile App by clicking on New Model button.
9. Finally run the last line.
```python
lykos.fit(model = model, X = X_train, Y = Y_train, epochs = 100, verbose=1)
```

## Setup for your project

1. Install Lykos App and register a new account.
2. Clone this repository.
3. Navigate to Backend directory.
4. Copy lykos.py to your project directory.
5. Open your main python project file.
6. Import Lykos class from lykos package using following line.
```python
from lykos import Lykos
```
7. Create object of Lykos class which takes email and password as arguments.
```python
lykos = Lykos('email@domain.com', 'password')
```
8. This will generate a QR Code scan that using the Mobile App by clicking on New Model button.
9. Finally call fit method of using lykos object and pass your keras model, your independent variable, your dependent variable and epochs.
```python
lykos.fit(model = model, X = X_train, Y = Y_train, epochs = 100, verbose=1)
```

## Screenshots

![Lykos](https://raw.githubusercontent.com/monitor-ai/Lykos/master/Frontend/screenshots.jpg)

## Contributors
<p>
  <a href="https://github.com/dakshpokar"><img height="100px" src="https://raw.githubusercontent.com/monitor-ai/Lykos/master/Frontend/makers/daksh.png"></a>
  <a href="https://github.com/rahulmoorthy19"><img height="100px" src="https://raw.githubusercontent.com/monitor-ai/Lykos/master/Frontend/makers/rahul.png"></a>
  <a href="https://github.com/arnavdodiedo"><img height="100px" src="https://raw.githubusercontent.com/monitor-ai/Lykos/master/Frontend/makers/arnav.png"></a>
  <a href="https://github.com/13atharva"><img height="100px" src="https://raw.githubusercontent.com/monitor-ai/Lykos/master/Frontend/makers/atharva.png"></a>
</p>
