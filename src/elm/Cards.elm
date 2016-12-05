module Cards exposing (Card, Face, Suit, shuffleDeck, initialDeck)

import Utils
import Random


type alias Face =
    Int


type alias Suit =
    Char


type alias Card =
    ( Face, Suit )


faces : List Face
faces =
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ]


suits : List Suit
suits =
    [ 'H', 'D', 'C', 'S' ]


allCards : List a -> List b -> List ( a, b )
allCards faces suits =
    Utils.listsToTupleList faces suits


rlist : List Card -> Int -> List Int
rlist deck seed =
    Random.step (Random.list (List.length deck) (Random.int 1 1000)) (Random.initialSeed seed)
        |> Tuple.first


shuffleDeck : List Card -> Int -> List Card
shuffleDeck deck seed =
    List.map2 (,) (rlist deck seed) deck
        |> List.sortBy Tuple.first
        |> List.unzip
        |> Tuple.second



{--
allCardsMap : List a -> List b -> List ( a, b )
allCardsMap faces suits =
    Utils.listsToTupleListMap faces suits
--}


initialDeck : List Card
initialDeck =
    allCards faces suits
