#!/usr/bin/env bash
# 生成JavaKeyStore用于Java应用程序的双向SSL验证等
# 使用前注意修改变量
# 作者: 应卓

set -e

# 集群所有机器的IP地址
IPADDRESS_LIST=("10.211.55.3" "10.211.55.4" "10.211.55.5")

# 证书过期时间 (天)
EXPIRE_DAYS="36500"

# 私钥密码 (所有私钥使用同一密码)
KEY_PASSWORD="123456"

# JKS秘钥库密码 (所有秘钥库使用同一密码)
STORE_PASSWORD="123456"

# 是否删除中间文件 (yes | no)
REMOVE_MIDDLE_FILES="no"

# 是否打包最后结果 (yes | no)
ZIP_ALL="yes"

# ----------------------------------------------------------------------------------------------------------------------

# 清空目录及压缩文件
rm -rf ./root ./server ./client ./generated-jks ./generated-jks.tgz || true

# 创建目录
mkdir -p ./{root,server,client}

# 生成根证书与根证书秘钥以及签名请求文件
openssl genrsa -out ./root/ca.key 2048
openssl req -new -out ./root/ca.csr -key ./root/ca.key -subj "/C=CN/ST=shanghai/L=shanghai/O=unknown/CN=whatever"
openssl x509 -req -in ./root/ca.csr -out ./root/ca.cert -signkey ./root/ca.key -CAcreateserial -days "$EXPIRE_DAYS"

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
    -file ./server/"$ip-server.csr"

  openssl x509 -req \
    -CA ./root/ca.cert \
    -CAkey ./root/ca.key \
    -in ./server/"$ip-server.csr" \
    -out ./server/"$ip-server.cert" \
    -CAcreateserial \
    -days "$EXPIRE_DAYS" \
    -passin pass:"$KEY_PASSWORD"

  if test "$i" -eq 0; then
    keytool \
      -keystore ./server/server.keystore.jks \
      -storepass "$STORE_PASSWORD" \
      -import \
      -alias CARoot \
      -file ./root/ca.cert \
      -noprompt
  fi

  keytool \
    -keystore ./server/server.keystore.jks \
    -storepass "$STORE_PASSWORD" \
    -import \
    -alias "$ip" \
    -file ./server/"$ip-server.cert" \
    -noprompt

done

keytool \
  -keystore ./client/client.truststore.jks \
  -storepass "$STORE_PASSWORD" \
  -alias CARoot \
  -import -file ./root/ca.cert \
  -noprompt

keytool \
  -keystore ./server/server.truststore.jks \
  -storepass "$STORE_PASSWORD" \
  -alias CARoot \
  -import -file ./root/ca.cert \
  -noprompt

if [ "$REMOVE_MIDDLE_FILES" == "yes" ]; then
  rm -rf ./root/ca.csr
  rm -rf ./server/*-server.csr
  rm -rf ./server/*-server.cert
fi

rm -rf ./.srl

if [ "$ZIP_ALL" == "yes" ]; then
  mkdir -p ./generated-jks
  cp -R ./root ./generated-jks
  cp -R ./server ./generated-jks
  cp -R ./client ./generated-jks

  tar -czf ./generated-jks.tgz ./generated-jks
  rm -rf ./root ./server ./client ./generated-jks
fi
