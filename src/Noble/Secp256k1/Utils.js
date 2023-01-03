import * as lib from "@noble/secp256k1";

export const randomPrivateKey = () => lib.utils.randomPrivateKey();

export const _sha256 = bytes => () => lib.utils.sha256(bytes);

export const _hashToPrivateKey = nothing => just => bytes => {
  try {
    return just(lib.utils.hashToPrivateKey(bytes));
  } catch (_) {
    return nothing;
  }
};

export const isValidPrivateKey = lib.utils.isValidPrivateKey;
