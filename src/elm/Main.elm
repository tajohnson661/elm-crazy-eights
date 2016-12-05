module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Cards exposing (Card)
import Ports


-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { shuffledDeck : Maybe (List Card)
    , playerHand : List Card
    , dealerHand : List Card
    }


init : ( Model, Cmd Msg )
init =
    ( { shuffledDeck = Nothing
      , playerHand = []
      , dealerHand = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp
    | StartShuffle
    | ShuffleDeck Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        StartShuffle ->
            ( model, Ports.getTime () )

        ShuffleDeck timeVal ->
            { model | shuffledDeck = Just (Cards.shuffleDeck Cards.initialDeck timeVal) } ! []



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
                    [ img [ src "static/img/elm.jpg", style styles.img ] []
                      -- inline CSS (via var)
                    , p [] [ text ("Elm Webpack Starter") ]
                    , button [ class "btn btn-primary btn-lg", onClick StartShuffle ]
                        [ -- click handler
                          span [ class "glyphicon glyphicon-star" ] []
                          -- glyphicon
                        , span [] [ text "Shuffle" ]
                        ]
                    ]
                ]
            ]
        ]



-- CSS STYLES


styles : { img : List ( String, String ) }
styles =
    { img =
        [ ( "width", "33%" )
        , ( "border", "4px solid #337AB7" )
        ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.loadTime mapLoadTime


mapLoadTime : Int -> Msg
mapLoadTime timeVal =
    ShuffleDeck timeVal
