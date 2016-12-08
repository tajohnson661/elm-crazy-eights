module View exposing (view)

import Model exposing (Model, WhoseTurn(..))
import Messages exposing (..)
import Html exposing (Html, div, text, button, span, p, img, h3, h4, ul, li)
import Html.Attributes exposing (class, style, src)
import Html.Events exposing (onClick)
import Cards exposing (Card, Suit, getSuitFromCard, getFaceFromCard)
import GameLogic exposing (..)


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
                        [ h4 [] [ text model.message ]
                        , button [ class "btn btn-primary btn-lg", onClick StartShuffle ]
                            [ -- click handler
                              span [ class "glyphicon glyphicon-star" ] []
                              -- glyphicon
                            , span [] [ text "New game" ]
                            ]
                        , viewDiscardPile model.discardPile
                        , viewCurrentSuit model.currentSuit
                        ]
                    ]
                ]
            , viewDrawCardButton model
            , h3 [] [ text "Player Hand " ]
            , div [ class "row" ]
                [ viewHand model.playerHand compareCard model.currentSuit model.whoseTurn ]
            ]


viewDrawCardButton : Model -> Html Msg
viewDrawCardButton model =
    case model.whoseTurn of
        Player ->
            if List.length model.shuffledDeck == 0 then
                div [] []
            else
                div [ class "row" ]
                    [ button [ class "btn btn-primary btn-lg", onClick DrawCard ] [ text "Draw Card " ] ]

        _ ->
            div [] []


viewHand : List Card -> Maybe Card -> Suit -> WhoseTurn -> Html Msg
viewHand hand compareCard currentSuit whoseTurn =
    ul [ class "list-group" ]
        (List.map (viewCard compareCard currentSuit whoseTurn) hand)


viewCard : Maybe Card -> Suit -> WhoseTurn -> Card -> Html Msg
viewCard compareCard currentSuit whoseTurn card =
    li [ class "list-group-item" ]
        [ text (toFaceName (getFaceFromCard card))
        , img [ src (imageFromSuit (getSuitFromCard card)), style styles.img ] []
        , viewPlayButton card compareCard currentSuit whoseTurn
        ]


viewPlayButton : Card -> Maybe Card -> Suit -> WhoseTurn -> Html Msg
viewPlayButton card compareCard currentSuit whoseTurn =
    case whoseTurn of
        Player ->
            case isCardPlayable compareCard currentSuit card of
                True ->
                    button [ class "btn btn-primary", onClick (PlayCard card) ] [ text "Play this card" ]

                False ->
                    div [] []

        _ ->
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


viewCurrentSuit : Suit -> Html Msg
viewCurrentSuit suit =
    div [ class "discard-pile" ]
        [ img [ src (imageFromSuit suit), style styles.img ] [] ]


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
