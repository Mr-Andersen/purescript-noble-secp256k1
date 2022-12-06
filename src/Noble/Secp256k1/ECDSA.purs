module Noble.Secp256k1.ECDSA
  ( signECDSA
  , signECDSAWithRecoveredBit
  , getECDSAPublicKey
  , getECDSASharedSecret
  , recoverECDSAPublicKey
  , mkPrivateKey
  , verifyECDSA
  , PrivateKey
  , ECDSAPublicKey
  , Message
  , MessageHash
  , ECDSASignature
  , ECDSASharedSecret
  , ECDSARecoveredBit
  , IsCompressed
  ) where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Function (on)
import Data.Maybe (Maybe(Just, Nothing))
import Data.Tuple (Tuple(Tuple))
import Effect (Effect)
import Effect.Aff (Aff)

signECDSA :: MessageHash -> PrivateKey -> Aff ECDSASignature
signECDSA msgHash privateKey = toAffE $ _sign msgHash privateKey

signECDSAWithRecoveredBit
  :: MessageHash -> PrivateKey -> Aff (Tuple ECDSASignature ECDSARecoveredBit)
signECDSAWithRecoveredBit msgHash privateKey = toAffE $ _signWithRecoveredBit
  Tuple
  msgHash
  privateKey

newtype PrivateKey = PrivateKey Uint8Array

mkPrivateKey :: Uint8Array -> Maybe PrivateKey
mkPrivateKey uint8arr 
  | _isValidPrivateKey uint8arr = Just $ PrivateKey uint8arr
  | otherwise = Nothing

newtype ECDSAPublicKey = ECDSAPublicKey Uint8Array

type Message = Uint8Array

newtype MessageHash = MessageHash Uint8Array

newtype ECDSASignature = ECDSASignature Uint8Array

newtype ECDSASharedSecret = ECDSASharedSecret Uint8Array


foreign import getECDSAPublicKey :: PrivateKey -> IsCompressed -> ECDSAPublicKey

foreign import _isValidPrivateKey :: Uint8Array -> Boolean

foreign import _sign
  :: MessageHash -> PrivateKey -> Effect (Promise ECDSASignature)

foreign import _signWithRecoveredBit
  :: (forall a b. a -> b -> Tuple a b)
  -> MessageHash
  -> PrivateKey
  -> Effect (Promise (Tuple ECDSASignature ECDSARecoveredBit))

foreign import verifyECDSA
  :: ECDSASignature
  -> MessageHash
  -> ECDSAPublicKey
  -> Boolean

foreign import getECDSASharedSecret
  :: PrivateKey
  -> ECDSAPublicKey
  -> IsCompressed
  -> ECDSASharedSecret

foreign import recoverECDSAPublicKey
  :: MessageHash
  -> ECDSASignature
  -> ECDSARecoveredBit
  -> IsCompressed
  -> ECDSAPublicKey

type IsCompressed = Boolean

type ECDSARecoveredBit = Number

instance Show PrivateKey where
  show _ = "<PrivateKey contents not exposed>"

instance Eq PrivateKey where
  eq = eqViaShow

instance Ord PrivateKey where
  compare = compareViaShow

instance Show ECDSAPublicKey where
  show (ECDSAPublicKey x) = "(ECDSAPublicKey " <> _showBytes x <> ")"

instance Eq ECDSAPublicKey where
  eq = eqViaShow

instance Ord ECDSAPublicKey where
  compare = compareViaShow

instance Show MessageHash where
  show (MessageHash x) = "(MessageHash " <> _showBytes x <> ")"

instance Eq MessageHash where
  eq = eqViaShow

instance Ord MessageHash where
  compare = compareViaShow

instance Show ECDSASignature where
  show (ECDSASignature x) = "(ECDSASignature " <> _showBytes x <> ")"

instance Eq ECDSASignature where
  eq = eqViaShow

instance Ord ECDSASignature where
  compare = compareViaShow

instance Show ECDSASharedSecret where
  show (ECDSASharedSecret x) = "(ECDSASharedSecret " <> _showBytes x <> ")"

instance Eq ECDSASharedSecret where
  eq = eqViaShow

instance Ord ECDSASharedSecret where
  compare = compareViaShow

foreign import _showBytes :: forall a. a -> String

compareViaShow :: forall a. a -> a -> Ordering
compareViaShow = compare `on` _showBytes

eqViaShow :: forall a. a -> a -> Boolean
eqViaShow = eq `on` _showBytes
