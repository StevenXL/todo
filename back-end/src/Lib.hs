{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Lib
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''User)

type UserAPI = "api" :> "users" :> Get '[JSON] [User]
type StaticAPI = Raw
type WebAPI = UserAPI :<|> StaticAPI

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy WebAPI
api = Proxy

userHandler :: Handler [User]
userHandler = return users

server :: Server WebAPI
server = userHandler :<|> serveDirectoryFileServer "../front-end/build"

users :: [User]
users = [ User 1 "Isaac" "Newton"
        , User 2 "Albert" "Einstein"
        ]
