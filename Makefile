setup:
	echo "Starting setup..."
	pip install -r requirements.txt
	chmod +x upload.py
	echo "Fill out a keys.txt with your consumer/access tokens/secrets"
run:
	racket main.rkt
test:
	racket test.rkt
setup_env:
	virtualenv dev
env:
	source dev/bin/activate
exit:
	deactivate
