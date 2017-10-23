# -*- coding: utf-8 -*-
# See http://bitcoinlib.readthedocs.io/en/latest/
from bitcoin.rpc import Proxy
from bitcoin.core import b2lx, b2x

rpc = Proxy(btc_conf_file="/Users/sortega/Library/Application Support/Bitcoin/bitcoin.conf")
num_blocks = rpc.getinfo()['blocks']
height = num_blocks / 3
block_id = rpc.getblockhash(height)
block = rpc.getblock(block_id)
last_tx = block.vtx[-1]
print("Last transaction in block %s at height %d" % (b2lx(block_id), height))
print("Raw transaction: %s" % b2x(last_tx.serialize()))
print("Parsed transaction: %s" % last_tx)
