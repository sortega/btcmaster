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
# Bitcoin under the microscope

- Bitcoin is:
  - the name of the network
--

  - the name of the token
--

  - the name of an implementation of the consensus rules
--

  - **programmable money**

---
# Bitcoin under the microscope

![bitcoin network](images/transaction.png)
--

- There is way more than the final user sees

---
# Bitcoin under the microscope

![bitcoin network](images/network.png)

---
# Exploration tools
## Bitcoin itself
- Full bitcoin node
- Regnet in docker
- bitcoin-cli

???

- TODO: dyndns to full node
- TODO: howto regnet in docker

---

# Exploration tools
## Scripting tools
- bitcoin explorer, aka `bx`
  - `brew install libbitcoin-explorer` TODO: ubuntu?
  - Official [docs](https://github.com/libbitcoin/libbitcoin-explorer/wiki)
- `python-bitcoinlib`

---
class: impact

# My dev full node!

---

# Getting bitcoin core

 - `git clone git@github.com:bitcoin/bitcoin.git` and follow instructions
 - OS X: `brew install bitcoin`
 - Ubuntu:
   ```bash
   $ apt-add-repository ppa:bitcoin/bitcoin
   $ apt-get install bitcoind
   ```

---
# Initial bitcoin.conf
 - At `~/Library/Application Support/Bitcoin/` or `~/.bitcoin`

--
 - Minimal settings:
```conf
server=1
rpcuser=rpc
rpcpassword=secret
txindex=1
```

---
# Initial bitcoin.conf
 - Other interesting settings:
   - `dbcache`: memory (in MB) for the tx database
   - `par`: threads used for validation
   - `reindex`: rebuild datastructures by replaying blocks

---
# Starting up

 - Debugging: `bitcoind -printtoconsole`
 - Background: `bitcoind -daemon`
   - Check `$DATADIR/bitcoin.pid`
   - Logs at `$DATADIR/debug.log`
 - Data directory (by default):
   - OS X: `~/Library/Application Support/Bitcoin/`
   - Ubuntu: `~/.bitcoin/`

---
# Bitcoin data directory (I)

 - P2P info:
    - `peers.dat`: addresses for fast reconnects
    - `banlist.dat`
 - Blockchain:
    - `mempool.dat`
    - `blocks/`: actual blocks and a leveldb with metadata
    - `chainstate/`: UXTOs and other tracked data
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
class: impact

# Bitcoin speaks crypto

---
# Public key cryptography

- Not used to encrypt Bitcoin messages!
- Bitcoin is pseudonym after all
- All is validated with cryptographic hashes and digital signatures
- Based on the secp256k1 curve

---
# Public key cryptography

<img src="images/elliptic_curve.png" alt="elliptic curve" style="width: 40%"/>

---
# Public key cryptography

<img src="images/elliptic_operations.png" alt="elliptic curve operations" style="width: 40%"/>

---
# Public key cryptography

<img src="images/discrete_elliptic_curve.png" alt="discrete elliptic" style="width: 40%"/>

---
# Public key cryptography

- Key pairs
   - Private key: 256 random bits (`bx seed`)
   - Correspoing elliptic curve point (`bx ec-new $SEED`)
   - Public key (`bx ec-to-public $PRIVKEY`)
   - Address (`bx ec-to-address --version 0 $PUBLIC`)
   - Private key in WIF format: (`bx ec-to-wif $PRIVKEY`)

---
# Public key cryptography

- Digital signature
   - `bx message-sign $WIF "learning about crypto"`
   - `bx message-validate $ADDRESS $SIGNATURE "learning about crypto"`

---

# Address encodings and types
## Base 58 encoding

- No ambiguous characters:
  - `123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz`
- Sorter than hex
- `bx base58-encode FFF0`
- `bx base58-decode LUf`

---

# Address encodings and types
## Base 58 check encoding

- More robust thanks to an added hash
- Tagged with a version
- `bx base58check-encode --version 0 1A06`
- `bx base58check-decode 1DxgZszAD`

---

# Address encodings and types
## Public keys

- Relationship between public key and address
  - `Base58Check(Sha256(PubKey), version)`
  - [Comprehensive list](https://en.bitcoin.it/wiki/List_of_address_prefixes)
  - How to create a normal address:

TODO: check these scripts

```
EC=`bx seed | bx ec-new`
PUBLIC=`bx ec-to-public $EC`
bx base58check-encode --version 00 $PUBLIC
ADDRESS=`bx ec-to-public $EC | bx ec-to-address --version 0`
bitcoin-cli validateaddress $ADDRESS
```

???

Using regtest-in-a-box:
- Use testnet version `--version 196`
- `bitcoin-cli -datadir=. validateaddress $ADDRESS`

---

# Address encodings and types
## Private keys

- Either compressed or not
  - Very confusing as compressed keys are longer!
- 

---

# Key encodings

- WIF
- WIF-compressed

---

# Anatomy of a transaction

TODO

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
