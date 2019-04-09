module App (app) where

import Prelude

import Config (Config, Input(..))
import Data.Array as Array
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String.Extra as StringEx
import Data.Traversable (sequence)
import Effect.Aff (Aff)
import Effect.Aff as Aff
import Effect.Class (liftEffect)
import Node.Buffer as Buffer
import Node.Encoding (Encoding(..))
import Node.FS.Aff as FS
import Node.Globals as Globals
import Node.Path (FilePath)
import Node.Path as Path
import Node.Process as Process
import Render (Icon, renderIconFile)
import SVGO as SVGO
import Svg.Parser (SvgNode(..), parseToSvgNode)

optimize :: Config -> String -> Aff String
optimize config input = do
  case config.svgoConfig of
    Nothing -> pure input
    Just configFile -> do
      path <- liftEffect $ do
        cwd <- Process.cwd
        Path.resolve [cwd] configFile
      svgo <- SVGO.newSvgo $ Globals.unsafeRequire path
      SVGO.optimize input svgo

handleFile :: Config -> FilePath -> Aff Icon
handleFile config file = do
  buffer <- FS.readFile file
  svgText <- liftEffect $ Buffer.toString UTF8 buffer
  optimized <- optimize config svgText
  case parseToSvgNode optimized of
    Right (SvgElement element) -> do
      pure $
        { name: StringEx.pascalCase $ Path.basenameWithoutExt file ".svg"
        , element
        }
    _ -> Aff.throwError $ Aff.error $ "Failed to parse" <> file

app :: Config -> Aff Unit
app config = do
  icons <- case config.input of
    InputFolder folder -> do
      files <- FS.readdir folder
      let
        svgFiles = map (\f -> Path.concat [folder, f]) $
          Array.filter (\f -> Path.extname f == ".svg") files
      sequence $ map (handleFile config) svgFiles
    InputFile file -> do
      pure <<< Array.singleton =<< handleFile config file
  let
    moduleName = fromMaybe "Icons" config.moduleName
  buffer <- liftEffect $ Buffer.fromString (renderIconFile moduleName icons) UTF8
  FS.writeFile config.output buffer
