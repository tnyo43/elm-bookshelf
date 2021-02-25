module Page exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


header : Html msg
header =
    div
        [ class "nav" ]
        [ img [ class "icon", src "https://4.bp.blogspot.com/-2t-ECy35d50/UPzH73UAg3I/AAAAAAAAKz4/OJZ0yCVaRbU/s400/book.png" ] []
        , div [ class "title" ] [ text "BookShelf" ]
        ]


view : { title : String, body : List (Html msg) } -> { title : String, body : List (Html msg) }
view content =
    { title = content.title
    , body = [ header, div [ class "container" ] content.body ]
    }
