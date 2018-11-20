module Update exposing (update)

import Cards exposing (Card, CardsDealt, getDeckTopCard, removeCard)
import GameLogic exposing (..)
import Messages exposing (..)
import Model exposing (Model)
import Ports
import Utils exposing (postMessage)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        StartShuffle ->
            ( { model
                | shuffledDeck = []
                , playerHand = []
                , dealerHand = []
                , inProgress = False
                , message = "To play, click on a card in your hand or draw"
              }
            , Ports.getTime ()
            )

        ShuffleDeckAndDeal timeVal ->
            let
                shuffledDeck =
                    Cards.shuffleDeck Cards.initialDeck timeVal

                { workingCards, playerHand, dealerHand, discardPile } =
                    Cards.dealCards shuffledDeck
            in
            ( { model
                | shuffledDeck = workingCards
                , playerHand = playerHand
                , dealerHand = dealerHand
                , discardPile = discardPile
                , currentSuit = getCurrentSuitFromDiscard discardPile
                , inProgress = True
              }
            , Cmd.none
            )

        DrawCard ->
            ( playerDraws model, Cmd.none )

        PlayCard card ->
            let
                compareCard =
                    List.head model.discardPile
            in
            case isCardPlayable compareCard model.currentSuit card of
                True ->
                    playerPlaysCard card model

                False ->
                    ( { model | message = "You can't play that card" }, Cmd.none )

        DealersTurn ->
            if List.length model.playerHand == 0 then
                ( { model
                    | message = "You Win!!!"
                    , inProgress = False
                  }
                , Cmd.none
                )

            else
                ( dealerPlays model, postMessage DealersTurnDone )

        DealersTurnDone ->
            if List.length model.dealerHand == 0 then
                ( { model
                    | message = "Dealer Wins!!!"
                    , inProgress = False
                  }
                , Cmd.none
                )

            else
                ( model
                , Cmd.none
                )

        Acknowledge suit ->
            ( { model
                | showDialog = False
                , currentSuit = suit
              }
            , postMessage DealersTurn
            )
