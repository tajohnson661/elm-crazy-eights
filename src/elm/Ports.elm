port module Ports exposing (..)


port loadTime : (Int -> msg) -> Sub msg


port getTime : () -> Cmd msg
