{-# LANGUAGE OverloadedStrings #-}
module Features.UserCanSeePageSpec where

import Test.Hspec.WebDriver

main :: IO ()
main = hspec spec

chromeOnly :: [Capabilities]
chromeOnly = [chromeCaps]

spec :: Spec
spec = do
    describe "home page" $ do
        session "visiting home page" $ using chromeOnly $ do
            it "home page loads" $ runWD $
                openPage "localhost:3000"
