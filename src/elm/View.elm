module View exposing (view)

import Model exposing (Model)
import Messages exposing (..)
import Html exposing (Html, div, text, button, span, p, img, h3, ul, li)
import Html.Attributes exposing (class, style, src)
import Html.Events exposing (onClick)
import Cards exposing (Card, Suit)


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    div [ class "container", style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
        [ -- inline CSS (literal)
          div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "jumbotron" ]
                    [ button [ class "btn btn-primary btn-lg", onClick StartShuffle ]
                        [ -- click handler
                          span [ class "glyphicon glyphicon-star" ] []
                          -- glyphicon
                        , span [] [ text "New game" ]
                        ]
                    , viewDiscardPile model.discardPile
                    ]
                ]
            ]
        , h3 [] [ text "Player Hand " ]
        , div [ class "row" ]
            [ viewHand model.playerHand ]
        ]


viewHand : List Card -> Html Msg
viewHand hand =
    ul [ class "list-group" ]
        (List.map viewCard hand)


viewCard : Card -> Html Msg
viewCard card =
    li [ class "list-group-item" ]
        [ text ((toFace (Tuple.first card)) ++ " of " ++ (toSuit (Tuple.second card)))
        , img [ src (imageFromSuit (Tuple.second card)), style styles.img ] []
        , button [ class "btn btn-primary" ] [ text "Play this card" ]
        ]


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
            div [] []

        Just card ->
            div [] [ text ((toFace (Tuple.first card)) ++ " of " ++ (toSuit (Tuple.second card))) ]


toFace : Int -> String
toFace faceValue =
    case faceValue of
        1 ->
            "Ace"

        2 ->
            "Two"

        3 ->
            "Three"

        4 ->
            "Four"

        5 ->
            "Five"

        6 ->
            "Six"

        7 ->
            "Seven"

        8 ->
            "Eight"

        9 ->
            "Nine"

        10 ->
            "Ten"

        11 ->
            "Jack"

        12 ->
            "Queen"

        13 ->
            "King"

        _ ->
            "Other"


toSuit : Char -> String
toSuit suitValue =
    case suitValue of
        'H' ->
            "Hearts"

        'D' ->
            "Diamonds"

        'S' ->
            "Spades"

        'C' ->
            "Clubs"

        _ ->
            "Unknown"



-- CSS STYLES


styles : { img : List ( String, String ) }
styles =
    { img =
        [ ( "width", "20px" )
        , ( "height", "20px" )
        , ( "border", "1px solid #337AB7" )
        ]
    }
