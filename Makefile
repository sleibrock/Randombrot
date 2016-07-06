setup:
	echo "Starting setup..."
	pip install -r requirements.txt
	chmod +x upload.py
	echo "Fill out a keys.txt with your consumer/access tokens/secrets"
run:
	racket main.rkt
test:
	racket test.rkt
testobj:
	racket utils/3d-fractal.rkt
setup_env:
	virtualenv dev
render3d:
	blender -b -o output.png -P bscript.py
env:
	source dev/bin/activate
exit:
	deactivate
