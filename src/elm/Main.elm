module Main exposing (..)

import Html exposing (..)
import Model exposing (Model, WhoseTurn(..))
import Messages exposing (..)
import Cards exposing (Card)
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
                | shuffledDeck = Nothing
                , playerHand = []
                , dealerHand = []
                , whoseTurn = None
              }
            , Ports.getTime ()
            )

        ShuffleDeckAndDeal timeVal ->
            let
                shuffledDeck =
                    Just (Cards.shuffleDeck Cards.initialDeck timeVal)

                ( remainingDeck, playerHand, dealerHand, discardPile ) =
                    Cards.dealCards shuffledDeck
            in
                ( { model
                    | shuffledDeck = Just remainingDeck
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
                ( { model
                    | discardPile = card :: model.discardPile
                    , playerHand = newPlayerHand
                  }
                , Cmd.none
                )

        DealersTurn ->
            model ! []


removeCard : Card -> List Card -> List Card
removeCard card hand =
    List.filter ((/=) card) hand


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
                case model.shuffledDeck of
                    Nothing ->
                        model

                    Just deck ->
                        { model
                            | shuffledDeck = List.tail deck
                            , playerHand = card :: model.playerHand
                        }


getDeckTopCard : Maybe (List Card) -> Maybe Card
getDeckTopCard maybeDeck =
    case maybeDeck of
        Nothing ->
            Nothing

        Just deck ->
            List.head deck



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.loadTime mapLoadTime


mapLoadTime : Int -> Msg
mapLoadTime timeVal =
    ShuffleDeckAndDeal timeVal
