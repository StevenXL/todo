{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DeriveGeneric #-}

module Lib
    ( startApp
    , app
    ) where

import Api.Todo
       (AuthedData(AuthedData), Todo(Todo), TodoAPI, todos)
import Api.User (UserAPI)
import Data.Aeson
import Data.Aeson.TH
import Data.ByteString.Char8
import Data.Pool (Pool)
import Database.Persist.Postgresql
       (Entity, SqlBackend, runSqlPool, selectList)
import GHC.Generics
import Models
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

type StaticAPI = Raw

type WebAPI = UserAPI :<|> TodoAPI :<|> StaticAPI

startApp :: Pool SqlBackend -> IO ()
startApp pool = run 8080 $ app pool

app :: Pool SqlBackend -> Application
app pool =
    serveWithContext
        api
        context
        (userHandler' :<|> todoHandler :<|>
         serveDirectoryFileServer "../front-end/build")
  where
    userHandler' = userHandler pool
    todoHandler authedData = return todos
    context :: Context (BasicAuthCheck AuthedData ': '[])
    context = authCheck :. EmptyContext

authCheck =
    let check (BasicAuthData username password) = do
            Prelude.putStrLn $ unpack username
            Prelude.putStrLn $ unpack password
            return (Authorized (AuthedData "Hello"))
    in BasicAuthCheck check

api :: Proxy WebAPI
api = Proxy

userHandler :: Pool SqlBackend -> Handler [Entity User]
userHandler pool = runSqlPool (selectList [] []) pool
