module Utils exposing (listsToTupleList, listsToTupleListMap, postMessage)

import Task


-- Combine two lists into a list of tuples... cartesian product I think


listsToTupleList : List a -> List b -> List ( a, b )
listsToTupleList l1 l2 =
    case l2 of
        x :: xs ->
            family l1 x ++ listsToTupleList l1 xs

        _ ->
            []


family : List a -> b -> List ( a, b )
family list item =
    case list of
        x :: xs ->
            (,) x item :: family xs item

        _ ->
            []



-- Alternative implementation using maps just for fun


listsToTupleListMap : List a -> List b -> List ( a, b )
listsToTupleListMap l1 l2 =
    l2
        |> List.map (familyMap l1)
        |> List.concat


familyMap : List a -> b -> List ( a, b )
familyMap l1 item =
    List.map (getTuple item) l1


getTuple : a -> b -> ( b, a )
getTuple item1 item2 =
    ( item2, item1 )


postMessage : msg -> Cmd msg
postMessage x =
    Task.perform identity (Task.succeed x)
