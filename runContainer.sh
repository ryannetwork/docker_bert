#!/bin/bash
# Note: change the path after -v to an existing folder on your host. 
docker run -it --runtime=nvidia -v /mnt/DATA/projects/docker_bert/persistentfolder:/root/bert/persistentfolder  bert_base /bin/bash
