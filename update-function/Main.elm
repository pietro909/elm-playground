module Main exposing (main)

import Html exposing (Html, beginnerProgram, button, div, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)


main =
    beginnerProgram
        { model = Model 0 0 (Ok 0)
        , view = view
        , update = update
        }


type alias Model =
    { a : Float, b : Float, result : Result String Float }


type Msg
    = Sum
    | Subtract
    | Multiply
    | Divide
    | NewA Float
    | NewB Float
    | InvalidInput String


update : Msg -> Model -> Model
update msg ({ a, b } as model) =
    case msg of
        NewA newA ->
            { model | a = newA }

        NewB newB ->
            { model | b = newB }

        Sum ->
            { model | result = Ok (a + b) }

        Subtract ->
            { model | result = Ok (a - b) }

        Multiply ->
            { model | result = Ok (a * b) }

        Divide ->
            if b /= 0 then
                { model | result = Ok (a / b) }
            else
                { model | result = Err "can't divide by 0" }

        InvalidInput error ->
            model


stringToMsg : (Float -> Msg) -> String -> Msg
stringToMsg msg input =
    case String.toFloat input of
        Ok n ->
            msg n

        Err e ->
            InvalidInput e


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ input [ onInput (stringToMsg NewA), value <| toString model.a ] []
            , input [ onInput (stringToMsg NewB), value <| toString model.b ] []
            ]
        , button [ onClick Sum ] [ text "+" ]
        , button [ onClick Subtract ] [ text "-" ]
        , button [ onClick Multiply ] [ text "*" ]
        , button [ onClick Divide ] [ text "/" ]
        , div []
            [ case model.result of
                Ok r ->
                    text <| toString r

                Err e ->
                    text e
            ]
        ]
