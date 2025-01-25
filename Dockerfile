FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    strongswan \
    strongswan-pki \
    libcharon-extra-plugins \
    libcharon-extauth-plugins \
    libstrongswan-extra-plugins \
    iptables \
    && rm -rf /var/lib/apt/lists/*

# Create directory for VPN certificates
RUN mkdir -p /etc/ipsec.d/private \
    && mkdir -p /etc/ipsec.d/certs \
    && mkdir -p /etc/ipsec.d/cacerts

COPY ipsec.conf /etc/ipsec.conf
COPY ipsec.secrets /etc/ipsec.secrets
COPY start-vpn.sh /start-vpn.sh
COPY ipsec.d /etc/ipsec.d

RUN chmod +x /start-vpn.sh

EXPOSE 500/udp 4500/udp

CMD ["/start-vpn.sh"]
