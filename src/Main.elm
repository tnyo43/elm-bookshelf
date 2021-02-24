module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page.Home as Home
import Page.NotFound as NotFound
import Route exposing (Route)
import Url



-- ---------------------------
-- MODEL
-- ---------------------------


type Model
    = Redirect
    | Home Home.Model
    | NotFound NotFound.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url _ =
    changeRouteTo (Route.urlToRoute url) Redirect



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotHomeMsg Home.Msg
    | GotNotFoundMsg ()


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


changeRouteTo : Route -> Model -> ( Model, Cmd Msg )
changeRouteTo route _ =
    case route of
        Route.NotFound ->
            NotFound.init () |> updateWith NotFound GotNotFoundMsg

        Route.Home ->
            Home.init () |> updateWith Home GotHomeMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.urlToRoute url) model

        ( GotHomeMsg subMsg, Home subModel ) ->
            Home.update subMsg subModel |> updateWith Home GotHomeMsg

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
                    config
            in
            { title = title
            , body = Html.map toMsg body |> List.singleton
            }
    in
    case model of
        Redirect ->
            { title = "blank"
            , body = []
            }

        NotFound notFound ->
            viewPage GotNotFoundMsg (NotFound.view notFound)

        Home home ->
            viewPage GotHomeMsg (Home.view home)



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
