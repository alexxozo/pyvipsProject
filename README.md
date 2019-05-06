# pyvipsProject
A simple python Flask server that converts some images using pyvips, all wrapped up in a Docker container.

## How to use
Install Docker on your system and just run these commands to build and run the project.
```
docker build -t <IMAGE-NAME> .
docker run -p 8888:5000 --name <CONTAINER-NAME> <IMAGE-NAME>
```
And change <IMAGE-NAME> and <CONTAINER-NAME> to whatever you want.
You can see an example of how I run it locally in 'runfile'.