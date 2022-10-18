
# Basic Python Project Workflow
(Using test driven development, Makefiles, and continuous integration with Github Actions.)

## Project Aim
This project tries to use best practice data engineering to build a simple Python script. The script itself is just a simple function that adds two numbers together. But the rest of the project uses the techniques of the world's best software engineering practices, including: 
* MAKEFILES - Where we replace fiddly Linux commands with easy-to-remember `make` commands
* TEST DRIVEN DEVELOPMENT - Where we have tests for each of our Python functions (well, our one Python function).
* CONTINUOUS INTEGRATION  - So that when we make any changes to the code base in future, Github will automatically run all the tests, not only to make sure the functions work as expected, but the code is run through a linter to make sure it's easy to read and formatted properly.  


## How We'll Do It

First, we'll need to get the project working on a local machine.
We'll need four files + a Python environment.
* `addtwo.py` - which contains the actual Python code to add numbers together. 
* `test_addtwo.py` - which contains automated tests to make sure the Python code works. 
* `Makefile` - which allows us to replace complicated Linux commands with simple ones, based on our own definitions. For instance, I can type "make install" instead of both "pip install --upgrade pip" and "pip install -r requirements.txt". This makes it easier to install, lint and test our Python code, particularly when we want to run our installation on another computer.  
* `requirements.txt` - which lists the Python libraries that need to be installed for the project to run.  

Once it works on a local machine, we can upload it to Github, and use Github Actions to set up a CI/CD pipeline, which means that any changes to the code will trigger all the tests.  

## Part 1: Local Environment Workflow. 

### Set up Environment  
Before we begin, we need to set up a virtual environment just like we do with every Python project. Python does this so that the settings of this project doesn't mess up the settings on another part of our computer. (Note: I'm going to call my virtual environment `.venv`. This will mean that it won't upload itself to GitHub, so anyone who uses this project will have to create their own environment before running it. But that's good. Let each device using this code write their own Python environment, if necessary.)  

```bash
# Create an environment for my local machine
python3 -m venv .venv

# Activate the environment
source .venv/bin/activate
```

### Set up Requirements file
Let's list all the Python libraries we'll need in a file called `requirements.txt`. Usually you'll find libraries like `numpy` or `pandas` or `matplotlib`. But in this case, let's have the bare minimum. We'll install these libraries with code later on, but having them on a list makes it easier to do in any environment.

```requirements.txt
pylint
pytest
pytest-cov
```
The libraries in the list do the following.  
`pylint`  - A library to lint our code. Linting checks the formatting of the Python and makes sure it's neat. Is this necessary? Well ... no. But you try reading messy code two years later. So let's include it.  

`pytest` - This library lets us write tests to see if the result of a function is what we'd expect. These tests can be run automatically whenever we make a change, so that we can be sure that the code still works as we want it to.  

### Set up Makefile
The hard part about Python software is that you need to know a whole different language (bash) to set up the Python project. A Makefile allows you to write little bash scripts which you can call later. For instance, I can write a bash script called `install`, and then just type `make install` to run all those lines of bash whenever I want later. And beneath it, I can write a bash script called `lint` and type `make lint` to call that later. 

The specific make scripts we're making include:  
`install` - to install the Python libraries listed in `requirements.txt`  
`lint` - to check how neat our Python code is, to prompt us to tidy it up  
`format` - to automatically make sure we've got the right amount of blank lines between functions, and no unnecessary extra lines at the end.  
`test` - to test our codebase works as intended by running the tests in our test suite.  

A full tutorial on Makefiles can be found [here](https://makefiletutorial.com/).

```Makefile
install:
	# Install libraries 
	pip install --upgrade pip &&\
	pip install -r requirements.txt
lint:
# $(info No linting set up yet.)
	pylint -d=R,C addtwo.py

format:
	black *.py
test:
# $(info No tests set up yet.)
	pytest -vv --cov=addtwo test_addtwo.py
```

In the script above, I've added two lines that have been commented out. If uncommented, they'd return a line of text (eg "No linting set up yet") instead of running a block of code.


### Set up Python Test File
If we want to make sure our code will always work, we have to test it every time we change it. That's why best practice is to write tests for each Python function in our codebase, and to write the tests before we write the code. 
```python
from addtwo import addtwo

def test_addtwo():
	""" Tests if the addtwo function works """
	assert addtwo(1,1) == 2
```

### Set up Python File
Finally, we can start writing our actual Python code, knowing that our environment has been set up and our tests are ready to go.
In this case, we're writing a function that adds two numbers together and returns the sum. 
```python
def addtwo(first second)
	""" Adds two numbers and returns the sum """
	return first + second
```

### Run functions to make sure it all works
Now that everything is written, we can execute all the components of our program to make sure it works. But because we've written a Makefile, this is simply a case of typing some `make` commands.
```bash
make install
make lint
make format
make test
```
Boom! It works! Now to move it to the cloud.

## Part 2: Cloud Environment Workflow
Now that we have a project, we need to set up a continuous integration platform. "Continuous Integration" means that whenever we push new code to our main branch, it runs automated tests. It also lints and formats the code. That way, we don't need a manager to sit there checking the work of the programmers - let a computer do it and save time, money, and give programmers more autonomy.

### Set up a Github Repo
Once it's created on github, write the following commands in Terminal
```bash
git remote add origin <address of repo>
git branch -M main
git push -u origin main
```

### Set up Continuous Integration with Github Actions
Github Actions allows you to write a workflow (a YAML script) that you can get to run automatically every time a particular event happens, like code being checked in or out of a codebase. In our case, every time we check code in, we'll run unit tests, lint the Python code for neatness, and fix up the formatting using the make commands we prepared earlier.

More information about how Github Actions works can be found [here:](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)

Here's the YAMLscript, with each line commented
```yaml
# Workflow name
name: Azure Python 3.5
on: [push] # Workflow runs when we push code to the repo
jobs: # A workflow is made up of jobs
	build:  # This job is called "build"
		runs-on: ubuntu-latest  # Running on Mac or Windows is more expensive than running ubuntu
		steps: # A job is made up of steps, which is made of actions
		# Let's call a community action called checkout@v2
		- uses: actions/checkout@v2
		- name: Set up Python 3.5.10
			uses: actions/setup-python@v1
			with:
				python-version: 3.5.10	
					
		# Call our three Makefile scripts, one step at a time.
		- name: Install
			run: |
				make install
		- name: Lint 
			run: |
				make lint
		- name: Test
			run: |	
				make test
```

## Conclusion

This project has demonstrated how to set up a basic continuous integration system for a Python project. From here, any time we check a new Python script into our codebase, it will test all Python functions to make sure they still work. 

From here, we can go onto more complex tasks, like testing our code against multiple versions of Python, or pushing the project from Github onto a cloud provider like AWS, or turning our code into a Docker container and putting it on a register. Explore more possibilities in the [Github Actions documentation](https://github.com/durandsinclair/addtwo/actions/new). 

