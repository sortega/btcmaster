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
# Let's start with a quiz

- I know Bitcoin since...

--
- The reason I'm looking into blockchain is...

--
- I have/haven't technical background

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
- [Some transaction](https://blockchain.info/es/tx/012d4328faea5db184fd4d020c8b36b390a75909e47c5bc02b1654bd766195e7)

--
- There is way more than the final user sees

---
# Bitcoin under the microscope

![bitcoin network](images/network.png)

---
# Exploration tools
## Bitcoin itself
- Full bitcoin node
- bitcoin-cli
- Regnet

--
<img src="images/mining_rigs.jpg" alt="our mining setup"
     style="float: right; width:35%; position: relative; top: -200px"/>

???

- TODO: dyndns to full node
- TODO: howto regnet in docker

---

# Exploration tools
## Scripting tools
- bitcoin explorer, aka `bx`
  - OS X: `brew install libbitcoin-explorer`
  - Other:
     - Visit https://github.com/libbitcoin/libbitcoin-explorer/wiki/Download-BX
     - Download binary, then save at `/usr/local/bin` with exec permission
  - Official [docs](https://github.com/libbitcoin/libbitcoin-explorer/wiki)
- `python-bitcoinlib`
- `bitcoinj`

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
   $ apt-get update
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
# Regnet in a box

- Regnet is a test mode with minimum difficulty
- You can generate blocks at will
- You need at least two bitcoin processes running
- Ready for you to use from https://github.com/freewil/bitcoin-testnet-box

---
# Regnet in a box (II)

- `git clone https://github.com/freewil/bitcoin-testnet-box.git regnet`
- `make start`
- `make getinfo`

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

<img src="images/elliptic_operations.png" alt="elliptic curve operations"
     style="width: 40%; float: left; margin-right: 2em"/>
--
Keys are points **within the curve**.


--
You can infer the point with just x and the sign (**compressed keys**).


--
You **can't get** from the public to the private key.

---
# Public key cryptography

<img src="images/discrete_elliptic_curve.png" alt="discrete elliptic"
     style="width: 40%; float: left; margin-right: 2em"/>

--

- Private key holder:
   - able to sign messages
   - able to recive encrypted information

- Public key holders (everyone):
   - able to verify signatures
   - able to send encrypted information

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
# Cryptographic hash functions

- A hash function
  - maps data of any length into a fixed number of bits (bytes)
  - in a pseudorandom way (change anything and half of the bytes change)
  - **cryptographic**: you cannot find data with a given hash

--
- Used in bitcoin
  - SHA-256: `echo hola | sha256sum`
  - RIPEMD-160: `echo 1234 | bx ripemd160`
  - e.g. to link the [chain of blocks](https://en.bitcoin.it/wiki/Block_hashing_algorithm)

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
  - `Base58Check(Ripemd160(Sha256(PubKey)), version)`
  - [Comprehensive list](https://en.bitcoin.it/wiki/List_of_address_prefixes)
  - How to create a normal address:

```
EC=`bx seed | bx ec-new`
PUBLIC=`bx ec-to-public $EC`
ADDRESS=`bx sha256 $PUBLIC | bx ripemd160 | \
         bx base58check-encode --version 0`
bitcoin-cli validateaddress $ADDRESS
```

???

Using regtest-in-a-box:
- Use testnet version `--version 196`
- `bitcoin-cli -datadir=. validateaddress $ADDRESS`

---

# Address encodings and types
## Private keys

- WIF: Wallet import format:
  - Uncompressed `base58check(version=0x80, point)`
  - Compressed `base58check(version=0x80, point || 0x01)`

--
  - Very confusing as compressed keys are longer!

--
```bash
$ WIF=`bx ec-to-wif $EC`
$ bx base58check-decode $WIF
{
    checksum 2706479491
    payload b90b254bf ... 0e8b1748a72aa2409a862413ee01
    version 128
}
```

---
class: impact

# Anatomy of a transaction

---

# Information in a transaction

- Version: 1 so far
- Lock time

--
- Inputs: pointers to funds to spend and **witness** information. It is empty
    for the coinbase.
  - TX hash: points to a previous transaction
  - Index: which output to spend
  - Script: instructions to unlock the output
  - Sequence: flags for advanced TXs

--
- Outputs: what to do with the funds
  - Value
  - Script: cryto puzzle to solve


--
Everything else is an **abstraction in our head!**

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
01000000010000000000000000000000000000000000 \
000000000000000000000000000000ffffffff0704ff \
ff001d0104ffffffff0100f2052a0100000043410496 \
b538e853519c726a2c91e61ec11600ae1390813a627c \
66fb8be7947be63c52da7589379515d4e0a604f81417 \
81e62294721166bf621e73a82cbf2342c858eeac0000 \
0000
```

---

# bitcoin-cli is your friend (IV)
- Parsed transaction:
```bash
$ bitcoin-cli getrawtransaction \
  0e3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098 1
{
  "version": 1,
  ...
  "confirmations": 186616,
  "time": 1231469665,
  "blocktime": 1231469665
}
```
- Also with bx: `bx tx-decode $RAW_TX`

---

# RPC interface

- `bitcoin-cli` is just a wrapper to a JSON-RPC endpoint
- port 8332 by default
- sample request:
```bash
$ curl  --data-binary '{
    "jsonrpc": "1.0",
    "method": "getrawtransaction", 
    "params": ["0e3e2357e806b6cdb1f70b54c3a3a17b6714ee1f0e68bebb44a74b1efd512098", 1] 
  }' \
  -H 'content-type: text/plain;' \
  http://rpc:secret@127.0.0.1:8332/
```

---

# Playing with the built-in wallet

- Check wallet status: `bitcoin-cli getwalletinfo`
- Generate an address: `bitcoin-cli getnewaddress`
- Get private key: `bitcoin-cli dumpprivkey <address>`
- TODO: send money, check the pending pool and the mempool

---

# Rules to validate a transaction

---

# TODO list

- Sequence number
- Standard transactions
- P2SH
- Most common opcodes
- Other common transactions
- SPV
- Merkle trees
- State channels
