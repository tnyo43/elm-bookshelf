module Component.Shelf exposing (..)

import Data.Shelf exposing (Shelf)
import Data.User exposing (User)
import Html exposing (..)
import Html.Attributes exposing (class)
import Route


shelfView : Shelf -> Html msg
shelfView shelf =
    div [ class "shelf" ]
        [ a [ Route.href (Route.Shelf shelf.id), class "header" ]
            [ div [ class "title" ] [ text shelf.name ]
            , div [ class "discription" ] [ text shelf.description ]
            ]
        , List.map
            (\book ->
                a [ Route.href (Route.Book book.id), class "book" ]
                    [ div [] [ text book.title ]
                    , div [] [ text book.author ]
                    ]
            )
            shelf.books
            |> div [ class "book-container" ]
        ]


userShelves : User -> List Shelf -> Html msg
userShelves user shelves =
    div [ class "user-shelves" ]
        [ a [ Route.href (Route.Profile user.id) ] [ text <| user.name ]
        , text "の本棚"
        , case shelves of
            [] ->
                div [] [ text "まだ本棚がありません。登録しましょう！" ]

            _ ->
                List.map shelfView shelves
                    |> div [ class "shelves" ]
        ]
