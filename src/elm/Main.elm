module Main exposing (..)

import Html exposing (..)
import Model exposing (Model, WhoseTurn(..))
import Messages exposing (..)
import Cards exposing (Card, removeCard, getDeckTopCard)
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
                    }

        {--
                ({ model
                    | discardPile = card :: model.discardPile
                    , playerHand = newPlayerHand
                 }
                    Cmd.none
                )
                --}
        DealersTurn ->
            if List.length model.playerHand == 0 then
                ( { model
                    | message = "You Win!!!"
                    , whoseTurn = None
                  }
                , Cmd.none
                )
            else
                model ! []


drawCard : Model -> Model
drawCard model =
    let
        drawnCard =
            getDeckTopCard model.shuffledDeck
    in
        case drawnCard of
            Nothing ->
                model

            Just card ->
                let
                    newModel =
                        reshuffleIfNecessary model
                in
                    { newModel | playerHand = card :: newModel.playerHand }


reshuffleIfNecessary : Model -> Model
reshuffleIfNecessary model =
    case List.tail model.shuffledDeck of
        Nothing ->
            let
                newDeck =
                    List.tail model.discardPile

                cardOnTopOfDiscardPile =
                    getDeckTopCard model.discardPile
            in
                case newDeck of
                    Nothing ->
                        { model
                            | shuffledDeck = []
                        }

                    Just aNewDeck ->
                        case cardOnTopOfDiscardPile of
                            Nothing ->
                                { model
                                    | shuffledDeck = aNewDeck
                                }

                            Just card ->
                                { model
                                    | shuffledDeck = aNewDeck
                                    , discardPile = [ card ]
                                }

        Just restOfDeck ->
            { model
                | shuffledDeck = restOfDeck
            }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.loadTime mapLoadTime


mapLoadTime : Int -> Msg
mapLoadTime timeVal =
    ShuffleDeckAndDeal timeVal
