setup:
	echo "Starting setup..."
	pip install -r requirements.txt
	chmod +x upload.py
	touch keys.txt
	echo "Fill out keys.txt with your consumer/access tokens/secrets"
run:
	racket prog.rkt
setup_env:
	virtualenv dev
env:
	source dev/bin/activate
exit:
	deactivate
