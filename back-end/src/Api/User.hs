{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module Api.User where

import Data.Aeson
import Database.Persist.Postgresql (Entity)
import GHC.Generics
import Models (User)
import Servant

data CreateUserReq = CreateUserReq
    { firstName :: String
    , lastName :: String
    , email :: String
    , password :: String
    } deriving (Generic, Show)

instance FromJSON CreateUserReq

type GetUser = "api" :> "users" :> Get '[ JSON] [Entity User]

type CreateUser
     = "api" :> "users" :> ReqBody '[ JSON] CreateUserReq :> Post '[ JSON] User

type UserAPI = GetUser :<|> CreateUser
