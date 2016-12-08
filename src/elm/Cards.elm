module Cards
    exposing
        ( Card
        , Face
        , Suit
        , shuffleDeck
        , initialDeck
        , dealCards
        , getSuitFromCard
        , getFaceFromCard
        , removeCard
        , getDeckTopCard
        , getMostProlificSuit
        )

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


dealCards : List Card -> ( List Card, List Card, List Card, List Card )
dealCards deck =
    let
        playerDeck =
            List.take 8 deck

        remainingDeck =
            List.drop 8 deck

        dealerDeck =
            List.take 8 remainingDeck

        nextRemainingDeck =
            List.drop 8 remainingDeck

        discardPile =
            List.take 1 nextRemainingDeck

        finalDeck =
            List.drop 1 nextRemainingDeck
    in
        ( finalDeck, playerDeck, dealerDeck, discardPile )


getFaceFromCard : Card -> Face
getFaceFromCard card =
    Tuple.first card


getSuitFromCard : Card -> Suit
getSuitFromCard card =
    Tuple.second card


removeCard : Card -> List Card -> List Card
removeCard card hand =
    List.filter ((/=) card) hand


getDeckTopCard : List Card -> Maybe Card
getDeckTopCard deck =
    List.head deck


getMostProlificSuit : List Card -> Suit
getMostProlificSuit cards =
    'H'


initialDeck : List Card
initialDeck =
    allCards faces suits
