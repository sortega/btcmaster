title: Bitcoin scripting
subtitle: Fundamentos de Bitcoin
class: animation-fade
layout: true

<!-- This slide will serve as the base layout for all your slides -->
.bottom-bar[
  {{subtitle}} &gt; {{title}}
]

---

class: impact

# {{title}}
## {{subtitle}}

---

# Public key cryptography

- Not used to encrypt Bitcoin messages!
   - Bitcoin is pseudonym after all 
   - All is validated with cryptographic hashes and digital signatures
- Key pairs
   - Private key: 256 random bits
   - Public key: TODO
- Digital signature
- Relationship between public key and address
  - `Base58Check(Sha256(PubKey))`

---

# Anatomy of a transaction

TODO

---

class: impact

# My dev full node!

---

# Getting bitcoin core

 - `git clone git@github.com:bitcoin/bitcoin.git` and follow instructions
 - OS X: `brew install bitcoin`
 - Linux: `apt-get install bitcoind`

---

# Initial bitcoin.conf

 - At `~/Library/Application Support/Bitcoin/` or `~/.bitcoin`

--

 - Contents:
```conf
server=1
rpcuser=rpc
rpcpassword=secret
txindex=1
```

---

# Starting up

 - Debugging: `bitcoind -printtoconsole`
 - Background: `bitcoind -daemon`
   - Check `$DATADIR/bitcoin.pid`
   - Logs at `$DATADIR/debug.log`

---

# Bitcoin data directory (I)

 - P2P info:
    - `addr.dat`
    - `peers.dat`
    - `banlist.dat`
 - Blockchain:
    - `mempool.dat`
    - `blocks/`
    - `chainstate/`
 - General lock: `.lock`
---

# Bitcoin data directory (II)

 - Berkley DB:
    - `__db.xxx`
    - `database/`
 - Logs
    - db.log
    - debug.log
 - Use as wallet:
   - `wallet.dat`
   - `fee_estimates.dat`

---

# bitcoin-cli is your friend

 - `bitcoin-cli help`
 - Getting general info:
   - `bitcoin-cli getnetworkinfo`
     ([doc](https://chainquery.com/bitcoin-api/getnetworkinfo))
   - `bitcoin-cli getblockchaininfo`
     ([doc](https://chainquery.com/bitcoin-api/getblockchaininfo))
   - `bitcoin-cli getwalletinfo`
     ([doc](https://chainquery.com/bitcoin-api/getwalletinfo))

---

# bitcoin-cli is your friend (II)

 - Get block at height `<height>`
   - `bitcoin-cli getblockhash <height>`
   - `bitcoin-cli getblock <hash>`

```json
{
  "hash": "00000000000000a5d5588f30f4b73df49298de7002a32ba8e4e8d4c7f23969a8",
  "confirmations": 896,
  "strippedsize": 22901,
  "size": 22901,
  "weight": 91604,
  "height": 173969,
  "version": 1,
  "versionHex": "00000001",
  "merkleroot": "461c761b23770a99662978402f98495371bd86a3bb443bc3198fb288dbaf4dbd",
  "tx": [
    "43cbc412d913544736490d72acf2058bc75f6d010a36e48d2c2f3afd31a8842d",
    ...
    "bcbeda529eab9ea1d0b8854a9b9792eb29b45acd10da5708174173eebb80a95c"
  ],
  "time": 1333346582,
  "mediantime": 1333339990,
  "nonce": 1632871221,
  "bits": "1a0a507e",
  "difficulty": 1626553.481328943,
  "chainwork": "00000000000000000000000000000000000000000000000f47950954e8d5c12a",
  "previousblockhash": "0000000000000173edc54a237cdb77390ab70c1c7337ad115e3f28c01d8a06ea",
  "nextblockhash": "0000000000000399a36b1d283529144a43da0c3bba45f9aa866bee53e55065b4"
}
```
---

# bitcoin-cli is your friend (III)

Get transaction details:

- Raw transaction:
```bash
$ bitcoin-cli getrawtransaction 0e3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098
01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff0704ffff001d0104ffffffff0100f2052a0100000043410496b538e853519c726a2c91e61ec11600ae1390813a627c66fb8be7947be63c52da7589379515d4e0a604f8141781e62294721166bf621e73a82cbf2342c858eeac00000000
```
- Parsed transaction:
```bash
$ bitcoin-cli getrawtransaction \
  0e3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098 1
{
  "txid": "0e3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098",
  "hash": "0e3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098",
  "version": 1,
  "size": 134,
  "vsize": 134,
  "locktime": 0,
  "vin": [
    {
      "coinbase": "04ffff001d0104",
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 50.00000000,
      "n": 0,
      "scriptPubKey": {
        "asm": "0496b538e853519c726a2c91e61ec11600ae1390813a627c66fb8be7947be63c52da7589379515d4e0a604f8141781e62294721166bf621e73a82cbf2342c858ee OP_CHECKSIG",
        "hex": "410496b538e853519c726a2c91e61ec11600ae1390813a627c66fb8be7947be63c52da7589379515d4e0a604f8141781e62294721166bf621e73a82cbf2342c858eeac",
        "reqSigs": 1,
        "type": "pubkey",
        "addresses": [
          "12c6DSiU4Rq3P4ZxziKxzrL5LmMBrzjrJX"
        ]
      }
    }
  ],
  "hex": "01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff0704ffff001d0104ffffffff0100f2052a0100000043410496b538e853519c726a2c91e61ec11600ae1390813a627c66fb8be7947be63c52da7589379515d4e0a604f8141781e62294721166bf621e73a82cbf2342c858eeac00000000",
  "blockhash": "00000000839a8e6886ab5951d76f411475428afc90947ee320161bbf18eb6048",
  "confirmations": 186616,
  "time": 1231469665,
  "blocktime": 1231469665
}
```

---

# RPC interface

- `bitcoin-cli` is just a wrapper to a JSON-RPC endpoint
- port 8332 by default
- sample request:
```bash
$ curl --user rpc  --data-binary '{
    "jsonrpc": "1.0",
    "method": "getrawtransaction", 
    "params": ["0e3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098", 1] 
  }' \
  -H 'content-type: text/plain;' \
  http://127.0.0.1:8332/
```

---

# Playing with keys

- Check wallet status: `bitcoin-cli getwalletinfo`
- Generate an address: `bitcoin-cli getnewaddress`
- Get private key: `bitcoin-cli dumpprivkey <address>`


???

Ideas:

 - Tener mi propia imagen docker con todo instalado o explicar cómo instalar
   en linux cosas
 - Tener un nodo de bitcoin funcionando y compartirlo para el resto de la
   gente (o usar uno público)
