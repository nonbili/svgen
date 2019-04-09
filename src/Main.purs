module Main where

import Prelude

import App (app)
import Config (configParserInfo)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Options.Applicative as O

main :: Effect Unit
main = do
  config <- O.execParser configParserInfo
  launchAff_ $ app config
