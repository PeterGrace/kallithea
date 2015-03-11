# kallithea
Docker image that contains kallithea, a DVCS server written in Python.  The default login in this container is `admin` and password is `K4ll1th34`, obviously please change it if you intend to use this for more than a quick evaluation.

This Docker image exposes port 80 and has two volume export points such that one can make a permanent installation 
with ephemeral docker containers.

Example to run:
> `docker run -dp 3080:80 petergrace/kallithea`

This will start a container such that you can try out the software.  It will host the kallithea instance on your 
docker host's port 3080.  This repo also includes a fig.yml file if you'd like to use  `fig` or `docker-compose` functionality.



**If you would like to run this in a more permanent fashion, please do the following steps:**

- create two directories on your docker host, e.g. `/opt/kal/data` and `/opt/kal/repos`
- set owners of those two folders to 33:33 (the www-data user id and group inside of the docker container)
- Download the kallithea.db sqlite file from this repo's docker/ subdirectory.
- Place the kallithea.db file in the data folder
- execute the docker container: `docker run -dp 3080:80 -v /opt/kal/data:/opt/kallithea/data -v /opt/kal/repos:/opt/kallithea/repos petergrace/kallithea`
