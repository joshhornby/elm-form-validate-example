-- Copied from https://github.com/rtfeldman/elm-spa-example/blob/74cb1e5da06492050ed4cf3002c3eef2d2ca184d/src/Views/Form.elm


module Form exposing (input, password, textarea, viewErrors)

import Html exposing (Attribute, Html, fieldset, li, text, ul)
import Html.Attributes exposing (class, type_)


password : List (Attribute msg) -> List (Html msg) -> Html msg
password attrs =
    control Html.input ([ type_ "password" ] ++ attrs)


input : List (Attribute msg) -> List (Html msg) -> Html msg
input attrs =
    control Html.input ([ type_ "text" ] ++ attrs)


textarea : List (Attribute msg) -> List (Html msg) -> Html msg
textarea =
    control Html.textarea


viewErrors : List ( a, String ) -> Html msg
viewErrors errors =
    errors
        |> List.map (\( _, error ) -> li [] [ text error ])
        |> ul [ class "error-messages" ]



-- INTERNAL --


control :
    (List (Attribute msg) -> List (Html msg) -> Html msg)
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
control element attributes children =
    fieldset [ class "form-group" ]
        [ element (class "form-control" :: attributes) children ]
