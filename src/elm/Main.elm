port module Main exposing (main)

import Browser
import Html exposing (..)
import ProductGrid


-- PORTS

port windowResized : (Int -> msg) -> Sub msg


-- MAIN

main : Program Int Model Msg
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


init : Int -> ( Model, Cmd Msg )
init windowWidth =
    let
        ( productGridModel, productGridCmd ) =
            ProductGrid.init windowWidth
    in
    ( { productGrid = productGridModel }
    , Cmd.map ProductGridMsg productGridCmd
    )


-- UPDATE

type Msg
    = ProductGridMsg ProductGrid.Msg
    | WindowResized Int


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

        WindowResized width ->
            let
                ( updatedProductGrid, productGridCmd ) =
                    ProductGrid.update (ProductGrid.WindowResized width) model.productGrid
            in
            ( { model | productGrid = updatedProductGrid }
            , Cmd.map ProductGridMsg productGridCmd
            )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    windowResized WindowResized


-- VIEW

view : Model -> Html Msg
view model =
    Html.map ProductGridMsg (ProductGrid.view model.productGrid)