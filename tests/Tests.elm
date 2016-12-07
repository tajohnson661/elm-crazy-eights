module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Cards exposing (isCardPlayable, Card, Face, Suit)
import Utils exposing (listsToTupleList, listsToTupleListMap)


faces : List Face
faces =
    [ 1, 2, 3, 4 ]


suits : List Suit
suits =
    [ 'H', 'D' ]


deck : List Card
deck =
    [ ( 1, 'H' ), ( 2, 'H' ), ( 3, 'H' ), ( 4, 'H' ), ( 1, 'D' ), ( 2, 'D' ), ( 3, 'D' ), ( 4, 'D' ) ]


discardPile : List Card
discardPile =
    [ ( 7, 'H' ), ( 4, 'D' ) ]


card1 : Card
card1 =
    ( 7, 'C' )


card2 : Card
card2 =
    ( 1, 'C' )


all : Test
all =
    describe "Crazy Eights game"
        [ describe "Card module tests"
            [ test "isCardPlayable" <|
                \() ->
                    isCardPlayable card1 (List.head discardPile)
                        |> Expect.equal
                            True
            , test "isCardPlayable" <|
                \() ->
                    Expect.equal (isCardPlayable card2 (List.head discardPile)) False
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
