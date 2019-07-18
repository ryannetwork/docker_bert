
export BERT_BASE_DIR=/root/pretrained/wwm_uncased_L-24_H-1024_A-16
export GLUE_DIR=/root/glue_data

echo 'Who was Jim Henson ? ||| Jim Henson was a puppeteer' > /tmp/input.txt

python3.5 extract_features.py \
  --input_file=/tmp/input.txt \
  --output_file=./persistentfolder/output.json \
  --vocab_file=$BERT_BASE_DIR/vocab.txt \
  --bert_config_file=$BERT_BASE_DIR/bert_config.json \
  --init_checkpoint=$BERT_BASE_DIR/bert_model.ckpt \
  --layers=-1,-2,-3,-4 \
  --max_seq_length=128 \
  --batch_size=8
