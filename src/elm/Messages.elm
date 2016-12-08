module Messages exposing (..)

import Cards exposing (Card, Suit)


type Msg
    = NoOp
    | StartShuffle
    | ShuffleDeckAndDeal Int
    | DrawCard
    | PlayCard Card
    | DealersTurn
    | DealersTurnDone
    | Acknowledge Suit
