module Main exposing (..)

import Html exposing (..)
import Model exposing (Model)
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
              }
            , Ports.getTime ()
            )

        ShuffleDeck timeVal ->
            ( { model | shuffledDeck = Just (Cards.shuffleDeck Cards.initialDeck timeVal) }
            , Cmd.none
            )

        Deal ->
            let
                ( remainingDeck, playerHand, dealerHand ) =
                    Cards.dealCards model.shuffledDeck
            in
                ( { model
                    | shuffledDeck = Just remainingDeck
                    , playerHand = playerHand
                    , dealerHand = dealerHand
                  }
                , Cmd.none
                )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.loadTime mapLoadTime


mapLoadTime : Int -> Msg
mapLoadTime timeVal =
    ShuffleDeck timeVal
