module GameLogic exposing (..)

import Cards exposing (Card, Face, Suit)
import Model exposing (Model, WhoseTurn(..))


isCardPlayable : Maybe Card -> Card -> Bool
isCardPlayable maybeTopOfDiscard card =
    case maybeTopOfDiscard of
        Nothing ->
            False

        Just topOfDiscard ->
            if Cards.getFaceFromCard card == 8 then
                True
            else if Cards.getFaceFromCard card == Cards.getFaceFromCard topOfDiscard then
                True
            else if Cards.getSuitFromCard card == Cards.getSuitFromCard topOfDiscard then
                True
            else
                False


dealerPlays : Model -> Model
dealerPlays model =
    let
        playableList =
            List.filter (isCardPlayable (List.head model.discardPile)) model.dealerHand

        cardToPlay =
            List.head playableList
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
                        reshuffleIfNecessary model
                in
                    { newModel | dealerHand = card :: newModel.dealerHand }


dealerPlaysCard : Card -> Model -> Model
dealerPlaysCard card model =
    let
        _ =
            Debug.log "dealerPlaysCard" card

        newDealerHand =
            Cards.removeCard card model.dealerHand
    in
        { model
            | discardPile = card :: model.discardPile
            , dealerHand = newDealerHand
        }


drawCard : Model -> Model
drawCard model =
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
                        reshuffleIfNecessary model
                in
                    { newModel | playerHand = card :: newModel.playerHand }


reshuffleIfNecessary : Model -> Model
reshuffleIfNecessary model =
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
