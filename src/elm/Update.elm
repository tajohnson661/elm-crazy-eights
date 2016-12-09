module Update exposing (update)

import Model exposing (Model, WhoseTurn(..))
import Messages exposing (..)
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
            ( drawCard model, Cmd.none )

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

        Acknowledge suit ->
            update DealersTurn
                { model
                    | showDialog = False
                    , currentSuit = suit
                }


playerPlaysCard : Card -> Model -> ( Model, Cmd Msg )
playerPlaysCard card model =
    let
        newPlayerHand =
            Cards.removeCard card model.playerHand
    in
        if (Cards.getFaceFromCard card) == 8 then
            ( askUserForSuit
                { model
                    | discardPile = card :: model.discardPile
                    , playerHand = newPlayerHand
                }
            , Cmd.none
            )
        else
            update DealersTurn
                { model
                    | discardPile = card :: model.discardPile
                    , playerHand = newPlayerHand
                    , currentSuit = Cards.getSuitFromCard card
                }


askUserForSuit : Model -> Model
askUserForSuit model =
    { model
        | showDialog = True
    }
