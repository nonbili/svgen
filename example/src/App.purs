module App where

import Prelude

import Data.Maybe (Maybe(..))

import Halogen as H
import Halogen.HTML as HH
import Icons (iconheart)

data Query a = Toggle a

type State = { on:: Boolean }

className :: forall r i. String -> HH.IProp r i
className = HH.attr (HH.AttrName "class")

render :: State -> H.ComponentHTML Query
render state =
  HH.div_
  [ iconheart
    [ className "icon" ]
  ]

app :: forall m. H.Component HH.HTML Query Unit Void m
app =
  H.component
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  initialState :: State
  initialState = { on: false }

  eval :: Query ~> H.ComponentDSL State Query Void m
  eval = case _ of
    Toggle next -> do
      void $ H.modify (\state -> { on: not state.on })
      pure next
