module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Cards exposing (isCardPlayable, Card, Face, Suit)


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
        , describe "Model tests"
            [ test "junk" <|
                \() ->
                    True
                        |> Expect.equal
                            True
            ]
        ]
