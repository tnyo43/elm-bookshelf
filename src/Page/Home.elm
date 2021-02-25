module Page.Home exposing (..)

import Data.Book exposing (Book)
import Data.Shelf exposing (Shelf)
import Data.User exposing (User)
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode exposing (Decoder, field, list, map2, map5, string)
import Utils



-- ---------------------------
-- HTTP
-- ---------------------------


getUser : Cmd Msg
getUser =
    Http.get
        { url = "assets/dummy/user.json"
        , expect = Http.expectJson GotUser userDecoder
        }


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
    { user : User
    , shelves : List Shelf
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { user = User "" ""
      , shelves = []
      }
    , Cmd.batch [ getUser, getShelves ]
    )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = GotUser (Result Http.Error User)
    | GotShelves (Result Http.Error (List Shelf))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotUser result ->
            case result of
                Ok user ->
                    ( { model | user = user }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        GotShelves result ->
            case result of
                Ok shelves ->
                    ( { model | shelves = shelves }, Cmd.none )

                _ ->
                    ( model, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


shelfView : Shelf -> Html Msg
shelfView shelf =
    div [ class "shelf" ]
        [ div [ class "header" ]
            [ div [ class "title" ] [ text shelf.name ]
            , div [ class "discription" ] [ text shelf.description ]
            ]
        , List.map
            (\book ->
                div [ class "book" ]
                    [ div [] [ text book.title ]
                    , div [] [ text book.author ]
                    ]
            )
            shelf.books
            |> div [ class "book-container" ]
        ]


userShelves : String -> List Shelf -> Html Msg
userShelves name shelves =
    div [ class "user-shelves" ]
        [ text <| name ++ "の本棚"
        , case shelves of
            [] ->
                div [] [ text "まだ本棚がありません。登録しましょう！" ]

            _ ->
                List.map shelfView shelves
                    |> div [ class "shelves" ]
        ]


view : Model -> { title : String, body : List (Html Msg) }
view model =
    { title = "トップページ"
    , body =
        [ div [ class "shelves-contianer" ] <|
            userShelves "あなた" (List.filter (\shelf -> shelf.user.id == model.user.id) model.shelves)
                :: (List.filter (\shelf -> shelf.user.id == model.user.id |> not) model.shelves
                        |> Utils.group (\s1 s2 -> s1.user.id == s2.user.id)
                        |> List.map
                            (\shelves ->
                                let
                                    userName =
                                        List.head shelves
                                            |> Maybe.withDefault (Shelf "" "" "" (User "" "") [])
                                            |> .user
                                            |> .name
                                in
                                userShelves userName shelves
                            )
                   )
        ]
    }
