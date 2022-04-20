#!/usr/bin/env bash

# 集群所有机器的IP地址
IPADDRESS_LIST=("10.211.55.3" "10.211.55.4" "10.211.55.5")

# 证书过期时间 (天)
EXPIRE_DAYS="36500"

# 私钥密码 (所有私钥使用同一密码)
KEY_PASSWORD="123456"

# JKS秘钥库密码 (所有秘钥库使用同一密码)
STORE_PASSWORD="123456"

# ----------------------------------------------------------------------------------------------------------------------

# 清空目录
rm -rf ./root ./server ./client

# 创建目录
mkdir -p ./{root,server,client}

# 生成根证书私钥文件
openssl genrsa -out ./root/ca-key 2048
openssl req -new -out ./root/ca-csr -key ./root/ca-key -subj "/C=CN/ST=shanghai/L=shanghai/O=unknown/CN=whatever"
openssl x509 -req -in ./root/ca-csr -out ./root/ca-cert -signkey ./root/ca-key -CAcreateserial -days "$EXPIRE_DAYS"

for i in "${!IPADDRESS_LIST[@]}"; do

  # IP地址
  ip="${IPADDRESS_LIST[$i]}"

  keytool \
    -keystore ./server/server.keystore.jks \
    -deststoretype pkcs12 \
    -storepass "$STORE_PASSWORD" \
    -validity "$EXPIRE_DAYS" \
    -genkey \
    -keyalg RSA \
    -keysize 2048 \
    -keypass "$KEY_PASSWORD" \
    -dname "CN=whatever,OU=unknown,O=unknown,L=shanghai,S=shanghai,C=CN" \
    -alias "$ip" \
    -ext SAN=DNS:"$ip"

  keytool \
    -keystore ./server/server.keystore.jks \
    -storepass "$STORE_PASSWORD" \
    -certreq \
    -alias "$ip" \
    -keyalg rsa \
    -keysize 2048 \
    -file ./server/"$ip-server.cert-file"

  openssl x509 -req \
    -CA ./root/ca-cert \
    -CAkey ./root/ca-key \
    -in ./server/"$ip-server.cert-file" \
    -out ./server/"$ip-server.cert-signed" \
    -CAcreateserial \
    -days "$EXPIRE_DAYS" \
    -passin pass:"$KEY_PASSWORD"

  if test "$i" -eq 0; then
    keytool \
      -keystore ./server/server.keystore.jks \
      -storepass "$STORE_PASSWORD" \
      -import \
      -alias CARoot \
      -file ./root/ca-cert \
      -noprompt
  fi

  keytool \
    -keystore ./server/server.keystore.jks \
    -storepass "$STORE_PASSWORD" \
    -import \
    -alias "$ip" \
    -file ./server/"$ip-server.cert-signed" \
    -noprompt

  rm -rf ./server/"$ip-server.cert-file"

done

keytool \
  -keystore ./client/client.truststore.jks \
  -storepass "$STORE_PASSWORD" \
  -alias CARoot \
  -import -file ./root/ca-cert \
  -noprompt

keytool \
  -keystore ./server/server.truststore.jks \
  -storepass "$STORE_PASSWORD" \
  -alias CARoot \
  -import -file ./root/ca-cert \
  -noprompt

rm -rf ./.srl