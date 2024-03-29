# Randombrot Project


# Archival Notice

This software is going into archived mode as of February 3rd, 2023. Recent changes
to Twitter's API rules deem it impossible to run this bot as a freemium service, 
therefore, I am putting it into archived mode as it has not had updates made in years.

The project is portable to other platforms that support basic API calls that permit
image uploading, but I will not be providing this support. No more security updates will
be made to support the Twitter Python libraries used.

---

This is a Twitter bot that generates randomly created Julia set fractals. 
The program will create an image, upload it to a Twitter account, 
and then sleep for an hour, creating at least 24 fractals a day (more or 
less depending on the complexity of the given random function and it's variables, 
since this will be running on a Raspberry Pi which has a low GHz ARM processor).

# Toolkit

The Julia program is written in Racket. The Twitter upload is written in 
Python. Since Racket doesn't have a standard OAuth 1.0 library, it's easier to 
use Python to do a very minimal action and call it from within Racket. 
Until Racket gets an OAuth 1.0 default implementation (which it probably won't), 
the upload will just be done with Python.

# Mandelbrot Set Definition

A Mandelbrot set is a set of complex numbers _c_ for which the function 
f(z) = z^2 + c does not diverge. To make things more interesting, we are
going to create Julia set fractals, which Mandelbrot is a member of. Julia fractals
are any given function with the same divergence rules. 

For the time being, the image will just be generated at a minimal 
magnification level, since there is a good chance we can create a fractal that 
has no numbers in it's set (or at least in the domain we pick).

There is a pre-defined list of functions that the program will choose from.
In recent versions, there is now a mechanic where the program will have a chance of
composing functions from the pre-defined list of functions, creating sets that may
or may not even have any numbers in them at all.

# Goals

* Improve performance by doing flonum operations throughout the computation loop
* Buy a better Raspberry Pi for a Racket performance increase
* Implement some kind of learning to improve randomization process
* Process Fourier Transforms of each image and upload it alongside
* Render 3D maps (if possible by the hardware) of Julia sets

# Setup Instructions

To run this service you need Racket, Python, and Python Pip.

1. Git clone this repository
2. Make a Twitter account
3. Go to apps.twitter and create an App for this program
4. Generate the consumer/access tokens and fill out a keys.txt file with each key on a separate line
5. Set read/write permissions for your App
6. Run "make setup" to install the Python dependencies (might require sudo)
7. Run "make run" to start program

A _keys.txt_ is required, and requires each token from the Twitter app in it, totalling four lines.
Tokens should appear in this order:

* Consumer key
* Consumer secret
* Access key
* Access secret

Windows users might run into problems that Racket cannot call the Python script 
due to binary location errors (ie: Racket can't call the Twitter script as a 
program because Windows doesn't know how to handle non-executable files). This is 
meant more as a server program than something you can run on Windows.

# Requirements

The requirements for this is roughly as follows:

* Python 2.7.9
* Racket 6.1
* Tweepy 3.5
* Virtualenv (if you don't have sudo access)

Additional Python dependencies are listed in _requirements.txt_.
