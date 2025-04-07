module Main exposing (main)

import Browser
import Html exposing (..)
import ProductGrid


-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- MODEL

type alias Model =
    { productGrid : ProductGrid.Model
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        ( productGridModel, productGridCmd ) =
            ProductGrid.init
    in
    ( { productGrid = productGridModel }
    , Cmd.map ProductGridMsg productGridCmd
    )


-- UPDATE

type Msg
    = ProductGridMsg ProductGrid.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductGridMsg subMsg ->
            let
                ( updatedProductGrid, productGridCmd ) =
                    ProductGrid.update subMsg model.productGrid
            in
            ( { model | productGrid = updatedProductGrid }
            , Cmd.map ProductGridMsg productGridCmd
            )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


-- VIEW

view : Model -> Html Msg
view model =
    Html.map ProductGridMsg (ProductGrid.view model.productGrid)