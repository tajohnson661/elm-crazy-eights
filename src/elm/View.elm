module View exposing (view)

import Model exposing (Model)
import Messages exposing (..)
import Html exposing (Html, div, text, button, span, p, img, h2, h3, h4, h5, h6, ul, li, nav, a, i, footer)
import Html.Attributes exposing (class, style, src, href, id, attribute)
import Html.Events exposing (onClick)
import Cards exposing (Card, Suit, Face, getSuitFromCard, getFaceFromCard, sortHand)
import Dialog


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    div []
        [ viewHeader model
        , viewBody model
        , viewFooter model
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    nav [ class "light-blue lighten-1", attribute "role" "navigation" ]
        [ div [ class "nav-wrapper container" ]
            [ a [ id "logo-container", href "/", class "brand-logo" ] [ text "Crazy Eights" ]
            , ul [ class "right hide-on-med-and-down" ]
                [ li []
                    [ a [ onClick StartShuffle ] [ text "New game" ] ]
                ]
            , ul [ id "nav-mobile", class "side-nav" ]
                [ li []
                    [ a [ onClick StartShuffle ] [ text "New game" ] ]
                ]
            , a [ href "#", attribute "data-activates" "nav-mobile", class "button-collapse" ]
                [ i [ class "material-icons" ] [ text "menu" ] ]
            ]
        ]


viewFooter : Model -> Html Msg
viewFooter model =
    footer [ class "page-footer orange" ]
        [ div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col l6 s12 white-text extra-footer-stuff" ]
                    [ span [] [ text "Tom Johnson" ]
                    , span [] [ a [ href "https://github.com/tajohnson661" ] [ text " github:@tajohnson661" ] ]
                    ]
                , div [ class "col l4" ] []
                , div [ class "col l2 s12 white-text" ]
                    [ text "Copyright 2016" ]
                ]
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    let
        compareCard =
            List.head model.discardPile
    in
        case model.inProgress of
            True ->
                div [ class "container playingCards simpleCards" ]
                    [ div [ class "on-top" ]
                        [ Dialog.view
                            (if model.showDialog then
                                Just (dialogConfig model)
                             else
                                Nothing
                            )
                        ]
                    , viewDealerHand model.dealerHand
                    , viewMiddleSection model
                    , viewMessage model
                    , viewPlayerHand model compareCard
                    ]

            False ->
                div [ class "row center initial-screen" ]
                    [ viewMessage model
                    , button [ class "btn btn-large btn-success", onClick StartShuffle ] [ text "Click to start" ]
                    ]


dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    { closeMessage = Nothing
    , containerClass = Nothing
    , header = Just (h3 [] [ text "Select a suit..." ])
    , body = Just (text "You get to change the suit.  Have fun!")
    , footer =
        Just
            (div []
                [ button
                    [ class "btn btn-success"
                    , onClick (Acknowledge 'H')
                    ]
                    [ text "Hearts" ]
                , button
                    [ class "btn btn-success"
                    , onClick (Acknowledge 'C')
                    ]
                    [ text "Clubs" ]
                , button
                    [ class "btn btn-success"
                    , onClick (Acknowledge 'D')
                    ]
                    [ text "Diamonds" ]
                , button
                    [ class "btn btn-success"
                    , onClick (Acknowledge 'S')
                    ]
                    [ text "Spades" ]
                ]
            )
    }


viewMiddleSection : Model -> Html Msg
viewMiddleSection model =
    div []
        [ div [ class "row" ]
            [ div [ class "col m3" ] []
            , div [ class "col s12 m6" ]
                [ div [ class "row middle-section grey lighten-3" ]
                    [ div [ class "col s4 m4" ]
                        [ viewDrawCard model ]
                    , div [ class "col s4 m4" ]
                        [ viewDiscardPile model.discardPile ]
                    , div [ class "col s4 m4" ]
                        [ viewCurrentSuit model.currentSuit ]
                    ]
                ]
            , div [ class "col m3" ] []
            ]
        ]


viewDrawCard : Model -> Html Msg
viewDrawCard model =
    if List.length model.shuffledDeck == 0 then
        empty
    else
        div [ class "pCard back right pointer", onClick DrawCard ] [ text "*" ]


viewMessage : Model -> Html Msg
viewMessage model =
    div [ class "row center " ]
        [ div [ class "col m3" ] []
        , div [ class "col s12 m6 grey lighten-3 message-area" ]
            [ h5 [] [ text model.message ]
            ]
        , div [ class "col m6" ] []
        ]


viewDealerHand : List Card -> Html Msg
viewDealerHand hand =
    div []
        [ div [ class "row center" ]
            [ h4 [ class "header col s12 orange-text" ] [ text "Dealer" ] ]
        , div [ class "row center" ]
            (List.map paintBack hand)
        ]


paintBack : Card -> Html Msg
paintBack card =
    div [ class "pCard back" ] [ text "*" ]


viewPlayerHand : Model -> Maybe Card -> Html Msg
viewPlayerHand model compareCard =
    div []
        [ div [ class "row center" ]
            (List.map viewCard (Cards.sortHand model.playerHand))
        , div [ class "row center" ]
            [ h4 [ class "header col s12 orange-text" ] [ text "Player" ] ]
        ]


viewCard : Card -> Html Msg
viewCard card =
    div [ class "player-card" ]
        [ paintCard card True
        ]


viewDiscardPile : List Card -> Html Msg
viewDiscardPile discardPile =
    case (List.head discardPile) of
        Nothing ->
            empty

        Just card ->
            paintCard card False


viewCurrentSuit : Suit -> Html Msg
viewCurrentSuit suit =
    let
        ( _, suitText ) =
            getSuitPaintInfoFromSuit suit

        color =
            getColorFromSuit suit
    in
        div [ class "current-suit", style [ ( "color", color ) ] ]
            [ text suitText ]


paintCard : Card -> Bool -> Html Msg
paintCard card allowClick =
    let
        ( suitClass, suitText ) =
            getSuitPaintInfoFromSuit (getSuitFromCard card)

        ( faceClass, faceText ) =
            getFacePaintInfoFromFace (getFaceFromCard card)

        classText =
            "pCard " ++ faceClass ++ " " ++ suitClass
    in
        if allowClick then
            div [ class ("pointer " ++ classText), onClick (PlayCard card) ]
                [ span [ class "rank" ] [ text faceText ]
                , span [ class "suit" ] [ text suitText ]
                ]
        else
            div [ class classText ]
                [ span [ class "rank" ] [ text faceText ]
                , span [ class "suit" ] [ text suitText ]
                ]


getSuitPaintInfoFromSuit : Suit -> ( String, String )
getSuitPaintInfoFromSuit suit =
    case suit of
        'H' ->
            ( "hearts", "♥" )

        'D' ->
            ( "diams", "♦" )

        'C' ->
            ( "clubs", "♣" )

        'S' ->
            ( "spades", "♠" )

        _ ->
            ( "spades", "♠" )


getFacePaintInfoFromFace : Face -> ( String, String )
getFacePaintInfoFromFace faceValue =
    case faceValue of
        1 ->
            ( "rank-a", "A" )

        11 ->
            ( "rank-j", "J" )

        12 ->
            ( "rank-q", "Q" )

        13 ->
            ( "rank-k", "K" )

        _ ->
            ( "rank-" ++ toString faceValue, toString faceValue )


getColorFromSuit : Suit -> String
getColorFromSuit suit =
    case suit of
        'H' ->
            "red"

        'D' ->
            "red"

        _ ->
            "black"


empty : Html Msg
empty =
    span [] []
