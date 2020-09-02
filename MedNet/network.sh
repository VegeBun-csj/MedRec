#!/bin/bash

export PATH=${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
export VERBOSE=false


#镜象的架构类型
OS_ARCH=$(echo "$(uname -s | tr '[:upper:]' '[:lower:]' | sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
# timeout duration - the duration the CLI should wait for a response from
# another container before giving up  在当前指令超时之前启用其他容器的等待时间是10s
CLI_TIMEOUT=10
# default for delay between commands  命令之间的延迟是3s
CLI_DELAY=3
# 系统通道名
SYS_CHANNEL="sys-medrec-channel"
# channel name defaults to "mychannel"
#CHANNEL_NAME="mychannel"
# use this as the default docker-compose yaml definition
COMPOSE_FILE=docker-compose-cli.yaml
#couchdb的compose文件
COMPOSE_FILE_COUCH=docker-compose-couch.yaml

#CA的compose文件
COMPOSE_FILE_CA=docker-compose-ca.yaml
#
# use golang as the default language for chaincode
LANGUAGE=golang
# default image tag
IMAGETAG="latest"
# default consensus type
CONSENSUS_TYPE="solo"


# Print the usage message
function printHelp() {
  echo "Usage: "
  echo "Taking all defaults:"
  echo "	medrec.sh restart"
  echo "	medrec.sh up"
  echo "	medrec.sh down"
}



# Ask user for confirmation to proceed
function askProceed() {
  read -p "Continue? [Y/n] " ans
  case "$ans" in
  y | Y | "")
    echo "proceeding ..."
    ;;
  n | N)
    echo "exiting..."
    exit 1
    ;;
  *)
    echo "invalid response"
    askProceed
    ;;
  esac
}


#下面的移除链码的镜象和容器很重要，每次网络停止后都需要清理，不然下次网络启动安装链码实例化时出现问题
#============================================================================移除链码的docker容器
# TODO Might want to make this optional - could clear other containers
function clearContainers() {
  CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /dev-peer.*/) {print $1}')
  if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
    echo "---- No containers available for deletion ----"
  else
    docker rm -f $CONTAINER_IDS
  fi
}

# Delete any images that were generated as a part of this setup
# specifically the following images are often left behind:
# TODO list generated image naming patterns
function removeUnwantedImages() {
  DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
  if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
    echo "---- No images available for deletion ----"
  else
    docker rmi -f $DOCKER_IMAGE_IDS
  fi
}
#================================================================================移除链码的镜象


# Versions of fabric known not to work with this release of first-network
BLACKLISTED_VERSIONS="^1\.0\. ^1\.1\.0-preview ^1\.1\.0-alpha"


#网络启动之前的预处理，判断二进制版本和当前的fabric镜象版本是否一致
function checkPrereqs() {
  LOCAL_VERSION=$(configtxlator version | sed -ne 's/ Version: //p')
  DOCKER_IMAGE_VERSION=$(docker run --rm hyperledger/fabric-tools:$IMAGETAG peer version | sed -ne 's/ Version: //p' | head -1)

  echo "LOCAL_VERSION=$LOCAL_VERSION"
  echo "DOCKER_IMAGE_VERSION=$DOCKER_IMAGE_VERSION"

  if [ "$LOCAL_VERSION" != "$DOCKER_IMAGE_VERSION" ]; then
    echo "=================== WARNING ==================="
    echo "  Local fabric binaries and docker images are  "
    echo "  out of  sync. This may cause problems.       "
    echo "==============================================="
  fi

  for UNSUPPORTED_VERSION in $BLACKLISTED_VERSIONS; do
    echo "$LOCAL_VERSION" | grep -q $UNSUPPORTED_VERSION
    if [ $? -eq 0 ]; then
      echo "ERROR! Local Fabric binary version of $LOCAL_VERSION does not match this newer version of medrec and is unsupported. Either move to a later version of Fabric or checkout an earlier version of fabric-samples."
      exit 1
    fi

    echo "$DOCKER_IMAGE_VERSION" | grep -q $UNSUPPORTED_VERSION
    if [ $? -eq 0 ]; then
      echo "ERROR! Fabric Docker image version of $DOCKER_IMAGE_VERSION does not match this newer version of medrec and is unsupported. Either move to a later version of Fabric or checkout an earlier version of fabric-samples."
      exit 1
    fi
  done
}

#网络启动，生成证书，创世区块等文件
function networkUp() {
  checkPrereqs
  # generate artifacts if they don't exist
  if [ ! -d "crypto-config" ]; then
    generateCerts       #生成节点，证书文件
    #replacePrivateKey   #清理残留的加密文件
    generateChannelArtifacts  #构建通道和通道配置文件
  fi
  
  COMPOSE_FILES="-f ${COMPOSE_FILE}"       #docker-compose-cli
  
  COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_CA}"      #docker-compose-ca.yaml
  export MEDREC_CA1_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org1.medrec.com/ca && ls *_sk)
  export MEDREC_CA2_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org2.medrec.com/ca && ls *_sk)
  export MEDREC_CA3_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org3.medrec.com/ca && ls *_sk)
  
  COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_COUCH}"         #docker-compose-couchdb.yaml
  
  
  #下面一行是docker-compopse docker-compose-file.yaml up -d (用来启动上面的几个docker-compose的文件，上面把文件名赋值给COMPOSE_FILES了)
  
  docker-compose ${COMPOSE_FILES} up -d
  
  docker ps -a

  # now run the end to end script   执行script脚本来创建通道，peer加入通道，安装链码
  docker exec cli scripts/script.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE $NO_CHAINCODE
  #if [ $? -ne 0 ]; then
    #echo "ERROR !!!! Test failed"
    #exit 1
  #fi
  
  echo "***********************everything is ok,please start your chaincode ***************************"
    echo "***********************everything is ok,please start your chaincode***************************"
      echo "***********************everything is ok,please start your chaincode***************************"
        echo "***********************everything is ok,please start your chaincode***************************"
  
}


# Tear down running network
function networkDown() {
  # stop org3 containers also in addition to org1 and org2, in case we were running sample to add org3
  # stop kafka and zookeeper containers in case we're running with kafka consensus-type
    docker-compose -f $COMPOSE_FILE -f $COMPOSE_FILE_COUCH -f $COMPOSE_FILE_CA down
    clearContainers
    docker run -v $PWD:/tmp/first-network --rm hyperledger/fabric-tools:$IMAGETAG rm -Rf /tmp/first-network/ledgers-backup
    #Cleanup images
    removeUnwantedImages
    rm -rf /home/songjian/hyperledger
    # remove orderer block and other channel configuration transactions and certs
    # 删除peer orderer  以及证书文件，通道配置文件等等
    rm -rf channel-artifacts/*.block channel-artifacts/*.tx crypto-config ./org3-artifacts/crypto-config/ channel-artifacts/org3.json
    # remove the docker-compose yaml file that was customized to the example
    rm -f docker-compose-e2e.yaml
  
}




#生成证书文件
function generateCerts() {
  which cryptogen
  if [ "$?" -ne 0 ]; then
    echo "cryptogen tool not found. exiting"
    exit 1
  fi
  echo
  echo "##########################################################"
  echo "##### Generate certificates using cryptogen tool #########"
  echo "##########################################################"

  if [ -d "crypto-config" ]; then
    #如果已经存在证书文件，删除
    rm -Rf crypto-config
  fi
  set -x
  cryptogen generate --config=./crypto-config.yaml
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate certificates..."
    exit 1
  fi
  echo
  echo "Generate CCP files for Org1 , Org2 , Org3"
  #生成证书后就把相关的peer，orderer的信息，放入CCP文件中
  ./ccpgenerate.sh
}



#生成通道配置信息
function generateChannelArtifacts() {
configtxgen -profile ThreeOrgsOrdererGenesis -channelID sys-channel -outputBlock ./channel-artifacts/genesis.block
#创建应用通道
configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/commonchannel.tx -channelID commonchannel
configtxgen -profile TwoOrgsChannel1 -outputCreateChannelTx ./channel-artifacts/channelpa.tx -channelID channelpa
configtxgen -profile TwoOrgsChannel2 -outputCreateChannelTx ./channel-artifacts/channelpb.tx -channelID channelpb

#在commonchannel创建锚节点
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchorsCommon.tx -channelID commonchannel -asOrg Org1MSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchorsCommon.tx -channelID commonchannel -asOrg Org2MSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchorsCommon.tx -channelID commonchannel -asOrg Org3MSP


#在channelPA中创建锚节点
configtxgen -profile TwoOrgsChannel1 -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchorsPA.tx -channelID channelpa -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel1 -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchorsPA.tx -channelID channelpa -asOrg Org2MSP

#在channelPB中创建锚节点
configtxgen -profile TwoOrgsChannel2 -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchorsPB.tx -channelID channelpb -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel2 -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchorsPB.tx -channelID channelpb -asOrg Org3MSP

}



# Parse commandline args
if [ "$1" = "-m" ]; then # supports old usage, muscle memory is powerful!
  shift
fi
MODE=$1
shift
# Determine whether starting, stopping, restarting, generating or upgrading
if [ "$MODE" == "up" ]; then
  EXPMODE="Starting"
elif [ "$MODE" == "down" ]; then
  EXPMODE="Stopping"
elif [ "$MODE" == "restart" ]; then
  EXPMODE="Restarting"
elif [ "$MODE" == "generate" ]; then
  EXPMODE="Generating certs and genesis block"
elif [ "$MODE" == "upgrade" ]; then
  EXPMODE="Upgrading the network"
else
  printHelp
  exit 1
fi

while getopts "h?c:t:d:f:s:l:i:o:anv" opt; do
  case "$opt" in
  h | \?)
    printHelp
    exit 0
    ;;
  c)
    CHANNEL_NAME=$OPTARG
    ;;
  t)
    CLI_TIMEOUT=$OPTARG
    ;;
  d)
    CLI_DELAY=$OPTARG
    ;;
  f)
    COMPOSE_FILE=$OPTARG
    ;;
  s)
    IF_COUCHDB=$OPTARG
    ;;
  l)
    LANGUAGE=$OPTARG
    ;;
  i)
    IMAGETAG=$(go env GOARCH)"-"$OPTARG
    ;;
  o)
    CONSENSUS_TYPE=$OPTARG
    ;;
  a)
    CERTIFICATE_AUTHORITIES=true
    ;;
  n)
    NO_CHAINCODE=true
    ;;
  v)
    VERBOSE=true
    ;;
  esac
done


# Announce what was requested

if [ "${IF_COUCHDB}" == "couchdb" ]; then
  echo
  echo "${EXPMODE} for channel '${CHANNEL_NAME}' with CLI timeout of '${CLI_TIMEOUT}' seconds and CLI delay of '${CLI_DELAY}' seconds and using database '${IF_COUCHDB}'"
else
  echo "${EXPMODE} for channel '${CHANNEL_NAME}' with CLI timeout of '${CLI_TIMEOUT}' seconds and CLI delay of '${CLI_DELAY}' seconds"
fi
# a在启动的开头，提示是否继续进行过proceeding    yes?
askProceed

#Create the network using docker compose
if [ "${MODE}" == "up" ]; then
  networkUp
elif [ "${MODE}" == "down" ]; then ## Clear the network
  networkDown
elif [ "${MODE}" == "restart" ]; then ## Restart the network
  networkDown
  networkUp
else
  echo "conmmand is err ,please enter the correct command------csj_coding"
  exit 1
fi

