module Page.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> { title : String, body : List (Html Msg) }
view _ =
    { title = "トップページ"
    , body =
        [ text "Hello World!"
        ]
    }
