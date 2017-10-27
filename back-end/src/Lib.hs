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
import Database.Persist.Postgresql (Entity, SqlBackend, selectList, runSqlPool)
import Data.Pool (Pool)
import Models

type UserAPI = "api" :> "users" :> Get '[JSON] [Entity User]
type StaticAPI = Raw
type WebAPI = UserAPI :<|> StaticAPI

startApp :: Pool SqlBackend -> IO ()
startApp pool = run 8080 $ app pool

app :: Pool SqlBackend -> Application
app pool = serve api $ userHandler' :<|> serveDirectoryFileServer "../front-end/build"
    where userHandler' = userHandler pool

api :: Proxy WebAPI
api = Proxy

userHandler :: Pool SqlBackend -> Handler [Entity User]
userHandler pool = runSqlPool (selectList [] []) pool
