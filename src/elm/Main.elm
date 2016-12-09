module Main exposing (..)

import Html exposing (..)
import Model exposing (Model, WhoseTurn(..))
import Update
import Messages exposing (..)
import Ports
import View


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = Model.init
        , view = View.view
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
