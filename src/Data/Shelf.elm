module Data.Shelf exposing (Shelf)

import Data.Book exposing (Book)
import Data.User exposing (User)


type alias ShelfId =
    String


type alias Shelf =
    { id : ShelfId
    , name : String
    , description : String
    , user : User
    , books : List Book
    }
