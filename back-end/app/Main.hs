{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Control.Monad.Logger (runStdoutLoggingT)
import Data.Pool (Pool)
import Database.Persist.Postgresql
       (ConnectionString, SqlBackend, createPostgresqlPool, insert,
        runMigration, runSqlPool)
import Lib (startApp)
import Models (User(..), migrateAll)

main :: IO ()
main = do
    pool <- runStdoutLoggingT $ createPostgresqlPool connStr 1
    runSqlPool (runMigration migrateAll) pool
    startApp pool

connStr :: ConnectionString
connStr =
    "host=localhost port=5432 user=postgres dbname=servanttest password=test"
