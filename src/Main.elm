module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page
import Page.Book as Book
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Profile as Profile
import Page.Shelf as Shelf
import Route exposing (Route)
import Session exposing (Session(..))
import Url



-- ---------------------------
-- MODEL
-- ---------------------------


type Model
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | Profile Profile.Model
    | Shelf Shelf.Model
    | Book Book.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    changeRouteTo (Route.urlToRoute url) (Redirect (LoggedIn key { id = "user-0000", name = "Alice" }))



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotHomeMsg Home.Msg
    | GotProfileMsg Profile.Msg
    | GotShelfMsg Shelf.Msg
    | GotBookMsg Book.Msg
    | GotNotFoundMsg ()


toSession : Model -> Session
toSession model =
    case model of
        Redirect session ->
            session

        NotFound session ->
            session

        Home home ->
            Home.toSession home

        Profile profile ->
            Profile.toSession profile

        Shelf shelf ->
            Shelf.toSession shelf

        Book book ->
            Book.toSession book


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


changeRouteTo : Route -> Model -> ( Model, Cmd Msg )
changeRouteTo route model =
    let
        session =
            toSession model
    in
    case route of
        Route.Home ->
            Home.init session |> updateWith Home GotHomeMsg

        Route.Profile id ->
            Profile.init session id |> updateWith Profile GotProfileMsg

        Route.Shelf id ->
            Shelf.init session id |> updateWith Shelf GotShelfMsg

        Route.Book id ->
            Book.init session id |> updateWith Book GotBookMsg

        Route.NotFound ->
            ( NotFound session, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.urlToRoute url) model

        ( GotHomeMsg subMsg, Home subModel ) ->
            Home.update subMsg subModel |> updateWith Home GotHomeMsg

        ( GotShelfMsg subMsg, Shelf subModel ) ->
            Shelf.update subMsg subModel |> updateWith Shelf GotShelfMsg

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            ( model, Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url) )

                        Just _ ->
                            ( model, Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url) )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        _ ->
            ( model, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Document Msg
view model =
    let
        viewPage toMsg config =
            let
                { title, body } =
                    Page.view config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            { title = "blank"
            , body = []
            }

        NotFound _ ->
            viewPage GotNotFoundMsg NotFound.view

        Home home ->
            viewPage GotHomeMsg (Home.view home)

        Profile profile ->
            viewPage GotProfileMsg (Profile.view profile)

        Shelf shelf ->
            viewPage GotShelfMsg (Shelf.view shelf)

        Book book ->
            viewPage GotBookMsg (Book.view book)



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
