{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE FlexibleContexts #-}
module Lib
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Database.Persist.Postgresql (SqlBackend)
import Data.Pool (Pool, withResource)
import Control.Monad.Trans.Control (MonadBaseControl)

data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''User)

type UserAPI = "api" :> "users" :> Get '[JSON] [User]
type StaticAPI = Raw
type WebAPI = UserAPI :<|> StaticAPI

startApp :: Pool SqlBackend -> IO ()
startApp pool = run 8080 $ app pool

app :: Pool SqlBackend -> Application
app pool = serve api $ userHandler' :<|> serveDirectoryFileServer "../front-end/build"
    where withConnection0 :: MonadBaseControl IO m => (Pool a) -> (a -> m b) -> m b
          withConnection0 pool handler = withResource pool handler
          userHandler' = withConnection0 pool userHandler

api :: Proxy WebAPI
api = Proxy

userHandler :: SqlBackend -> Handler [User]
userHandler sqlBackend = return users

users :: [User]
users = [ User 1 "Isaac" "Newton"
        , User 2 "Albert" "Einstein"
        ]
