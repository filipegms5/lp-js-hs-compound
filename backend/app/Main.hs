{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Web.Scotty
import Data.Aeson (FromJSON, ToJSON, object, (.=))
import GHC.Generics
import Network.Wai.Middleware.Cors
import qualified Data.Text.Lazy as TL
import Control.Monad.IO.Class (liftIO)
import Network.HTTP.Types.Status (status400, status200)
import System.Environment (lookupEnv)
import Text.Read (readMaybe)

-- Tipos de dados para a API
data CompoundRequest = CompoundRequest
  { principal :: Double
  , rate :: Double
  , timesPerYear :: Int
  , years :: Double
  } deriving (Show, Generic)

instance FromJSON CompoundRequest
instance ToJSON CompoundRequest

data CompoundResponse = CompoundResponse
  { amount :: Double
  , interest :: Double
  , inputs :: CompoundRequest
  } deriving (Show, Generic)

instance ToJSON CompoundResponse

data ErrorResponse = ErrorResponse
  { error :: String
  , message :: String
  } deriving (Show, Generic)

instance ToJSON ErrorResponse

-- Função para calcular juros compostos
-- Fórmula: A = P * (1 + r/n)^(n*t)
calculateCompound :: CompoundRequest -> Either String CompoundResponse
calculateCompound req
  | principal req <= 0 = Left "O valor principal deve ser maior que zero"
  | rate req < 0 = Left "A taxa de juros não pode ser negativa"
  | timesPerYear req < 1 = Left "A frequência de composição deve ser pelo menos 1"
  | years req <= 0 = Left "O período em anos deve ser maior que zero"
  | otherwise = Right $ CompoundResponse
      { amount = finalAmount
      , interest = finalAmount - principal req
      , inputs = req
      }
  where
    p = principal req
    r = rate req
    n = fromIntegral (timesPerYear req)
    t = years req
    finalAmount = p * ((1 + r / n) ** (n * t))

-- Configuração de CORS
corsPolicy :: CorsResourcePolicy
corsPolicy = CorsResourcePolicy
  { corsOrigins = Nothing  -- Permite todas as origens
  , corsMethods = ["GET", "POST", "OPTIONS"]
  , corsRequestHeaders = ["Content-Type"]
  , corsExposedHeaders = Nothing
  , corsMaxAge = Just 3600
  , corsVaryOrigin = False
  , corsRequireOrigin = False
  , corsIgnoreFailures = False
  }

main :: IO ()
main = do
  -- Lê a porta das variáveis de ambiente ou usa 8080 como padrão
  portStr <- lookupEnv "PORT"
  let port = maybe 8080 id (portStr >>= readMaybe)

  putStrLn $ "🚀 Servidor iniciado na porta " ++ show port
  putStrLn "📊 Endpoint: POST /api/compound"

  scotty port $ do
    -- Middleware CORS
    middleware $ cors (const $ Just corsPolicy)

    -- Rota de health check
    get "/" $ do
      status status200
      json $ object
        [ "status" .= ("ok" :: String)
        , "service" .= ("Compound Interest API" :: String)
        , "version" .= ("1.0.0" :: String)
        ]

    -- Rota principal para calcular juros compostos
    post "/api/compound" $ do
      req <- jsonData :: ActionM CompoundRequest
      liftIO $ putStrLn $ "📥 Requisição recebida: " ++ show req

      case calculateCompound req of
        Right response -> do
          status status200
          json response
          liftIO $ putStrLn $ "✅ Resposta enviada: " ++ show response

        Left errMsg -> do
          status status400
          json $ ErrorResponse
            { Main.error = "ValidationError"
            , Main.message = errMsg
            }
          liftIO $ putStrLn $ "❌ Erro de validação: " ++ errMsg

    -- Tratamento de erros gerais
    defaultHandler $ \str -> do
      status status400
      json $ ErrorResponse
        { Main.error = "BadRequest"
        , Main.message = TL.unpack str
        }
