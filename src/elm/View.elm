module View exposing (view)

import Model exposing (Model)
import Messages exposing (..)
import Html exposing (Html, div, text, button, span, p, img, h3, ul, li)
import Html.Attributes exposing (class, style, src)
import Html.Events exposing (onClick)
import Cards exposing (Card, Suit, getSuitFromCard, getFaceFromCard, isCardPlayable)


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    let
        compareCard =
            List.head model.discardPile
    in
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
                [ viewHand model.playerHand compareCard ]
            ]


viewHand : List Card -> Maybe Card -> Html Msg
viewHand hand compareCard =
    ul [ class "list-group" ]
        (List.map (viewCard compareCard) hand)


viewCard : Maybe Card -> Card -> Html Msg
viewCard compareCard card =
    li [ class "list-group-item" ]
        [ text (toFaceName (getFaceFromCard card))
        , img [ src (imageFromSuit (getSuitFromCard card)), style styles.img ] []
        , viewPlayButton card compareCard
        ]


viewPlayButton : Card -> Maybe Card -> Html Msg
viewPlayButton card compareCard =
    case isCardPlayable card compareCard of
        True ->
            button [ class "btn btn-primary" ] [ text "Play this card" ]

        False ->
            div [] []


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
            div [ class "discard-pile" ]
                [ text (toFaceName (getFaceFromCard card))
                , img [ src (imageFromSuit (getSuitFromCard card)), style styles.img ] []
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
