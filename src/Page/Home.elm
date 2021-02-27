module Page.Home exposing (..)

import Component.Shelf exposing (..)
import Data.Book exposing (Book)
import Data.Shelf exposing (Shelf)
import Data.User exposing (User)
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode exposing (Decoder, field, list, map2, map5, string)
import Session exposing (Session)
import Utils



-- ---------------------------
-- HTTP
-- ---------------------------


userDecoder : Decoder User
userDecoder =
    map2 User
        (field "id" string)
        (field "name" string)


booksDecoder : Decoder (List Book)
booksDecoder =
    map5 Book
        (field "id" string)
        (field "title" string)
        (field "category" string)
        (field "author" string)
        (field "user" string)
        |> list


getShelves : Cmd Msg
getShelves =
    Http.get
        { url = "assets/dummy/shelves.json"
        , expect = Http.expectJson GotShelves shelvesDecoder
        }


shelvesDecoder : Decoder (List Shelf)
shelvesDecoder =
    map5 Shelf
        (field "id" string)
        (field "name" string)
        (field "description" string)
        (field "user" userDecoder)
        (field "books" booksDecoder)
        |> list



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { session : Session
    , shelves : List Shelf
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , shelves = []
      }
    , getShelves
    )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = GotShelves (Result Http.Error (List Shelf))


toSession : Model -> Session
toSession =
    .session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotShelves result ->
            case result of
                Ok shelves ->
                    ( { model | shelves = shelves }, Cmd.none )

                _ ->
                    ( model, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> { title : String, body : List (Html Msg) }
view model =
    let
        user =
            Session.toUser model.session
    in
    { title = "トップページ"
    , body =
        [ div [ class "shelves-contianer" ] <|
            userShelves user (List.filter (\shelf -> shelf.user.id == user.id) model.shelves)
                :: (List.filter (\shelf -> shelf.user.id == user.id |> not) model.shelves
                        |> Utils.group (\s1 s2 -> s1.user.id == s2.user.id)
                        |> List.map
                            (\shelves ->
                                let
                                    owner =
                                        List.head shelves
                                            |> Maybe.withDefault (Shelf "" "" "" (User "" "") [])
                                            |> .user
                                in
                                userShelves owner shelves
                            )
                   )
        ]
    }
