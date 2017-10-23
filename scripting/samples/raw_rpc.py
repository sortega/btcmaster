# -*- coding: utf-8 -*-
from bitcoin.rpc import RawProxy

rpc = RawProxy(btc_conf_file="/Users/sortega/Library/Application Support/Bitcoin/bitcoin.conf")
num_blocks = rpc.getblockchaininfo()['blocks']
height = num_blocks / 4
block_id = rpc.getblockhash(height)
block = rpc.getblock(block_id)
last_tx_id = block['tx'][-1]
print("Last transaction in block % at height %" % (block_id, height))
print("Raw transaction: %" % rpc.getrawtransaction(last_tx_id))
print("Parsed transaction: %" % rpc.getrawtransaction(last_tx_id, 1))
