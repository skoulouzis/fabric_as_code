# Create the application channel
CORE_PEER_TLS_ROOTCERT_FILE=/root/${PEER1_HOST}/tls-msp/tlscacerts/tls-${TLSCA_HOST}-7054.pem
CORE_PEER_MSPCONFIGPATH=/root/admin/msp 
mkdir -p $CORE_PEER_MSPCONFIGPATH/admincerts
cp $CORE_PEER_MSPCONFIGPATH/signcerts/* $CORE_PEER_MSPCONFIGPATH/admincerts/
CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH peer channel create -c appchannel -f /root/peer_cli/artifacts/appchannel.tx -o ${ORDERER_HOST}:7050 --outputBlock /root/peer_cli/artifacts/appchannel.block --tls --cafile ${CORE_PEER_TLS_ROOTCERT_FILE}

# Join the peers to the application channel
# Peer1
CORE_PEER_TLS_ROOTCERT_FILE=/root/${PEER1_HOST}/tls-msp/tlscacerts/tls-${TLSCA_HOST}-7054.pem
CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH CORE_PEER_ADDRESS=$PEER1_HOST:7051 CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE peer channel join -b /root/peer_cli/artifacts/appchannel.block

# Peer2
CORE_PEER_TLS_ROOTCERT_FILE=/root/${PEER2_HOST}/tls-msp/tlscacerts/tls-${TLSCA_HOST}-7054.pem
CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH CORE_PEER_ADDRESS=$PEER2_HOST:7051 CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE peer channel join -b /root/peer_cli/artifacts/appchannel.block

#Update the channel with anchor peers
CORE_PEER_TLS_ROOTCERT_FILE=/root/${PEER1_HOST}/tls-msp/tlscacerts/tls-${TLSCA_HOST}-7054.pem
CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH peer channel update -o ${ORDERER_HOST}:7050 -c appchannel -f /root/peer_cli/artifacts/appchannel_anchor.tx --tls --cafile ${CORE_PEER_TLS_ROOTCERT_FILE}


while true; do
  sleep 0.1
done
