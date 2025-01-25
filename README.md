# ikev2-ipsec
A repo holding snippets necessary for running your own instance of a IKEv2 VPN

# How to use

Prerquisites:
- Docker
- PKI: (e.g. `strongswan-pki` apt package)
- Clone this repo

## Set reqired environment variables

```shell
export SERVER=<your server ip or domain>
```

## Generate necessary certificates

```shell
# Generate CA key and certificate
pki --gen --type rsa --size 4096 --outform pem > ./ipsec.d/private/ca-key.pem
pki --self --ca --lifetime 3650 --in ./ipsec.d/private/ca-key.pem --type rsa --dn "CN=VPN root CA" --outform pem > ./ipsec.d/cacerts/ca-cert.pem

# Generate server key and certificate
pki --gen --type rsa --size 4096 --outform pem > ./ipsec.d/private/server-key.pem
pki --pub --in ./ipsec.d/private/server-key.pem --type rsa  | pki --issue --lifetime 1825 --cacert ./ipsec.d/cacerts/ca-cert.pem --cakey ./ipsec.d/private/ca-key.pem --dn "CN=$SERVER" --san $SERVER --flag serverAuth --flag ikeIntermediate --outform pem  > ./ipsec.d/certs/server-cert.pem
```

_Note:_ The `ca-cert.pem` should be installed on the client machines when the VPN is set up.

## Generate ipsec.conf

```shell
envsubst < ipsec.conf.template > ipsec.conf
```

## Fill up ipsec.secrets file

The file holds the credentials for the VPN.

## Build and run the image

```shell
docker build -t ikev2-ipsec .
docker run --privileged -d --name ikev2-ipsec -p 500:500/udp -p 4500:4500/udp ikev2-ipsec
```
