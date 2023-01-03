import * as lib from "@noble/secp256k1";

export const _sign = message => privateKey => () =>
  lib.schnorr.sign(message, privateKey);

export const _verify = signature => message => publicKey => () =>
  lib.schnorr.verify(signature, message, publicKey);

export const getSchnorrPublicKey = privateKey =>
  lib.schnorr.getPublicKey(privateKey);
