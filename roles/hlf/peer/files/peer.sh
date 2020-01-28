#mkdir -p $CORE_PEER_MSPCONFIGPATH/admincerts
#cp $CORE_PEER_MSPCONFIGPATH/signcerts/* $CORE_PEER_MSPCONFIGPATH/admincerts/

#Start the peer
peer node start &

# Hotfix. Later check if peer has started before rtunning the following commands
sleep 15s
# Join the peers to the application channel
# Peer1
CORE_PEER_TLS_ROOTCERT_FILE=/root/${CORE_PEER_ID}/tls-msp/tlscacerts/tls-${TLSCA_HOST}-7054.pem
CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH CORE_PEER_ADDRESS=$CORE_PEER_ID:7051 CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE peer channel join -b /root/peer_cli/artifacts/appchannel.block
