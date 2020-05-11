module Render
  ( Icon
  , renderIconFile
  ) where

import Prelude
import Data.Array as Array
import Data.List (List)
import Data.List as List
import Data.String as String
import Data.String.Regex as Regex
import Data.String.Regex.Flags as RegexFlags
import Data.String.Regex.Unsafe as RegexUnsafe
import Data.Symbol (SProxy(..))
import Record.Format (format)
import Svg.Parser (Element, SvgAttribute(..), SvgNode(..))

sym :: forall a. SProxy a
sym = SProxy

svgAttributeToProp :: SvgAttribute -> String
svgAttributeToProp (SvgAttribute k v) = "attr (AttrName k) v"

renderAttribute :: Int -> SvgAttribute -> String
renderAttribute depth (SvgAttribute k v) =
  format
    ( sym ::
        _
          """attr (AttrName "{k}") "{v}"
{s}"""
    )
    { k
    , v: Regex.replace (RegexUnsafe.unsafeRegex "[\r|\n\t]+" RegexFlags.global) " " v
    , s: String.joinWith "" $ Array.replicate depth "  "
    }

renderAttributes :: Int -> List SvgAttribute -> String
renderAttributes depth attributes = list
  where
  attributes' = List.filter (\(SvgAttribute name _) -> name /= "xmlns") attributes

  list =
    String.joinWith ", "
      $ Array.fromFoldable
      $ renderAttribute depth
      <$> attributes'

renderSvgNode :: Int -> SvgNode -> String
renderSvgNode depth (SvgElement element) = renderElement element depth

renderSvgNode _ (SvgText str) = "text " <> "\"\"\"" <> str <> "\"\"\""

renderSvgNode _ (SvgComment str) = ""

renderSvgNodes :: Int -> List SvgNode -> String
renderSvgNodes depth nodes =
  String.joinWith ", "
    $ Array.fromFoldable
    $ renderSvgNode depth
    <$> nodes

renderElement :: Element -> Int -> String
renderElement { name, attributes, children } depth =
  format
    ( sym ::
        SProxy
          """elementNS ns (ElemName "{name}")
{s}{attributes}
{s}[ {children}
{s}]"""
    )
    { name
    , attributes: attributesString
    , children: renderSvgNodes (depth + 1) children
    , s: String.joinWith "" $ Array.replicate depth "  "
    }
  where
  attributesString' = "[ " <> renderAttributes depth attributes <> "]"

  attributesString :: String
  attributesString =
    if depth == 1 then
      "( attrs <> " <> attributesString' <> ")"
    else
      attributesString'

type Icon
  = { name :: String
    , element :: Element
    }

renderIcon :: Icon -> String
renderIcon { name, element } =
  format
    ( sym ::
        _
          """
icon{name} :: forall p r i. Array (IProp r i) -> HTML p i
icon{name} attrs =
  {element}
"""
    )
    { name
    , element: renderElement element 1
    }

renderIconFile :: String -> Array Icon -> String
renderIconFile moduleName icons =
  format
    ( sym ::
        _
          """module {moduleName} where

import Prelude ((<>))
import Halogen.HTML

ns :: Namespace
ns = Namespace "http://www.w3.org/2000/svg"

{icons}
"""
    )
    { moduleName
    , icons: String.joinWith "" $ renderIcon <$> icons
    }
