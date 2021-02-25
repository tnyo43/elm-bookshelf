module Session exposing (..)

import Browser.Navigation as Nav
import Data.User exposing (User)


type Session
    = LoggedIn Nav.Key User


toUser : Session -> User
toUser session =
    case session of
        LoggedIn _ user ->
            user


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ ->
            key
