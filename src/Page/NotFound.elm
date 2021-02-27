module Page.NotFound exposing (..)

import Html exposing (..)


view : { title : String, body : List (Html msg) }
view =
    { title = "404 | Not Found"
    , body = [ text "Page Not Found" ]
    }
