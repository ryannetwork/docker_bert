FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04

RUN apt update && \
    apt install -y vim git wget software-properties-common build-essential unzip curl


# DOwnload BERT stuff
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


#Install dependancies
    #add-apt-repository ppa:deadsnakes/ppa && \
    #apt-get update && \
RUN apt-get install -y python3.5 && \
    #apt-get install -y python3.6-distutils && \
    curl https://bootstrap.pypa.io/get-pip.py | python3.5 && \
    pip install tqdm

RUN cd /root && git clone --recursive --quiet https://github.com/google-research/bert



RUN cd /root && \
    wget https://gist.githubusercontent.com/W4ngatang/60c2bdb54d156a41194446737ce03e2e/raw/17b8dd0d724281ed7c3b2aeeda662b92809aadd5/download_glue_data.py && \
    python3.5 download_glue_data.py

COPY test_glue.sh /root/bert
COPY requirements.txt /root/bert/
RUN chmod +x /root/bert/test_glue.sh
RUN pip install -r /root/bert/requirements.txt
COPY test_featureextract.sh /root/bert

WORKDIR /root/bert
