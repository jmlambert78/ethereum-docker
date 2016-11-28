#!/bin/bash
set -e
cd /root/eth-net-intelligence-api
perl -pi -e "s/XXX/$(hostname)/g" app.json
/usr/bin/pm2 start ./app.json
sleep 3
if [ -d "~/.ethereum/devchain/$(hostname)" ]; then
 echo "Area exists"
else
 echo "existe pas"
 mkdir ~/.ethereum/devchain/$(hostname)

fi
/usr/bin/geth --datadir=~/.ethereum/devchain/$(hostname) --ipcpath "~/.ethereum/devchain/geth.ipc"  init "/root/files/genesis.json"
sleep 3
BOOTSTRAP_IP=`getent hosts bootstrap | cut -d" " -f1`
GETH_OPTS=${@/XXX/$BOOTSTRAP_IP}
GETH_OPTS=`echo "$GETH_OPTS"|sed s/YYYHOSTNAME/$(hostname)/`
echo "GETH_OPTS=$GETH_OPTS"
/usr/bin/geth $GETH_OPTS
