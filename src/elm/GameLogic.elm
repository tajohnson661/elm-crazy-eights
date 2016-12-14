module GameLogic exposing (..)

import Cards exposing (Card, Face, Suit)
import Model exposing (Model)
import Utils exposing (postMessage)
import Messages exposing (..)


isCardPlayable : Maybe Card -> Suit -> Card -> Bool
isCardPlayable maybeTopOfDiscard currentSuit card =
    case maybeTopOfDiscard of
        Nothing ->
            False

        Just topOfDiscard ->
            if Cards.getFaceFromCard card == 8 then
                True
            else if Cards.getFaceFromCard card == Cards.getFaceFromCard topOfDiscard then
                True
            else if Cards.getSuitFromCard card == currentSuit then
                True
            else
                False


dealerPlays : Model -> Model
dealerPlays model =
    let
        cardToPlay =
            model.dealerHand
                |> List.filter (isCardPlayable (List.head model.discardPile) model.currentSuit)
                |> List.sortWith eightsCompare
                |> List.head
    in
        case cardToPlay of
            Nothing ->
                dealerPlays (dealerDraws model)

            Just card ->
                dealerPlaysCard card model


dealerDraws : Model -> Model
dealerDraws model =
    let
        drawnCard =
            Cards.getDeckTopCard model.shuffledDeck
    in
        case drawnCard of
            Nothing ->
                model

            Just card ->
                let
                    newModel =
                        reshuffleIfDeckEmpty model
                in
                    { newModel | dealerHand = card :: newModel.dealerHand }


playerDraws : Model -> Model
playerDraws model =
    let
        drawnCard =
            Cards.getDeckTopCard model.shuffledDeck
    in
        case drawnCard of
            Nothing ->
                model

            Just card ->
                let
                    newModel =
                        reshuffleIfDeckEmpty model
                in
                    { newModel
                        | playerHand = card :: newModel.playerHand
                        , message = "You drew the " ++ (Cards.toFullString card)
                    }


dealerPlaysCard : Card -> Model -> Model
dealerPlaysCard card model =
    let
        newDealerHand =
            Cards.removeCard card model.dealerHand

        newModel =
            { model
                | discardPile = card :: model.discardPile
                , dealerHand = newDealerHand
                , message = "Dealer plays the " ++ (Cards.toFullString card)
            }
    in
        if Cards.getFaceFromCard card == 8 then
            { newModel | currentSuit = Cards.getMostProlificSuit newModel.dealerHand }
        else
            { newModel | currentSuit = Cards.getSuitFromCard card }


playerPlaysCard : Card -> Model -> ( Model, Cmd Msg )
playerPlaysCard card model =
    let
        newPlayerHand =
            Cards.removeCard card model.playerHand

        newModel =
            { model
                | discardPile = card :: model.discardPile
                , playerHand = newPlayerHand
                , message = ""
            }
    in
        if (Cards.getFaceFromCard card) == 8 then
            ( askUserForSuit
                newModel
            , Cmd.none
            )
        else
            ( { newModel
                | currentSuit = Cards.getSuitFromCard card
              }
            , Utils.postMessage DealersTurn
            )


reshuffleIfDeckEmpty : Model -> Model
reshuffleIfDeckEmpty model =
    case List.tail model.shuffledDeck of
        Nothing ->
            model

        Just restOfDeck ->
            if List.length restOfDeck == 0 then
                reshuffle model
            else
                { model
                    | shuffledDeck = restOfDeck
                }


reshuffle : Model -> Model
reshuffle model =
    let
        newDeck =
            List.tail model.discardPile

        cardOnTopOfDiscardPile =
            Cards.getDeckTopCard model.discardPile
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
                            | shuffledDeck =
                                Cards.shuffleDeck aNewDeck 1481219015621
                            , discardPile = [ card ]
                        }


getCurrentSuitFromDiscard : List Card -> Suit
getCurrentSuitFromDiscard cards =
    let
        topOfCards =
            List.head cards
    in
        case topOfCards of
            Nothing ->
                'H'

            Just card ->
                Cards.getSuitFromCard card


askUserForSuit : Model -> Model
askUserForSuit model =
    { model
        | showDialog = True
    }



{--
    Move eights to the end of the list... play them last
--}


eightsCompare : Card -> Card -> Order
eightsCompare a b =
    case ( Tuple.first a, Tuple.first b ) of
        ( 8, 8 ) ->
            EQ

        ( 8, _ ) ->
            GT

        ( _, 8 ) ->
            LT

        _ ->
            EQ
