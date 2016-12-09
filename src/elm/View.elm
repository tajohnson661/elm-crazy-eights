module View exposing (view)

import Model exposing (Model, WhoseTurn(..))
import Messages exposing (..)
import Html exposing (Html, div, text, button, span, p, img, h3, h4, h5, ul, li, nav, a, i, footer)
import Html.Attributes exposing (class, style, src, href, id)
import Html.Events exposing (onClick)
import Cards exposing (Card, Suit, getSuitFromCard, getFaceFromCard)
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
    nav [ class "light-blue lighten-1" ]
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
            , a [ href "#", class "button-collapse" ]
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
        div [ class "container", style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
            [ viewDealerHand model.dealerHand
            , div [ class "row" ]
                [ div [ class "col s12" ]
                    [ div [ class "jumbotron" ]
                        [ h4 [] [ text model.message ]
                        , viewDiscardPile model.discardPile
                        , viewCurrentSuit model.currentSuit
                        ]
                    ]
                ]
            , viewDrawCardButton model
            , Dialog.view
                (if model.showDialog then
                    Just (dialogConfig model)
                 else
                    Nothing
                )
            , h3 [] [ text "Player Hand " ]
            , div [ class "row" ]
                [ viewHand model.playerHand compareCard model.currentSuit model.whoseTurn ]
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
            empty


viewDealerHand : List Card -> Html Msg
viewDealerHand hand =
    text "x"


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
                    empty

        _ ->
            empty


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
            div [ class "discard-pile" ]
                [ text (toFaceName (getFaceFromCard card))
                , img [ src (imageFromSuit (getSuitFromCard card)), style styles.img ] []
                ]


viewCurrentSuit : Suit -> Html Msg
viewCurrentSuit suit =
    div []
        [ div [] [ text "current suit" ]
        , div [ class "discard-pile" ]
            [ img [ src (imageFromSuit suit), style styles.img ] []
            ]
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
