module Icons where

import Prelude ((<>))
import Halogen.HTML

ns :: Namespace
ns = Namespace "http://www.w3.org/2000/svg"


iconComment :: forall p r i. Array (IProp r i) -> HTML p i
iconComment attrs =
  elementNS ns (ElemName "svg")
  ( attrs <> [ attr (AttrName "width") "16"
  , attr (AttrName "height") "16"
  , attr (AttrName "viewBox") "0 0 16 16"
  ])
  [ elementNS ns (ElemName "path")
    [ attr (AttrName "d") "M8.164 12.188a1 1 0 0 1 .546-.216C12.302 11.686 15 9.282 15 6.5 15 3.514 11.906 1 8 1S1 3.514 1 6.5c0 2.207 1.7 4.218 4.312 5.078a1 1 0 0 1 .688.95v1.391l2.164-1.731zM5 12.528c-2.932-.965-5-3.3-5-6.028C0 2.91 3.582 0 8 0s8 2.91 8 6.5c0 3.374-3.163 6.147-7.211 6.469l-3.008 2.406c-.431.345-.781.182-.781-.384v-2.463z"
    ]
    [ 
    ]
  ]

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

