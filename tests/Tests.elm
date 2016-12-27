module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Cards exposing (Card, Face, Suit(..))
import Utils exposing (listsToTupleList, listsToTupleListMap)
import GameLogic exposing (isCardPlayable)


faces : List Face
faces =
    [ 1, 2, 3, 4 ]


suits : List Suit
suits =
    [ Hearts, Diamonds ]


deck : List Card
deck =
    [ ( 1, Hearts )
    , ( 2, Hearts )
    , ( 3, Hearts )
    , ( 4, Hearts )
    , ( 1, Diamonds )
    , ( 2, Diamonds )
    , ( 3, Diamonds )
    , ( 4, Diamonds )
    ]


discardPile : List Card
discardPile =
    [ ( 7, Hearts ), ( 4, Diamonds ) ]


card1 : Card
card1 =
    ( 7, Clubs )


card2 : Card
card2 =
    ( 1, Clubs )


all : Test
all =
    describe "Crazy Eights game"
        [ describe "Card module tests"
            [ test "isCardPlayable" <|
                \() ->
                    isCardPlayable (List.head discardPile) Hearts card1
                        |> Expect.equal
                            True
            , test "isCardPlayable" <|
                \() ->
                    Expect.equal (isCardPlayable (List.head discardPile) Hearts card2) False
            ]
        , describe "Util tests"
            [ test "listsToTupleList" <|
                \() ->
                    listsToTupleList faces suits
                        |> Expect.equal
                            deck
            , test "listsToTupleListMap" <|
                \() ->
                    listsToTupleListMap faces suits
                        |> Expect.equal
                            deck
            ]
        ]
