module SampleDecoder exposing (Dog, dogDecoder)

import Json.Decode exposing (Decoder, field, map4, string, bool, int)


type alias Dog =
    { id : String
    , name : String
    , isHungry : Bool
    , age : Int
    }


dogDecoder : Decoder Dog
dogDecoder =
    map4 Dog
        (field "id" string)
        (field "name" string)
        (field "is_hungry" bool)
        (field "age" int)
