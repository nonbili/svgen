module Config
  ( Input(..)
  , Config
  , configParserInfo
  ) where

import Prelude

import Control.Alternative ((<|>))
import Data.Maybe (Maybe, optional)
import Options.Applicative ((<**>))
import Options.Applicative as O

data Input
  = InputFolder String
  | InputFile String

inputParser :: O.Parser Input
inputParser =
  InputFolder <$> O.strOption
     ( O.long "folder"
    <> O.short 'F'
    <> O.metavar "FOLDER"
    <> O.help "Input folder"
     )
  <|>
  InputFile <$> O.strOption
     ( O.long "file"
    <> O.short 'f'
    <> O.metavar "FILE"
    <> O.help "Input file"
     )

type Config =
  { input :: Input
  , svgoConfig :: Maybe String
  }

mkConfig :: Input -> Maybe String -> Config
mkConfig =
  { input: _
  , svgoConfig: _
  }

configParser :: O.Parser Config
configParser = mkConfig
  <$> inputParser
  <*> optional (O.strOption
     ( O.long "svgo-config"
    <> O.help "SVGO config file in JSON format"
     ))

configParserInfo :: O.ParserInfo Config
configParserInfo = O.info (configParser <**> O.helper)
  ( O.fullDesc
  <> O.progDesc "Print a greeting for TARGET"
  <> O.header "hello - a test for purescript-optparse" )
