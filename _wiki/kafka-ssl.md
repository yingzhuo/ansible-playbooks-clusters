```bash
#!/usr/bin/env bash

set -e

# 变量定义
HOSTNAME="10.211.55.3"
EXPIRE_DAYS="36500"
KEY_PASSWORD="123456"
STORE_PASSWORD="123456"
COMMON_NAME="kafka"

# 清空目录
rm -rf ./root/ ./server/ ./client/ ./trust

# 创建目录
mkdir -p ./{root,server,client,trust}

# 生成根证书私钥文件
openssl genrsa -out ./root/ca-key 2048
openssl req -new -out ./root/ca-csr -key ./root/ca-key -subj "/C=CN/ST=shanghai/L=shanghai/O=unknown/CN=$COMMON_NAME"
openssl x509 -req -in ./root/ca-csr -out ./root/ca-cert -signkey ./root/ca-key -CAcreateserial -days "$EXPIRE_DAYS"

# Generate the server.keystore.jks file (that is, generate the keystore file on the server side)
keytool \
    -keystore ./server/server.keystore.jks \
    -deststoretype pkcs12 \
    -storepass "$STORE_PASSWORD" \
    -validity "$EXPIRE_DAYS" \
    -genkey \
    -keyalg RSA \
    -keysize 2048 \
    -keypass "$KEY_PASSWORD" \
    -dname "CN=$COMMON_NAME,OU=unknown,O=unknown,L=shanghai,S=shanghai,C=CN" \
    -alias "$HOSTNAME" \
    -ext SAN=DNS:"$HOSTNAME"

# export cert-file (csr) of server.keystore.jks
keytool \
    -keystore ./server/server.keystore.jks \
    -storepass "$STORE_PASSWORD" \
    -certreq \
    -alias "$HOSTNAME" \
    -keyalg rsa \
    -keysize 2048 \
    -file ./server/server.cert-file

# Generating CA Certificate
openssl x509 -req \
    -CA ./root/ca-cert \
    -CAkey ./root/ca-key \
    -in ./server/server.cert-file \
    -out ./server/server.cert-signed \
    -CAcreateserial \
    -days "$EXPIRE_DAYS" \
    -passin pass:"$KEY_PASSWORD"

# Create a Client Trust Certificate through CA Certificate
keytool \
    -keystore ./trust/client.truststore.jks \
    -storepass "$STORE_PASSWORD" \
    -import -file ./root/ca-cert \
    -keyalg rsa \
    -keysize 2048 \
    -alias CARoot \
    -noprompt

# Create a server-side trust certificate through CA certificate
keytool \
    -keystore ./trust/server.truststore.jks \
    -storepass "$STORE_PASSWORD" \
    -alias CARoot \
    -import \
    -file ./root/ca-cert \
    -noprompt

keytool \
    -keystore ./server/server.keystore.jks \
    -storepass "$STORE_PASSWORD" \
    -import \
    -alias CARoot \
    -file ./root/ca-cert \
    -noprompt

keytool \
    -keystore ./server/server.keystore.jks \
    -storepass "$STORE_PASSWORD" \
    -import \
    -alias "$HOSTNAME" \
    -file ./server/server.cert-signed \
    -noprompt
```
