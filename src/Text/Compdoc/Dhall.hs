{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Text.Compdoc.Dhall where

import Composite.Aeson
import Composite.Record
import Data.Either.Validation
import Data.Text as T
import Data.Typeable
import Data.Void
import qualified Dhall as D
import Text.Compdoc
import Text.Pandoc

-- | Decode a Compdoc value.
compdocDecoder :: WriterOptions -> JsonFormat Void (Record a) -> D.InputNormalizer -> D.Decoder (Compdoc a)
compdocDecoder wopts f opts =
  D.Decoder
    { D.extract = extractDoc,
      D.expected = expectedDoc
    }
  where
    docDecoder :: D.Decoder Text
    docDecoder = D.autoWith opts

    extractDoc expression =
      case D.extract docDecoder expression of
        Success x -> case readMarkdown' def {readerExtensions = pandocExtensions} wopts f x of
          Left exception -> D.extractError (T.pack $ show exception)
          Right l -> Success l
        Failure e -> Failure e
    expectedDoc = D.expected docDecoder
