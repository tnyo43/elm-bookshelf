module Data.Book exposing (Book, Note)

import Data.User exposing (UserId)


type alias NoteId =
    String


type alias BookId =
    String


type alias Note =
    { id : NoteId
    , content : String
    }


type alias Book =
    { id : BookId
    , title : String
    , category : String
    , author : String
    , user : UserId
    }
