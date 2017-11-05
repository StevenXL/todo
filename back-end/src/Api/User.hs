{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Api.User where

import Database.Persist.Postgresql (Entity)
import Models (User)
import Servant

type GetUser = "api" :> "users" :> Get '[ JSON] [Entity User]

type UserAPI = GetUser
