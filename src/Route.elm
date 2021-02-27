module Route exposing (Route(..), href, routeParser, urlToRoute)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Url
import Url.Parser as P exposing ((</>), (<?>), Parser, s, string)


type Route
    = Home
    | Profile String
    | Shelf String
    | Book String
    | NotFound


href : Route -> Attribute msg
href route =
    Attr.href (toString route)


routeParser : Parser (Route -> a) a
routeParser =
    P.oneOf
        [ P.map Home P.top
        , P.map Profile (s "profile" </> string)
        , P.map Shelf (s "shelf" </> string)
        , P.map Book (s "book" </> string)
        ]


urlToRoute : Url.Url -> Route
urlToRoute url =
    Maybe.withDefault NotFound <| P.parse routeParser url


routeToPieces : Route -> List String
routeToPieces route =
    case route of
        Home ->
            []

        Profile id ->
            [ "profile", id ]

        Shelf id ->
            [ "shelf", id ]

        Book id ->
            [ "book", id ]

        _ ->
            []


toString : Route -> String
toString route =
    "/" ++ String.join "/" (routeToPieces route)
