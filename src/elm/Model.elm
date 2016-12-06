module Model exposing (Model, init)

import Cards exposing (Card)
import Messages exposing (..)


-- MODEL


type alias Model =
    { shuffledDeck : Maybe (List Card)
    , playerHand : List Card
    , dealerHand : List Card
    }


init : ( Model, Cmd Msg )
init =
    ( { shuffledDeck = Nothing
      , playerHand = []
      , dealerHand = []
      }
    , Cmd.none
    )
