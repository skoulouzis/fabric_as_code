export FABRIC_CA_CLIENT_TLS_CERTFILES=$HOST_HOME/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$HOST_HOME/caadmin

echo "Enroll CA admin for $FABRIC_CA_NAME"
fabric-ca-client enroll -d -u https://ca-admin-$FABRIC_CA_NAME:$FABRIC_CA_SECRET@$FABRIC_CA_NAME:$FABRIC_CA_PORT

echo "Regsiter orderer at $FABRIC_CA_NAME"
fabric-ca-client register -d --id.name $PEER1_HOST --id.secret $PEER1_SECRET --id.type peer -u https://$FABRIC_CA_NAME:$FABRIC_CA_PORT

echo "Regsiter peers at $FABRIC_CA_NAME"
fabric-ca-client register -d --id.name $PEER2_HOST --id.secret $PEER2_SECRET --id.type peer -u https://$FABRIC_CA_NAME:$FABRIC_CA_PORT
fabric-ca-client register -d --id.name $ORDERER_HOST --id.secret $ORDERER_SECRET --id.type peer -u https://$FABRIC_CA_NAME:$FABRIC_CA_PORT

echo "Regsiter admin at $FABRIC_CA_NAME"
fabric-ca-client register -d --id.name admin-$FABRIC_CA_NAME --id.secret $FABRIC_CA_SECRET --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://$FABRIC_CA_NAME:$FABRIC_CA_PORT

#Create an admin user for organization CA
type=$1
tlsca="tlsca"
orgca="orgca"

if [ $type == $tlsca ]; then     
  export FABRIC_CA_CLIENT_MSPDIR=tls-msp
  # Enroll Peers
  #Peer1
  export FABRIC_CA_CLIENT_HOME=$HOST_HOME/peer1
  fabric-ca-client enroll -d -u https://$PEER1_HOST:$PEER1_SECRET@$FABRIC_CA_NAME:$FABRIC_CA_PORT --enrollment.profile tls --csr.hosts $PEER1_HOST,127.0.0.1
  filename=$(ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_MSPDIR/keystore | sort -n | head -1)
  mv $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_MSPDIR/keystore/$filename $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_MSPDIR/keystore/key.pem
  #Peer2
  export FABRIC_CA_CLIENT_HOME=$HOST_HOME/peer2
  fabric-ca-client enroll -d -u https://$PEER2_HOST:$PEER2_SECRET@$FABRIC_CA_NAME:$FABRIC_CA_PORT --enrollment.profile tls --csr.hosts $PEER2_HOST,127.0.0.1
  filename=$(ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_MSPDIR/keystore | sort -n | head -1)
  mv $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_MSPDIR/keystore/$filename $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_MSPDIR/keystore/key.pem

  #Enroll Orderer
  export FABRIC_CA_CLIENT_HOME=$HOST_HOME/orderer
  fabric-ca-client enroll -d -u https://$ORDERER_HOST:$ORDERER_SECRET@$FABRIC_CA_NAME:$FABRIC_CA_PORT --enrollment.profile tls --csr.hosts $ORDERER_HOST,127.0.0.1
  filename=$(ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_MSPDIR/keystore | sort -n | head -1)
  mv $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_MSPDIR/keystore/$filename $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_MSPDIR/keystore/key.pem
  
elif [ $type == $orgca ]; then   
  export FABRIC_CA_CLIENT_MSPDIR=msp
  # Enroll Peers 
  #Peer1
  export FABRIC_CA_CLIENT_HOME=$HOST_HOME/peer1
  fabric-ca-client enroll -d -u https://$PEER1_HOST:$PEER1_SECRET@$FABRIC_CA_NAME:$FABRIC_CA_PORT
  #Peer2
  export FABRIC_CA_CLIENT_HOME=$HOST_HOME/peer2
  fabric-ca-client enroll -d -u https://$PEER2_HOST:$PEER2_SECRET@$FABRIC_CA_NAME:$FABRIC_CA_PORT

  #Enroll Orderer
  export FABRIC_CA_CLIENT_HOME=$HOST_HOME/orderer
  fabric-ca-client enroll -d -u https://$ORDERER_HOST:$ORDERER_SECRET@$FABRIC_CA_NAME:$FABRIC_CA_PORT
  
  #Enroll Admin
  export FABRIC_CA_CLIENT_HOME=$HOST_HOME/admin  
  fabric-ca-client enroll -d -u https://admin-$FABRIC_CA_NAME:$FABRIC_CA_SECRET@$FABRIC_CA_NAME:$FABRIC_CA_PORT

  # Transfer admincerts
  mkdir $HOST_HOME/$PEER1_HOST/msp/admincerts
  mkdir $HOST_HOME/$PEER2_HOST/msp/admincerts
  mkdir $HOST_HOME/$ORDERER_HOST/msp/admincerts
  cp $HOST_HOME/admin/msp/signcerts/cert.pem $HOST_HOME/$PEER1_HOST/msp/admincerts/admin-cert.pem
  cp $HOST_HOME/admin/msp/signcerts/cert.pem $HOST_HOME/$PEER2_HOST/msp/admincerts/admin-cert.pem
  cp $HOST_HOME/admin/msp/signcerts/cert.pem $HOST_HOME/$ORDERER_HOST/msp/admincerts/admin-cert.pem

else
  echo "type not supplied!"
fi

while true; do
  sleep 0.1
done