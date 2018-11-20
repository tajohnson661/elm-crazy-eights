module Model exposing (Model, init)

import Cards exposing (Card, Suit(..))
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


init : Int -> ( Model, Cmd Msg )
init flags =
    ( { shuffledDeck = []
      , playerHand = []
      , dealerHand = []
      , discardPile = []
      , currentSuit = Hearts
      , inProgress = False
      , message = "Welcome to Crazy Eights"
      , showDialog = False
      }
    , Cmd.none
    )
