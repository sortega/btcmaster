#!/bin/bash

A_ADDRESS=mmExseHntdMrXeWgpsCgdnYJ73NUrhVBfo
B_ADDRESS=n2Ex7frqiqgzWgdk4xw2kuwp9ZCXsjTXYK
C_ADDRESS=mwTJwudQmxa8DreFnSZGFaxbopXjK69rcw
D_ADDRESS=mwTJwudQmxa8DreFnSZGFaxbopXjK69rcw

# 1 << 31 & number of blocks of 512 seconds
# 1 << 31 = 0x80000000 & 30 * 24 * 60 * 60 / 512 = 5062 = 0x13C6
DAYS30=800013C6
DAYS90=8000278D

SCRIPT="[
OP_IF
  OP_IF
    OP_2
  OP_ELSE
    ${DAYS30} OP_CHECKSEQUENCEVERIFY OP_DROP
    ${A_ADDRESS} OP_CHECKSIGVERIFY
    OP_1
  OP_ENDIF
  ${B_ADDRESS} ${C_ADDRESS} ${D_ADDRESS} OP_3 OP_CHECKMULTISIG
OP_ELSE
  ${DAYS90} OP_CHECKSEQUENCEVERIFY OP_DROP
  ${A_ADDRESS} OP_CHECKSIG
OP_ENDIF
]"

A_SIG=FFFF
B_SIG=FFFF
C_SIG=FFFF
D_SIG=FFFF
UNLOCK_2_OF_3="OP_0 ${B_SIG} ${D_SIG} OP_TRUE OP_TRUE"
#UNLOCK_2_OF_3="OP_0 ${C_SIG} ${A_SIG} OP_FALSE OP_TRUE"


echo $SCRIPT
./btcdeb "$SCRIPT" $UNLOCK_2_OF_3
