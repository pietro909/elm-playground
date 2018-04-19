module Example exposing (..)

import Expect
import Fuzz exposing (Fuzzer, list, int, string)
import Test exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import SampleDecoder exposing (dogDecoder)
import Regex exposing (replace, regex)


{-|

     Generates a valid string for JSON data
-}
stringJSON : Fuzz.Fuzzer String
stringJSON =
    Fuzz.map
        (\s ->
            --Decode.decodeValue Decode.string (Encode.string s)
            --|> Result.withDefault "FALLBACK"
            s
                |> replace Regex.All (regex "[\\\\\"n\\t\\n]") (\_ -> "\x1F92A ")
                |> Debug.log "questa"
        )
        Fuzz.string


dogAsJson : String -> String
dogAsJson id =
    """{ "id": \"""" ++ id ++ """", "name": "Zaky", "is_hungry": true, "age": 6 }"""


suite : Test
suite =
    fuzz stringJSON "decodes any kind of dog" <|
        \id ->
            Decode.decodeString dogDecoder (dogAsJson id)
                |> Expect.equal
                    (Ok
                        { id = id
                        , name = "Zaky"
                        , isHungry = True
                        , age = 6
                        }
                    )



{-
   makeLeagueJson : Ownership -> ( Maybe String, String, String, Int ) -> String
   makeLeagueJson ownership ( icon, id, name, members ) =
       let
           isOwner =
               String.toLower (toString (ownership == Mine))

           iconValue =
               icon
                   |> Maybe.map
                       (\url ->
                           interpolate "\"icon\": \"{0}\"," [ url ]
                       )
                   |> Maybe.withDefault "\"icon\": null,"
       in
           interpolate
               """
               {
                   {4}
                   "uid": "{0}",
                   "name": "{1}",
                   "num_members": {2},
                   "is_owner": {3}
               }"""
               [ id, name, toString members, isOwner, iconValue ]
               |> Debug.log ""


   {-|

       Generates a valid string for JSON data
   -}
   string : Fuzz.Fuzzer String
   string =
       Fuzz.map
           (\s ->
               Decode.decodeValue Decode.string (Encode.string s)
                   |> Result.withDefault "FALLBACK"
                   |> replace Regex.All (regex "\\\\") (\_ -> "cazzo")
                   |> replace Regex.All (regex "\"") (\_ -> "figa")
           )
           Fuzz.string


   valueToString : Encode.Value -> String
   valueToString value =
       toString value
           |> replace Regex.All (regex "^\\\"") (\_ -> "A")
           |> replace Regex.All (regex "\\\"$") (\_ -> "B")



-}
