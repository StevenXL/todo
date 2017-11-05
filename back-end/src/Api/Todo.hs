{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module Api.Todo where

import Data.Aeson
import GHC.Generics
import Servant

data Todo = Todo
    { description :: String
    } deriving (Eq, Show, Generic)

instance ToJSON Todo

newtype AuthedData =
    AuthedData String

todos :: [Todo]
todos = [Todo "Do Laundry", Todo "Make Coffee"]

type TodoAPI
     = "api" :> "todos" :> BasicAuth "todos" AuthedData :> Get '[ JSON] [Todo]
