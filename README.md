# svgen

[![npm](https://img.shields.io/npm/v/@nonbili/svgen.svg)](https://www.npmjs.com/package/@nonbili/svgen)

Generate an icons module in purescript halogen from svg files.

## Usage

```
yarn add --dev @nonbili/svgen
yarn svgen -h
```

## Example

```
node index.js  -F example/svg -o ./example/src/Icons.purs --svgo-config ./example/svgo.config.json
cd example
yarn
pulp build
yarn start
```

The generated `Icons.purs` will be like

```purescript
module Icons where

import Prelude ((<>))
import Halogen.HTML

ns :: Namespace
ns = Namespace "http://www.w3.org/2000/svg"

iconHeart :: forall p r i. Array (IProp r i) -> HTML p i
iconHeart attrs =
  elementNS ns (ElemName "svg")
  ( attrs <> [ attr (AttrName "width") "16"
  , attr (AttrName "height") "16"
  , attr (AttrName "viewBox") "0 0 16 16"
  ])
  [ elementNS ns (ElemName "path")
    [ attr (AttrName "d") "M11.252 11.422C13.912 9.426 15 7.96 15 6c0-2.283-1.18-4-3.5-4a1.63 1.63 0 0 0-.569.136c-.347.14-.743.373-1.155.673a10.275 10.275 0 0 0-1.069.898L8 4.414l-.707-.707a10.275 10.275 0 0 0-1.069-.898c-.412-.3-.808-.533-1.155-.673A1.623 1.623 0 0 0 4.5 2C2.18 2 1 3.717 1 6c0 1.959 1.087 3.426 3.748 5.422.436.327 2.206 1.582 3.252 2.339 1.046-.757 2.816-2.012 3.252-2.339zM8 3s2-2 3.5-2C15 1 16 4 16 6c0 4-4 6-8 9-4-3-8-5-8-9 0-2 1-5 4.5-5C6 1 8 3 8 3z"
    ]
    [
    ]
  ]
```

Then use it like

```purescript
import Icons (iconHeart)

className = HH.attr (HH.AttrName "class")

render state =
  HH.div_
  [ iconHeart
    [ className "icon" ]
  ]
```
