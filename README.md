# Randombrot Project

This is a Twitter bot that generates randomly created Mandelbrot fractals. 
The program will create an image, upload it to a Twitter account, 
and then sleep for an hour, creating at least 24 fractals a day (more or 
less depending on the complexity of the given random function and it's variables, 
since this will be running on a Raspberry Pi which has a low GHz ARM processor).

# Toolkit

The Mandelbrot program is written in Racket. The Twitter upload is written in 
Python. Since Racket doesn't have a standard OAuth 1.0 library, it's easier to 
use Python to do a very minimal action and call it from within Racket. 
Until Racket gets an OAuth 1.0 default implementation (which it probably won't), 
the upload will just be done with Python.

# Mandelbrot Set Definition

A Mandelbrot set is a set of complex numbers _c_ for which the function 
f(z) = z^2 + c does not diverge. To make things more variable, we will pick 
random functions from a pre-defined list of functions and choose a random 
seed for _c_ to act as a base.

For the time being, the image will just be generated at a minimal 
magnification level, since there is a good chance we can create a fractal that 
has no numbers in it's set (or at least in the domain we pick).

# Future Improvements

Most of Racket's processing time will be doing unboxed computations, so 
the next obvious improvement would be to make it use flonum computations 
to perform boxed operations instead.

# Setup Instructions

To run this service you need Racket, Python, and Python Pip.

1. Git clone this repository
2. Make a Twitter account
3. Go to apps.twitter and create an App for this program
4. Generate the consumer/access tokens and fill out a keys.txt file with each key on a separate line
5. Set read/write permissions for your App
6. Run "make setup" to install the Python dependencies (might require sudo)
7. Run "make run" to start program

A keys.txt is required, and requires each token from the Twitter app in it, totalling four lines.
Tokens should appear in this order:

* Consumer key
* Consumer secret
* Access key
* Access secret

Windows users might run into problems that Racket cannot call the Python script 
due to binary location errors (ie: Racket can't call the Twitter script as a 
program because Windows doesn't know how to handle non-executable files). This is 
meant more as a server program than something you can run on Windows.
