install:
	# Commands to install requirements
	pip install --upgrade pip &&\
	pip install -r requirements.txt

lint:
	# Rate the neatness of our code
	pylint -d=R,C addtwo.py

format:
	# Reorganise the spacing of the code for neatness
	black *.py

test:
	# Run tests to make sure code works
	python3 -m pytest -vv --cov=addtwo test_addtwo.py

