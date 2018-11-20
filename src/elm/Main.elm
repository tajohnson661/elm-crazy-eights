module Main exposing (main, mapLoadTime, subscriptions)

import Browser
import Html exposing (..)
import Messages exposing (..)
import Model exposing (Model)
import Ports
import Update
import View



-- APP


main : Program Int Model Msg
main =
    Browser.document
        { init = Model.init
        , view =
            \m ->
                { title = "Crazy Eights with Elm"
                , body = [ View.view m ]
                }
        , update = Update.update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.loadTime mapLoadTime


mapLoadTime : Int -> Msg
mapLoadTime timeVal =
    ShuffleDeckAndDeal timeVal
