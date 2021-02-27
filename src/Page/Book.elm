module Page.Book exposing (..)

import Html exposing (..)
import Session exposing (Session)


type alias Model =
    { session : Session }


init : Session -> String -> ( Model, Cmd Msg )
init session _ =
    ( { session = session }, Cmd.none )


type Msg
    = Nothing


toSession : Model -> Session
toSession model =
    model.session


update : Msg -> model -> ( model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


view : Model -> { title : String, body : List (Html Msg) }
view _ =
    { title = "本", body = [ text "本 - 作成中" ] }
