module Update exposing (update)

import Model exposing (Model, WhoseTurn(..))
import Messages exposing (..)
import Utils exposing (postMessage)
import Cards exposing (Card, removeCard, getDeckTopCard)
import GameLogic exposing (..)
import Ports


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
            ( playerDraws model, Cmd.none )

        PlayCard card ->
            playerPlaysCard card model

        DealersTurn ->
            if List.length model.playerHand == 0 then
                ( { model
                    | message = "You Win!!!"
                    , whoseTurn = None
                  }
                , Cmd.none
                )
            else
                ( dealerPlays model, postMessage DealersTurnDone )

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

        Acknowledge suit ->
            ( { model
                | showDialog = False
                , currentSuit = suit
              }
            , postMessage DealersTurn
            )
