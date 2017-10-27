{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Lib (startApp)
import Models (migrateAll)
import Database.Persist.Postgresql (ConnectionString, createPostgresqlPool, SqlBackend, runMigration, runSqlPool)
import Data.Pool (Pool)
import Control.Monad.Logger

main :: IO ()
main = do
    pool <- (createPostgresqlPool connStr 1) :: IO (Pool SqlBackend)
    runSqlPool (runMigration migrateAll) pool
    startApp pool

connStr :: ConnectionString
connStr = "host=localhost port=5432 user=postgres dbname=test password=test"

instance MonadLogger IO where
    monadLoggerLog _ _ _ _ = putStrLn "Soemthing got logged"
