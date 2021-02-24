module Page.Home exposing (..)

import Html exposing (Html, text)


type alias Model =
    {}


type Msg
    = Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )


view : Model -> { title : String, body : Html Msg }
view _ =
    { title = "トップページ"
    , body = text "Hello World!"
    }
