#!/bin/bash


echo  "**************************************************************************************************"
echo "**********************************Build network (MEDREC)*******************************************"
echo  "**************************************************************************************************"


CHANNEL_NAME_COMMON="$1"
DELAY="$2"
LANGUAGE="$3"
TIMEOUT="$4"
VERBOSE="$5"
NO_CHAINCODE="$6"
CHANNEL_NAME_PA="$7"
CHANNEL_NAME_PB="$8"
: ${CHANNEL_NAME_COMMON:="commonchannel"}
: ${DELAY:="3"}
: ${LANGUAGE:="golang"}
: ${TIMEOUT:="10"}
: ${VERBOSE:="false"}
: ${NO_CHAINCODE:="false"}
: ${CHANNEL_NAME_PA:="channelpa"}
: ${CHANNEL_NAME_PB:="channelpb"}




COUNTER=1
MAX_RETRY=10

# import utils
#. scripts/utils.sh


#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/medrec.com/orderers/orderer.medrec.com/msp/tlscacerts/tlsca.medrec.com-cert.pem
PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.medrec.com/peers/peer0.org1.medrec.com/tls/ca.crt
PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.medrec.com/peers/peer0.org2.medrec.com/tls/ca.crt
PEER0_ORG3_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.medrec.com/peers/peer0.org3.medrec.com/tls/ca.crt

# verify the result of the end-to-end test
verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute End-2-End Scenario ==========="
    echo
    exit 1
  fi
}

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  CORE_PEER_LOCALMSPID="OrdererMSP"
  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/medrec.com/orderers/orderer.medrec.com/msp/tlscacerts/tlsca.medrec.com-cert.pem
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/medrec.com/users/Admin@medrec.com/msp
}

#设置环境变量（不同组织的）    在创建应用程序通道时会使用到

setGlobals() {
  PEER=$1
  ORG=$2
  if [ $ORG -eq 1 ]; then
    CORE_PEER_LOCALMSPID="Org1MSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.medrec.com/users/Admin@org1.medrec.com/msp
    if [ $PEER -eq 0 ]; then
      CORE_PEER_ADDRESS=peer0.org1.medrec.com:7051
    else
      echo "unknown peer "
    fi
  elif [ $ORG -eq 2 ]; then
    CORE_PEER_LOCALMSPID="Org2MSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.medrec.com/users/Admin@org2.medrec.com/msp
    if [ $PEER -eq 0 ]; then
      CORE_PEER_ADDRESS=peer0.org2.medrec.com:8051
    else
      echo "unknown peer "
    fi

  elif [ $ORG -eq 3 ]; then
    CORE_PEER_LOCALMSPID="Org3MSP"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.medrec.com/users/Admin@org3.medrec.com/msp
    if [ $PEER -eq 0 ]; then
      CORE_PEER_ADDRESS=peer0.org3.medrec.com:9051
    else
      echo "unknown peer "
    fi
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}





## Sometimes Join takes time hence RETRY at least 5 times
joinChannelWithRetry_common() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG

  set -x
  peer channel join -b commonchannel.block >&log.txt
  res=$?
  set +x
  cat log.txt
  if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
    COUNTER=$(expr $COUNTER + 1)
    echo "peer${PEER}.org${ORG} failed to join the channel, Retry after $DELAY seconds"
    sleep 3
    joinChannelWithRetry_common $PEER $ORG
  else
    COUNTER=1
  fi
  verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.org${ORG} has failed to join channel commonchannel"
}


joinChannelWithRetry_PA() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG

  set -x
  peer channel join -b $CHANNEL_NAME_PA.block >&log.txt
  res=$?
  set +x
  cat log.txt
  if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
    COUNTER=$(expr $COUNTER + 1)
    echo "peer${PEER}.org${ORG} failed to join the channel, Retry after $DELAY seconds"
    sleep 3
    joinChannelWithRetry_PA $PEER $ORG
  else
    COUNTER=1
  fi
  verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.org${ORG} has failed to join channel '$CHANNEL_NAME_PA' "
}



joinChannelWithRetry_PB() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG

  set -x
  peer channel join -b $CHANNEL_NAME_PB.block >&log.txt
  res=$?
  set +x
  cat log.txt
  if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
    COUNTER=$(expr $COUNTER + 1)
    echo "peer${PEER}.org${ORG} failed to join the channel, Retry after $DELAY seconds"
    sleep 3
    joinChannelWithRetry_PB $PEER $ORG
  else
    COUNTER=1
  fi
  verifyResult $res "After $MAX_RETRY attempts, peer${PEER}.org${ORG} has failed to join channel '$CHANNEL_NAME_PB' "
}



updateAnchorPeers_common() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG
  peer channel update -o orderer.medrec.com:7050 -c commonchannel -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchorsCommon.tx --tls true --cafile $ORDERER_CA >&log.txt
  cat log.txt
  verifyResult $res "Anchor peer update failed"
  echo "===================== Anchor peers updated for org '$CORE_PEER_LOCALMSPID' on channel commonchannel ===================== "
  sleep $DELAY
  echo
}

updateAnchorPeers_PA() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG
  peer channel update -o orderer.medrec.com:7050 -c $CHANNEL_NAME_PA -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchorsPA.tx --tls true --cafile $ORDERER_CA >&log.txt
  cat log.txt
  verifyResult $res "Anchor peer update failed"
  echo "===================== Anchor peers updated for org '$CORE_PEER_LOCALMSPID' on channel '$CHANNEL_NAME_PA' ===================== "
  sleep $DELAY
  echo
}


updateAnchorPeers_PB() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG
  peer channel update -o orderer.medrec.com:7050 -c $CHANNEL_NAME_PB -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchorsPB.tx --tls true --cafile $ORDERER_CA >&log.txt
  cat log.txt
  verifyResult $res "Anchor peer update failed"
  echo "===================== Anchor peers updated for org '$CORE_PEER_LOCALMSPID' on channel '$CHANNEL_NAME_PB' ===================== "
  sleep $DELAY
  echo
}







echo "Channel name : commonchannel"
createChannel_common() {
  #设置ORG1的环境变量
	setGlobals 0 1
                #启用TLS(我们的MEDREC项目是启用了TLS的)
	peer channel create -o orderer.medrec.com:7050 -c commonchannel -f ./channel-artifacts/commonchannel.tx --tls true --cafile $ORDERER_CA >&log.txt
	cat log.txt
	echo "===================== Channel commonchannel  created ===================== "
	echo
}



echo "Channel name : "$CHANNEL_NAME_PA
createChannel_PA() {
  #设置ORG1的环境变量
	setGlobals 0 1

              #启用TLS(我们的MEDREC项目是启用了TLS的)
	peer channel create -o orderer.medrec.com:7050 -c $CHANNEL_NAME_PA -f ./channel-artifacts/channelpa.tx --tls true --cafile $ORDERER_CA >&log.txt

	cat log.txt

	echo "===================== Channel '$CHANNEL_NAME_PA' created ===================== "
	echo
}


echo "Channel name : "$CHANNEL_NAME_PB
createChannel_PB() {
  #设置ORG1的环境变量
	setGlobals 0 1
                #启用TLS(我们的MEDREC项目是启用了TLS的)
	peer channel create -o orderer.medrec.com:7050 -c $CHANNEL_NAME_PB -f ./channel-artifacts/channelpb.tx --tls true --cafile $ORDERER_CA >&log.txt

	echo "===================== Channel '$CHANNEL_NAME_PB' created ===================== "
	echo
}




joinChannel_common () {
	for org in 1 2 3; do
	    for peer in 0; do
		joinChannelWithRetry_common $peer $org
		echo "===================== peer${peer}.org${org} joined channel commonchannel ===================== "
		sleep 3
		echo
	    done
	done
}


joinChannel_PA () {
	for org in 1 2; do
	    for peer in 0 ; do
		joinChannelWithRetry_PA $peer $org
		echo "===================== peer${peer}.org${org} joined channel '$CHANNEL_NAME_PA' ===================== "
		sleep 3
		echo
	    done
	done
}


joinChannel_PB () {
	for org in 1 3; do
	    for peer in 0; do
		joinChannelWithRetry_PB $peer $org
		echo "===================== peer${peer}.org${org} joined channel '$CHANNEL_NAME_PB' ===================== "
		sleep 3
		echo
	    done
	done
}






## Create channel_common
echo "Creating channel_common..."
createChannel_common

## Join all the peers to the channel_common
echo "Having all peers join the channel_common..."
joinChannel_common

## Set the anchor peers for each org in the channel_common
echo "Updating anchor peers for org1..."
updateAnchorPeers_common 0 1
echo "Updating anchor peers for org2..."
updateAnchorPeers_common 0 2
echo "Updating anchor peers for org3..."
updateAnchorPeers_common 0 3





## Create channel_PA
echo "Creating channel_PA..."
createChannel_PA

## Join all the peers to the channel_common
echo "Having all peers join the channel_PA..."
joinChannel_PA

## Set the anchor peers for each org in the channel_common
echo "Updating anchor peers for org1..."
updateAnchorPeers_PA 0 1
echo "Updating anchor peers for org2..."
updateAnchorPeers_PA 0 2





## Create channel_PB
echo "Creating channel_PB..."
createChannel_PB

## Join all the peers to the channel_common
echo "Having all peers join the channel_PB..."
joinChannel_PB

## Set the anchor peers for each org in the channel_common
echo "Updating anchor peers for org1..."
updateAnchorPeers_PB 0 1
echo "Updating anchor peers for org3..."
updateAnchorPeers_PB 0 3




echo
echo "========= All GOOD, MEDREC execution completed =========== "
echo

echo
echo "*************************************************************************************************************"
echo "************************* MEDREC NETWORK is built down , please start your application **********************"
echo "*************************************************************************************************************"
echo

exit 0

