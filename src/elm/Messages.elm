module Messages exposing (..)


type Msg
    = NoOp
    | StartShuffle
    | ShuffleDeck Int
    | Deal
