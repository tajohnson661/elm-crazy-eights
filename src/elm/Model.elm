module Model exposing (Model, init)

import Cards exposing (Card)
import Messages exposing (..)


-- MODEL


type WhoseTurn
    = Player
    | Dealer


type alias Model =
    { shuffledDeck : Maybe (List Card)
    , playerHand : List Card
    , dealerHand : List Card
    , discardPile : List Card
    , whoseTurn : WhoseTurn
    , inProgress : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { shuffledDeck = Nothing
      , playerHand = []
      , dealerHand = []
      , discardPile = []
      , whoseTurn = Player
      , inProgress = False
      }
    , Cmd.none
    )
