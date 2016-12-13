module View exposing (view)

import Model exposing (Model, WhoseTurn(..))
import Messages exposing (..)
import Html exposing (Html, div, text, button, span, p, img, h2, h3, h4, h5, ul, li, nav, a, i, footer)
import Html.Attributes exposing (class, style, src, href, id, attribute)
import Html.Events exposing (onClick)
import Cards exposing (Card, Suit, Face, getSuitFromCard, getFaceFromCard)
import GameLogic exposing (..)
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
            [ a [ id "logo-container", href "#", class "brand-logo" ] [ text "Crazy Eights" ]
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
                [ div [ class "col l6 s12" ]
                    [ h5 [ class "white-text" ] [ text "Company Bio" ]
                    , p [ class "grey-text text-lighten-4" ] [ text "TJ Enterprises" ]
                    ]
                , div [ class "col l3 s12" ]
                    [ text "hi" ]
                , div [ class "col l3 s12" ]
                    [ text "hi again" ]
                ]
            ]
        , div [ class "footer-copyright" ]
            [ div [ class "container" ]
                [ span [] [ text "Made by me" ] ]
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    let
        compareCard =
            List.head model.discardPile
    in
        case model.whoseTurn of
            Player ->
                div [ class "container playingCards simpleCards" ]
                    [ viewDealerHand model.dealerHand
                    , viewMiddleSection model
                    , Dialog.view
                        (if model.showDialog then
                            Just (dialogConfig model)
                         else
                            Nothing
                        )
                    , viewPlayerHand model compareCard
                    ]

            _ ->
                div [ class "row center" ]
                    [ div [ class "col s12" ]
                        [ h4 [] [ text model.message ]
                        ]
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


viewDrawCard : Model -> Html Msg
viewDrawCard model =
    if List.length model.shuffledDeck == 0 then
        empty
    else
        div [ class "pCard back right", onClick DrawCard ] [ text "*" ]


viewMiddleSection : Model -> Html Msg
viewMiddleSection model =
    div []
        [ div [ class "row center" ]
            [ div [ class "col s12" ]
                [ h4 [] [ text model.message ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col s12 m5" ]
                [ viewDrawCard model ]
            , div [ class "col s12 m2" ]
                [ viewDiscardPile model.discardPile ]
            , div [ class "col s12 m5" ]
                [ viewCurrentSuit model.currentSuit ]
            ]
        ]


viewDealerHand : List Card -> Html Msg
viewDealerHand hand =
    div []
        [ div [ class "row center" ]
            [ h2 [ class "header col s12 orange-text" ] [ text "Dealer hand" ] ]
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
            [ h2 [ class "header col s12 orange-text" ] [ text "Player hand" ] ]
        , div [ class "row center" ]
            (List.map (viewCard compareCard model.currentSuit model.whoseTurn) model.playerHand)
        ]


viewCard : Maybe Card -> Suit -> WhoseTurn -> Card -> Html Msg
viewCard compareCard currentSuit whoseTurn card =
    div [ class "player-card" ]
        [ paintCard card
        ]


paintCard : Card -> Html Msg
paintCard card =
    let
        ( suitClass, suitText ) =
            getSuitPaintInfoFromSuit (getSuitFromCard card)

        ( faceClass, faceText ) =
            getFacePaintInfoFromFace (getFaceFromCard card)

        classText =
            "pCard " ++ faceClass ++ " " ++ suitClass
    in
        div [ class classText, onClick (PlayCard card) ]
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


imageFromSuit : Suit -> String
imageFromSuit suit =
    case suit of
        'H' ->
            "static/img/heart.png"

        'S' ->
            "static/img/spade.png"

        'C' ->
            "static/img/club.gif"

        'D' ->
            "static/img/diamond.png"

        _ ->
            "static/img/heart1.png"


viewDiscardPile : List Card -> Html Msg
viewDiscardPile discardPile =
    case (List.head discardPile) of
        Nothing ->
            empty

        Just card ->
            paintCard card


viewCurrentSuit : Suit -> Html Msg
viewCurrentSuit suit =
    -- paintCard ( 0, suit )
    let
        ( suitClass, suitText ) =
            getSuitPaintInfoFromSuit suit

        classText =
            "pCard " ++ suitClass
    in
        div [ class classText ]
            [ span [ class "rank" ] [ text "" ]
            , span [ class "suit" ] [ text suitText ]
            ]


toFaceName : Int -> String
toFaceName faceValue =
    case faceValue of
        1 ->
            "Ace"

        11 ->
            "Jack"

        12 ->
            "Queen"

        13 ->
            "King"

        _ ->
            (toString faceValue)



-- CSS STYLES in line... really just to see how it's done.  Should be in CSS file


styles : { img : List ( String, String ) }
styles =
    { img =
        [ ( "width", "20px" )
        , ( "height", "20px" )
        , ( "margin", "4px" )
        ]
    }


empty : Html Msg
empty =
    span [] []
