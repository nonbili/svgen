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
    <> O.help "Input folder, all *.svg will be used"
     )
  <|>
  InputFile <$> O.strOption
     ( O.long "file"
    <> O.short 'f'
    <> O.metavar "FILE"
    <> O.help "Input svg file"
     )

type Config =
  { input :: Input
  , output :: String
  , moduleName :: String
  , svgoConfig :: Maybe String
  }

mkConfig :: Input -> String -> String -> Maybe String -> Config
mkConfig =
  { input: _
  , output: _
  , moduleName: _
  , svgoConfig: _
  }

configParser :: O.Parser Config
configParser = mkConfig
  <$> inputParser
  <*> O.strOption
     ( O.long "output"
    <> O.short 'o'
    <> O.metavar "FILE"
    <> O.help "Output file path"
     )
  <*> O.strOption
     ( O.long "module"
    <> O.short 'm'
    <> O.metavar "NAME"
    <> O.value "Icons"
    <> O.showDefault
    <> O.help "Name of the generated module"
     )
  <*> optional (O.strOption
     ( O.long "svgo-config"
    <> O.metavar "FILE"
    <> O.help "SVGO config file in .js/.json format [optional]"
     ))

configParserInfo :: O.ParserInfo Config
configParserInfo = O.info (configParser <**> O.helper)
  ( O.fullDesc
  <> O.progDesc "Input can be a file or folder"
  <> O.header "svgen - a tool that converts svg files to halogen module" )
