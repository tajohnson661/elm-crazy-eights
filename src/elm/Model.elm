module Model exposing (Model, init)

import Cards exposing (Card, Suit)
import Messages exposing (..)


-- MODEL


type alias Model =
    { shuffledDeck : List Card
    , playerHand : List Card
    , dealerHand : List Card
    , discardPile : List Card
    , currentSuit : Suit
    , inProgress : Bool
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
      , inProgress = False
      , message = "Welcome to Crazy Eights"
      , showDialog = False
      }
    , Cmd.none
    )
