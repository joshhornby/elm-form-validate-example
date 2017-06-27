module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Validate exposing (..)
import Form


---- MODEL ----


type alias Model =
    { name : String
    , age : Int
    , email : String
    , errors : List Error
    }


init : ( Model, Cmd Msg )
init =
    ( { name = "", age = 0, email = "", errors = [] }, Cmd.none )



---- UPDATE ----


type Msg
    = SetName String
    | SetAge String
    | SetEmail String
    | SubmitForm


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetName name ->
            ( { model | name = name }, Cmd.none )

        SetAge age ->
            ( { model | age = Result.withDefault 0 (String.toInt age) }, Cmd.none )

        SetEmail email ->
            ( { model | email = email }, Cmd.none )

        SubmitForm ->
            case validate model of
                [] ->
                    ( { model | errors = [] }, Cmd.none )

                errors ->
                    ( { model | errors = errors }, Cmd.none )



---- VIEW ----


viewForm : Html Msg
viewForm =
    Html.form [ onSubmit SubmitForm ]
        [ Form.input
            [ placeholder "Name"
            , onInput SetName
            ]
            []
        , Form.input
            [ placeholder "Age"
            , onInput SetAge
            ]
            []
        , Form.input
            [ placeholder "Email"
            , onInput SetEmail
            ]
            []
        , button [] [ text "Enter" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ div [] [ Form.viewErrors model.errors ]
        , viewForm
        ]



---- VALIDATION ----


type Field
    = Name
    | Age
    | Email


type alias Error =
    ( Field, String )


validate : Model -> List Error
validate model =
    Validate.all
        [ .name >> ifBlank (Name => "Name can not be empty")
        , .age >> isGreaterThan (Age => "Age must be greater than 10") 10
        , .email >> ifBlank (Email => "Email can not be empty")
        , .email >> ifInvalidEmail (Email => "Email must be a valid email")
        ]
        model


isGreaterThan : error -> Int -> (Int -> List error)
isGreaterThan error value =
    \number ->
        if number > value then
            []
        else
            [ error ]


(=>) =
    (,)



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
