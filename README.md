# compdoc-dhall-decoder

This module allows you to decode a `Compdoc` value from markdown.

You should use newtypes like so:

```
newtype MyDoc = MyDoc (Record (Compdoc '[]))
  deriving stock (Eq, Show, Generic)


instance D.FromDhall MyDoc where
  autoWith options = fmap MyDoc $ compdocDecoder def (recordJsonFormat RNil) options
```
