port module Ports exposing (getTime, loadTime)


port loadTime : (Int -> msg) -> Sub msg


port getTime : () -> Cmd msg
