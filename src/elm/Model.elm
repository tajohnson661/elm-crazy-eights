module Model exposing (Model, init, WhoseTurn(..))

import Cards exposing (Card)
import Messages exposing (..)


-- MODEL


type WhoseTurn
    = Player
    | Dealer
    | None


type alias Model =
    { shuffledDeck : Maybe (List Card)
    , playerHand : List Card
    , dealerHand : List Card
    , discardPile : List Card
    , whoseTurn : WhoseTurn
    }


init : ( Model, Cmd Msg )
init =
    ( { shuffledDeck = Nothing
      , playerHand = []
      , dealerHand = []
      , discardPile = []
      , whoseTurn = None
      }
    , Cmd.none
    )
