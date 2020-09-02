#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s/\${CHANNEL}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccptemplate.json 
}


ORG=1
CHANNEL=commonchannel
P0PORT=7051
CAPORT=7054
PEERPEM=crypto-config/peerOrganizations/org1.medrec.com/tlsca/tlsca.org1.medrec.com-cert.pem
CAPEM=crypto-config/peerOrganizations/org1.medrec.com/ca/ca.org1.medrec.com-cert.pem


echo "$(json_ccp $ORG $P0PORT $CAPORT $CHANNEL $PEERPEM $CAPEM)" > connection-org1.json

ORG=2
CHANNEL=commonchannel
P0PORT=8051
CAPORT=8054
PEERPEM=crypto-config/peerOrganizations/org2.medrec.com/tlsca/tlsca.org2.medrec.com-cert.pem
CAPEM=crypto-config/peerOrganizations/org2.medrec.com/ca/ca.org2.medrec.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $CHANNEL $PEERPEM $CAPEM)" > connection-org2.json


ORG=3
CHANNEL=commonchannel
P0PORT=9051
CAPORT=9054
PEERPEM=crypto-config/peerOrganizations/org3.medrec.com/tlsca/tlsca.org3.medrec.com-cert.pem
CAPEM=crypto-config/peerOrganizations/org3.medrec.com/ca/ca.org3.medrec.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $CHANNEL $PEERPEM $CAPEM)" > connection-org3.json

