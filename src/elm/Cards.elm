module Cards exposing
    ( Card
    , CardsDealt
    , Face
    , Suit(..)
    , dealCards
    , getDeckTopCard
    , getFaceFromCard
    , getMostProlificSuit
    , getSuitFromCard
    , initialDeck
    , removeCard
    , shuffleDeck
    , sortHand
    , toFullString
    , toSuitName
    )

import Dict exposing (Dict)
import Random
import Utils


type alias Face =
    Int


type Suit
    = Hearts
    | Spades
    | Clubs
    | Diamonds


type alias Card =
    ( Face, Suit )


type alias CardsDealt =
    { workingCards : List Card
    , playerHand : List Card
    , dealerHand : List Card
    , discardPile : List Card
    }


allFaces : List Face
allFaces =
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ]


allSuits : List Suit
allSuits =
    [ Hearts, Spades, Clubs, Diamonds ]


allCards : List a -> List b -> List ( a, b )
allCards faces suits =
    Utils.listsToTupleList faces suits


rlist : List Card -> Int -> List Int
rlist deck seed =
    Random.step (Random.list (List.length deck) (Random.int 1 1000)) (Random.initialSeed seed)
        |> Tuple.first


shuffleDeck : List Card -> Int -> List Card
shuffleDeck deck seed =
    List.map2 (\a b -> ( a, b )) (rlist deck seed) deck
        |> List.sortBy Tuple.first
        |> List.unzip
        |> Tuple.second


dealCards : List Card -> CardsDealt
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
    { workingCards = finalDeck, playerHand = playerDeck, dealerHand = dealerDeck, discardPile = discardPile }


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
    let
        theDict =
            Dict.fromList
                [ ( rankOfSuit Hearts, 0 )
                , ( rankOfSuit Diamonds, 0 )
                , ( rankOfSuit Spades, 0 )
                , ( rankOfSuit Clubs, 0 )
                ]

        maybeTuple =
            cards
                |> List.foldl countThem theDict
                |> Dict.toList
                |> List.sortBy Tuple.second
                |> List.reverse
                |> List.head
    in
    case maybeTuple of
        Nothing ->
            Hearts

        Just tuple ->
            suitFromRank (Tuple.first tuple)


countThem : Card -> Dict Int Int -> Dict Int Int
countThem card currentValues =
    case getSuitFromCard card of
        Hearts ->
            addTo Hearts currentValues

        Diamonds ->
            addTo Diamonds currentValues

        Spades ->
            addTo Spades currentValues

        Clubs ->
            addTo Clubs currentValues


addTo : Suit -> Dict Int Int -> Dict Int Int
addTo suit dict =
    let
        maybeCurCount =
            Dict.get (rankOfSuit suit) dict
    in
    case maybeCurCount of
        Just curCount ->
            Dict.insert (rankOfSuit suit) (curCount + 1) dict

        Nothing ->
            dict


initialDeck : List Card
initialDeck =
    allCards allFaces allSuits


toFullString : Card -> String
toFullString card =
    toFaceName (getFaceFromCard card) ++ " of " ++ toSuitName (getSuitFromCard card)


toFaceName : Face -> String
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
            String.fromInt faceValue


toSuitName : Suit -> String
toSuitName suit =
    case suit of
        Hearts ->
            "Hearts"

        Diamonds ->
            "Diamonds"

        Clubs ->
            "Clubs"

        Spades ->
            "Spades"


sortHand : List Card -> List Card
sortHand hand =
    hand
        |> List.sortWith cardCompare


cardCompare : Card -> Card -> Order
cardCompare a b =
    let
        rankOfSuitA =
            rankOfSuit (getSuitFromCard a)

        rankOfSuitB =
            rankOfSuit (getSuitFromCard b)

        rankOfFaceA =
            rankOfFace (getFaceFromCard a)

        rankOfFaceB =
            rankOfFace (getFaceFromCard b)
    in
    if rankOfSuitB < rankOfSuitA then
        LT

    else if rankOfSuitB > rankOfSuitA then
        GT

    else if rankOfFaceB < rankOfFaceA then
        LT

    else if rankOfFaceB > rankOfFaceA then
        GT

    else
        EQ


rankOfSuit : Suit -> Int
rankOfSuit suit =
    case suit of
        Spades ->
            4

        Diamonds ->
            3

        Clubs ->
            2

        Hearts ->
            1


suitFromRank : Int -> Suit
suitFromRank suitValue =
    case suitValue of
        4 ->
            Spades

        3 ->
            Diamonds

        2 ->
            Clubs

        1 ->
            Hearts

        _ ->
            Hearts


rankOfFace : Face -> Int
rankOfFace face =
    case face of
        8 ->
            100

        1 ->
            99

        _ ->
            face
