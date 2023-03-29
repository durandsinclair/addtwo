
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
Before we begin, we need to set up a virtual environment just like we do with every Python project. Python does this so that the settings of this project doesn't mess up the settings on another part of our computer. (Note: I'm going to call my virtual environment `.venv`. This will mean that it won't upload itself to GitHub, so anyone who uses this project will have to create their own environment before running it. But that's good. An environment on AWS might need to be slightly different than an environment on a PC for example. Let each device using this code write their own Python environment before starting, if necessary.)  

#### [Mac](#tab/Mac/)
```bash
# Create an environment for my local machine
python3 -m venv .venv

# Activate the environment
source .venv/bin/activate
```

#### [PC](#tab/PC/)
```bash
# Create an environment for my local machine
# Open a Terminal window in VS Code of the type Git Bash rather than Powershell or Command Prompt
python -m venv .venv

# Activate the environment
source .venv/Scripts/activate
```

* * * 

### Set up Requirements file
Rather than typing things like `pip install numpy` and then `pip install pandas` until our fingers bleed, let's just list all the Python libraries we'll need in a file called `requirements.txt` and get the computer to install all of them. In this example requirements file, I'm only installing three libraries, but they're all good basic libraries to include. 

```requirements.txt
pylint
pytest
pytest-cov
```
The libraries in the list do the following.  
`pylint`  - A library to lint our code. Linting checks the formatting of the Python and makes sure it's neat. Is this necessary? Well ... no. But you try reading messy code two years later. So let's include it.  

`pytest` - This library lets us write tests to see if the result of a function is what we'd expect. These tests can be run automatically whenever we make a change, so that we can be sure that the code still works as we want it to.  

`pytest-cov` - This library looks at the tests we've written and tells us how well they test our code. That is, test coverage.  

### Set up Makefile
The hard part about Python is that you can't code with it until you've set up a Python project. And you need to know a whole different language (bash) to do that. A Makefile makes this easier by letting you give a label to a few lines of bash script, and then typing the label to run them again later. For instance, I can write some bash code to install the libraries in my requirements file, give it a label called `install`, and then just type `make install` to run all those lines of bash whenever I want.  

The specific Makefile scripts we're including are:  
`install` - to install the Python libraries listed in `requirements.txt`  
`lint` - to check how neat our Python code is, which will prompt us to tidy it up if necessary
`format` - to automatically make sure we've got the right amount of blank lines between functions, and no unnecessary extra lines at the end.  
`test` - to test our codebase works as intended by running the tests in our test suite.  

A full tutorial on Makefiles can be found [here](https://makefiletutorial.com/).

```Makefile
install:
	# Install libraries 
	pip install --upgrade pip &&\
	pip install -r requirements.txt
lint:
	# Lint our code, to judge its neatness
# $(info No linting set up yet.)
	pylint -d=R,C *.py

format:
	# Automatically fix up any formatting issues
	black *.py
	
test:
	# Run all tests, verbosely so there's more information
# $(info No tests set up yet.)
	pytest -v
```

In the script above, I've added a line in `test` that has been commented out. If uncommented, it would return a line of text (eg "No tests set up yet") instead of running a block of code. Just included it to show how it's done.


### Set up Python Test File
If we want to make sure our code will always work, we have to test it every time we change it. That's why best practice is to write tests for each Python function in our codebase, and to write the tests before we write the code. 
```python

from addtwo import addtwo    # Get the function called addtwo from the file called addtwo

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
Now that everything is written, we can execute all the components of our program to make sure it works. But because we've written a Makefile, this is simply a case of typing some `make` commands in the terminal window. 
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
This pushes our code to Github, which is a sort of hard drive in the cloud for code. 

### Set up Continuous Integration with Github Actions
Github has a tool called Github Actions which allows you to write a workflow (a YAML script) that runs automatically every time a particular event happens, like code being checked in or out of a codebase. In our case, every time we check code in, we'll run unit tests, lint the Python code for neatness, and fix up the formatting using the make commands we prepared earlier.

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

From here, we can go onto more complex tasks, like testing our code against multiple versions of Python, or pushing the project from Github onto different cloud providers like AWS or Azure. We could also put our code into a Docker container and send it to a register, publishing it for the world. Explore more possibilities in the [Github Actions documentation](https://github.com/durandsinclair/addtwo/actions/new). 

