module Messages exposing (..)

import Cards exposing (Card)


type Msg
    = NoOp
    | StartShuffle
    | ShuffleDeckAndDeal Int
    | DrawCard
    | PlayCard Card
    | DealersTurn
    | DealersTurnDone
