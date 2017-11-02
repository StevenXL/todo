{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DeriveGeneric #-}

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
import GHC.Generics
import Data.ByteString.Char8

data Todo = Todo { description :: String} deriving (Eq, Show, Generic)

instance ToJSON Todo

todos :: [Todo]
todos = [Todo "Make Coffee", Todo "Make Code"]

--
newtype AuthedData = AuthedData String
--
type UserAPI = "api" :> "users" :> Get '[JSON] [Entity User]
type TodoAPI = "api" :> "todos" :> BasicAuth "todos" AuthedData :> Get '[JSON] [Todo]
type StaticAPI = Raw
type WebAPI = UserAPI :<|> TodoAPI :<|> StaticAPI

startApp :: Pool SqlBackend -> IO ()
startApp pool = run 8080 $ app pool

app :: Pool SqlBackend -> Application
app pool = serveWithContext api context (userHandler' :<|> todoHandler :<|> serveDirectoryFileServer "../front-end/build")
    where userHandler' = userHandler pool
          todoHandler authedData = return todos
          context :: Context (BasicAuthCheck AuthedData ': '[])
          context = authCheck :. EmptyContext

authCheck = let check (BasicAuthData username password) = do
                    Prelude.putStrLn $ unpack username
                    Prelude.putStrLn $ unpack password
                    return (Authorized (AuthedData "Hello"))
            in BasicAuthCheck check

api :: Proxy WebAPI
api = Proxy

userHandler :: Pool SqlBackend -> Handler [Entity User]
userHandler pool = runSqlPool (selectList [] []) pool
