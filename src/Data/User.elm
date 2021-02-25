module Data.User exposing (User, UserId)


type alias UserId =
    String


type alias User =
    { id : UserId
    , name : String
    }
