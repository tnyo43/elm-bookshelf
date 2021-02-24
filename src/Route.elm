module Route exposing (Route(..), routeParser, urlToRoute)

import Url
import Url.Parser as P exposing ((</>), (<?>), Parser)


type Route
    = Home
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    P.oneOf
        [ P.map Home P.top
        ]


urlToRoute : Url.Url -> Route
urlToRoute url =
    Maybe.withDefault NotFound <| P.parse routeParser url
