# Using docker to run snakemake pipeline


## Install docker

MacOS:
Install Docker desktop here: https://docs.docker.com/desktop/mac/install/ 

Windows:
If you do not have the WSL enabled or installed, following the instructions here:
https://docs.microsoft.com/en-us/windows/wsl/install   

Then download and install Docker desktop for windows:
https://docs.docker.com/desktop/windows/install/  

Open the docker application to confirm installation.

## Initialize container

The docker container also contains Rstudio to enable exploration of the data in rstudio. To start the docker image provide a password string, which will be used for logging into rstudio if desired.

Get the image
```bash
docker pull rnabioco/mztintrons
```

Start a container

```bash
docker run \
  -e PASSWORD=rna \ # password used to login into rstudio if desired
  -p 8787:8787 \ # port that rstudio will be active on, navigate browser to http://localhost:8787/ to login
  -v /path/to/mztintrons:/home/rstudio/ \ # path to local directory with pipeline and data 
  -it \ 
  rnabioco/mzt-introns
``` 

Once you have a container running, you can get access a bash shell to run snakemake in two ways:  

1) login to rstudio, and use the terminal in the IDE (e.g. navigate to http://localhost:8787/, then login with username rstudio, password rna)  

2) start a terminal in the docker container.  

```bash
docker run -it -v /path/to/mztintrons:/home/rstudio/ rnabioco/mzt-introns bash
```

## Test snakemake

```bash
snakemake -npr --configfile config-test.yaml
```

# Additional resources

 If you’ve never used docker here are some useful tutorials on using docker:
 
 https://bioconductor.org/help/docker/#quickstart  
 https://jsta.github.io/r-docker-tutorial/  
 https://replikation.github.io/bioinformatics_side/docker/docker/#important-commands  
