module Model exposing (Model, init, WhoseTurn(..))

import Cards exposing (Card)
import Messages exposing (..)


-- MODEL


type WhoseTurn
    = Player
    | Dealer
    | None


type alias Model =
    { shuffledDeck : List Card
    , playerHand : List Card
    , dealerHand : List Card
    , discardPile : List Card
    , whoseTurn : WhoseTurn
    , message : String
    }


init : ( Model, Cmd Msg )
init =
    ( { shuffledDeck = []
      , playerHand = []
      , dealerHand = []
      , discardPile = []
      , whoseTurn = None
      , message = ""
      }
    , Cmd.none
    )
