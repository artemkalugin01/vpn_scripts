#!/bin/bash
client_number=$1
number_of_clients=$(tail -n +2 /etc/openvpn/server/easy-rsa/pki/index.txt | grep -c "^V")
if [[ "$number_of_clients" = 0 ]]; then
    echo
    echo "There are no existing clients!"
    exit
fi
echo
echo "Select the client to revoke:"
tail -n +2 /etc/openvpn/server/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | nl -s ') '
client=$(tail -n +2 /etc/openvpn/server/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | sed -n "$client_number"p)
echo
echo $client
if [[ "$revoke" =~ ^[yY]$ ]]; then
    cd /etc/openvpn/server/easy-rsa/
    ./easyrsa --batch revoke "$client"
    EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
    rm -f /etc/openvpn/server/crl.pem
    cp /etc/openvpn/server/easy-rsa/pki/crl.pem /etc/openvpn/server/crl.pem
    chown nobody:"$group_name" /etc/openvpn/server/crl.pem
    echo
    echo "$client revoked!"
else
    echo
    echo "$client revocation aborted!"
fi
exit