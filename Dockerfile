FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04

# Install some OS dependancies
RUN apt update && \
    apt install -y vim git wget software-properties-common build-essential unzip curl

# Download BERT pretrained models
RUN mkdir /root/pretrained && \
    cd /root/pretrained && \
    wget https://storage.googleapis.com/bert_models/2019_05_30/wwm_uncased_L-24_H-1024_A-16.zip && unzip wwm_uncased_L-24_H-1024_A-16.zip && \
    wget https://storage.googleapis.com/bert_models/2019_05_30/wwm_cased_L-24_H-1024_A-16.zip && unzip wwm_cased_L-24_H-1024_A-16.zip && \
    wget https://storage.googleapis.com/bert_models/2018_11_23/multi_cased_L-12_H-768_A-12.zip && unzip multi_cased_L-12_H-768_A-12.zip && \
    wget https://storage.googleapis.com/bert_models/2018_11_03/chinese_L-12_H-768_A-12.zip && unzip chinese_L-12_H-768_A-12.zip && \
    wget https://storage.googleapis.com/bert_models/2018_10_18/uncased_L-12_H-768_A-12.zip && unzip uncased_L-12_H-768_A-12.zip && \
    wget https://storage.googleapis.com/bert_models/2018_10_18/uncased_L-24_H-1024_A-16.zip && unzip uncased_L-24_H-1024_A-16.zip && \
    wget https://storage.googleapis.com/bert_models/2018_10_18/cased_L-12_H-768_A-12.zip && unzip cased_L-12_H-768_A-12.zip && \
    wget https://storage.googleapis.com/bert_models/2018_10_18/cased_L-24_H-1024_A-16.zip && unzip cased_L-24_H-1024_A-16.zip && \
    rm *.zip

# Prior image doesn't have python installed. Using python3.5 and pip as it comes with 16.04's packager.
RUN apt-get install -y python3.5 && \
    curl https://bootstrap.pypa.io/get-pip.py | python3.5

# Pull BERT's github project
RUN cd /root && git clone --recursive --quiet https://github.com/google-research/bert

# BERT uses this script to download a GLUE benchmark data for testing.
RUN cd /root && \
    wget https://gist.githubusercontent.com/W4ngatang/60c2bdb54d156a41194446737ce03e2e/raw/17b8dd0d724281ed7c3b2aeeda662b92809aadd5/download_glue_data.py && \
    python3.5 download_glue_data.py

# This runs the above GLUE test. Note that it will likely fail if GPU is less than 12GB. 
COPY test_glue.sh /root/bert

# Altered requirements.txt to support GPU.
COPY requirements.txt /root/bert/
RUN chmod +x /root/bert/test_glue.sh
RUN pip install -r /root/bert/requirements.txt

# Set working directory to a user created directory (Else will default to /opt)
WORKDIR /root/bert
