install:
	pip install --upgrade pip &&\
	pip install -r requirements.txt
lint:
	pylint -d=R,C addtwo.py
format:
	black *.py
test:
	python3 -m pytest -vv --cov=addtwo test_addtwo.py

