module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Utils


-- component import example

import Components.Hello exposing (hello)


-- CARDS


type alias Card =
    ( Int, Char )


faces : List Int
faces =
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ]


suits : List Char
suits =
    [ 'H', 'D', 'C', 'S' ]


allCards : List a -> List b -> List ( a, b )
allCards faces suits =
    Utils.listsToTupleList faces suits



{--
allCardsMap : List a -> List b -> List ( a, b )
allCardsMap faces suits =
    Utils.listsToTupleListMap faces suits
--}


deck : List Card
deck =
    allCards faces suits



-- APP


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )



-- UPDATE


type Msg
    = NoOp
    | Increment


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Increment ->
            ( model + 1, Cmd.none )



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
                    , hello model
                      -- ext 'hello' component (takes 'model' as arg)
                    , p [] [ text ("Elm Webpack Starter") ]
                    , button [ class "btn btn-primary btn-lg", onClick Increment ]
                        [ -- click handler
                          span [ class "glyphicon glyphicon-star" ] []
                          -- glyphicon
                        , span [] [ text "FTW!" ]
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
