#!/bin/bash

CC_RUNTIME_LANGUAGE=golang
InfoCC_SRC_PATH=github.com/chaincode/info
RecordPACC_SRC_PATH=github.com/chaincode/recordPA
RecordPBCC_SRC_PATH=github.com/chaincode/recordPB


rm -rf ./hfc-key-store
cd ./MedNet


function startUp() {
	
echo "start MedRec net work"
./network.sh up
sleep 3
CONFIG_ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer
ORG1_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/org1.medrec.com/users/Admin@org1.medrec.com/msp
ORG1_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/org1.medrec.com/peers/peer0.org1.medrec.com/tls/ca.crt
ORG2_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/org2.medrec.com/users/Admin@org2.medrec.com/msp
ORG2_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/org2.medrec.com/peers/peer0.org2.medrec.com/tls/ca.crt
ORG3_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/org3.medrec.com/users/Admin@org3.medrec.com/msp
ORG3_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/org3.medrec.com/peers/peer0.org3.medrec.com/tls/ca.crt

ORDERER_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/ordererOrganizations/medrec.com/orderers/orderer.medrec.com/msp/tlscacerts/tlsca.medrec.com-cert.pem

set -x


echo "Installing smart contract information on peer0.org1.medrec.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer0.org1.medrec.com:7051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n information \
    -v 1.0 \
    -p "$InfoCC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Installing smart contract information on peer0.org2.medrec.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org2MSP \
  -e CORE_PEER_ADDRESS=peer0.org2.medrec.com:8051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG2_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG2_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n information \
    -v 1.0 \
    -p "$InfoCC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Installing smart contract information on peer0.org3.medrec.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org3MSP \
  -e CORE_PEER_ADDRESS=peer0.org3.medrec.com:9051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG3_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG3_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n information \
    -v 1.0 \
    -p "$InfoCC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"


echo "Instantiating smart contract infomation on commonchannel"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  cli \
  peer chaincode instantiate \
    -o orderer.medrec.com:7050 \
    -C commonchannel \
    -n information \
    -l "$CC_RUNTIME_LANGUAGE" \
    -v 1.0 \
    -c '{"Args":[]}' \
    -P "AND('Org1MSP.member','Org2MSP.member','Org3MSP.member')" \
    --tls \
    --cafile ${ORDERER_TLS_ROOTCERT_FILE} \
    --peerAddresses peer0.org1.medrec.com:7051 \
    --tlsRootCertFiles ${ORG1_TLS_ROOTCERT_FILE}

sleep 3

echo "Installing smart contract recordpa on peer0.org1.medrec.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer0.org1.medrec.com:7051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n recordpa \
    -v 1.0 \
    -p "$RecordPACC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Installing smart contract recordpa on peer0.org2.medrec.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org2MSP \
  -e CORE_PEER_ADDRESS=peer0.org2.medrec.com:8051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG2_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG2_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n recordpa \
    -v 1.0 \
    -p "$RecordPACC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Instantiating smart contract recordpa on channelpa"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  cli \
  peer chaincode instantiate \
    -o orderer.medrec.com:7050 \
    -C channelpa \
    -n recordpa \
    -l "$CC_RUNTIME_LANGUAGE" \
    -v 1.0 \
    -c '{"Args":[]}' \
    -P "AND('Org1MSP.member','Org2MSP.member')" \
    --tls \
    --cafile ${ORDERER_TLS_ROOTCERT_FILE} \
    --peerAddresses peer0.org1.medrec.com:7051 \
    --tlsRootCertFiles ${ORG1_TLS_ROOTCERT_FILE}


sleep 3

echo "Installing smart contract recordpb on peer0.org1.medrec.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer0.org1.medrec.com:7051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n recordpb \
    -v 1.0 \
    -p "$RecordPBCC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Installing smart contract recordpb on peer0.org3.medrec.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org3MSP \
  -e CORE_PEER_ADDRESS=peer0.org3.medrec.com:9051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG3_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG3_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n recordpb \
    -v 1.0 \
    -p "$RecordPBCC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Instantiating smart contract recordpb on channelpb"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  cli \
  peer chaincode instantiate \
    -o orderer.medrec.com:7050 \
    -C channelpb \
    -n recordpb \
    -l "$CC_RUNTIME_LANGUAGE" \
    -v 1.0 \
    -c '{"Args":[]}' \
    -P "AND('Org1MSP.member','Org3MSP.member')" \
    --tls \
    --cafile ${ORDERER_TLS_ROOTCERT_FILE} \
    --peerAddresses peer0.org1.medrec.com:7051 \
    --tlsRootCertFiles ${ORG1_TLS_ROOTCERT_FILE}

set +x

sleep 2

echo "******************************************************************************************"
echo "Everything is ok , Next we can start our Application based on our MedRec NetWork"
echo "******************************************************************************************"

}






function clearDown(){
	echo " ------------------------------start clean the network------------------------------------ "
	./network.sh down
	echo "******************************************************************************************"
	echo "###############################Network has been clean up#################################"
	echo "******************************************************************************************"
}


if [ "$1" = "-m" ]; then
  shift
fi
MODE=$1
shift
#Create the network using docker compose
if [ "${MODE}" == "up" ]; then
  startUp
elif [ "${MODE}" == "down" ]; then ## Clear the network
  clearDown
elif [ "${MODE}" == "restart" ]; then ## Restart the network
  startUp
  clearDown
else
  echo "conmmand is err ,please enter the correct command------"
  echo "usage:"
  echo "./start.sh up ---------start network and install chaincode-------------------"
  echo "./start.sh down ---------------------clean up the whole network,container,chaincode images----------------"
  echo "./start.sh restart -------------------------------------down and up----------------------------------------------------------"
  exit 1
fi

