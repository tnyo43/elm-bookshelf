module Page.Book exposing (..)

import Data.Book exposing (Book)
import Html exposing (..)
import Html.Attributes exposing (src)
import Session exposing (Session)


type alias Model =
    { session : Session
    , book : Book
    }


init : Session -> String -> ( Model, Cmd Msg )
init session _ =
    ( { session = session
      , book = Book "book-0000" "桃太郎" "昔話" "不明" "user-0000"
      }
    , Cmd.none
    )


type Msg
    = Nothing


toSession : Model -> Session
toSession model =
    model.session


update : Msg -> model -> ( model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


view : Model -> { title : String, body : List (Html Msg) }
view model =
    { title = "本"
    , body =
        [ div [] [ text model.book.title ]
        , div []
            [ img [ src "https://3.bp.blogspot.com/-ZaEM1sNjZ10/VtofN5FQWMI/AAAAAAAA4WI/W8nM9jXMwnA/s200/book_sasshi1_red.png" ] []
            , div []
                [ div [] [ text model.book.category ]
                , div [] [ text model.book.author ]
                , div [] [ text model.book.user ]
                ]
            ]
        ]
    }
