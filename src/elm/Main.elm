module Main exposing (..)

import Html exposing (..)
import Model exposing (Model, WhoseTurn(..))
import Messages exposing (..)
import Cards exposing (Card, removeCard, getDeckTopCard)
import GameLogic exposing (..)
import Ports
import View


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = Model.init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        StartShuffle ->
            ( { model
                | shuffledDeck = []
                , playerHand = []
                , dealerHand = []
                , whoseTurn = None
                , message = ""
              }
            , Ports.getTime ()
            )

        ShuffleDeckAndDeal timeVal ->
            let
                shuffledDeck =
                    Cards.shuffleDeck Cards.initialDeck timeVal

                ( remainingDeck, playerHand, dealerHand, discardPile ) =
                    Cards.dealCards shuffledDeck
            in
                ( { model
                    | shuffledDeck = remainingDeck
                    , playerHand = playerHand
                    , dealerHand = dealerHand
                    , discardPile = discardPile
                    , currentSuit = getCurrentSuitFromDiscard discardPile
                    , whoseTurn = Player
                  }
                , Cmd.none
                )

        DrawCard ->
            ( drawCard model, Cmd.none )

        PlayCard card ->
            let
                newPlayerHand =
                    removeCard card model.playerHand
            in
                update DealersTurn
                    { model
                        | discardPile = card :: model.discardPile
                        , playerHand = newPlayerHand
                        , currentSuit = Cards.getSuitFromCard card
                    }

        DealersTurn ->
            if List.length model.playerHand == 0 then
                ( { model
                    | message = "You Win!!!"
                    , whoseTurn = None
                  }
                , Cmd.none
                )
            else
                update DealersTurnDone (dealerPlays model)

        DealersTurnDone ->
            if List.length model.dealerHand == 0 then
                ( { model
                    | message = "Dealer Wins!!!"
                    , whoseTurn = None
                  }
                , Cmd.none
                )
            else
                model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.loadTime mapLoadTime


mapLoadTime : Int -> Msg
mapLoadTime timeVal =
    ShuffleDeckAndDeal timeVal
