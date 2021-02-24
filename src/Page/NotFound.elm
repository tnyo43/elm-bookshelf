module Page.NotFound exposing (..)

import Html exposing (..)


type alias Model =
    {}


init : () -> ( Model, Cmd msg )
init _ =
    ( {}, Cmd.none )


update : msg -> Model -> ( Model, Cmd msg )
update _ model =
    ( model, Cmd.none )


view : Model -> { title : String, body : Html msg }
view _ =
    { title = "404 | Not Found"
    , body = text "Page Not Found"
    }
