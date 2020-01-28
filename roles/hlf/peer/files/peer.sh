#Start the peer
peer node start &

while ! nc -z $CORE_PEER_ID 7051; do   
  sleep 0.1 # wait for 1/10 of the second before check again
done

# Join the peers to the application channel
CORE_PEER_TLS_ROOTCERT_FILE=/root/${CORE_PEER_ID}/tls-msp/tlscacerts/tls-${TLSCA_HOST}-7054.pem
CORE_PEER_MSPCONFIGPATH=/root/admin/msp

CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH CORE_PEER_ADDRESS=$CORE_PEER_ID:7051 CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE peer channel join -b /root/peer_cli/artifacts/appchannel.block
