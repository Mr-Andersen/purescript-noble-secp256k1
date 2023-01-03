import * as lib from "@noble/secp256k1";

export const getECDSAPublicKey = privateKey => isCompressed =>
  lib.getPublicKey(privateKey, isCompressed);

export const _sign = msgHash => privateKey => der => () =>
  lib.sign(msgHash, privateKey, { der });

export const _signWithRecoveredBit = tuple => msgHash => privateKey => der => () =>
  lib
    .sign(msgHash, privateKey, { recovered: true, der })
    .then(res => tuple(res[0])(res[1]));

export const verifyECDSA = signature => msgHash => publicKey =>
  lib.verify(signature, msgHash, publicKey);

export const getECDSASharedSecret = privateKey => publicKey => isCompressed =>
  lib.getSharedSecret(privateKey, publicKey, isCompressed);

export const recoverECDSAPublicKey =
  msgHash => signature => recovery => isCompressed =>
    lib.recoverPublicKey(msgHash, signature, recovery, isCompressed);

export const _isValidPrivateKey = privateKey =>
  lib.utils.isValidPrivateKey(privateKey);
