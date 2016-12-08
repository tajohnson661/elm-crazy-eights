module Model exposing (Model, init, WhoseTurn(..))

import Cards exposing (Card, Suit)
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
    , currentSuit : Suit
    , whoseTurn : WhoseTurn
    , message : String
    , showDialog : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { shuffledDeck = []
      , playerHand = []
      , dealerHand = []
      , discardPile = []
      , currentSuit = 'H'
      , whoseTurn = None
      , message = ""
      , showDialog = False
      }
    , Cmd.none
    )
