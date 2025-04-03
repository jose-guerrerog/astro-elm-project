module ProductGrid exposing (Model, Msg(..), init, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import ProductCard
import ProductData exposing (Product, getWallets)


-- MODEL

type alias Model =
    { products : List Product
    , windowWidth : Int
    }


init : Int -> ( Model, Cmd Msg )
init windowWidth =
    ( { products = getWallets
      , windowWidth = windowWidth
      }
    , Cmd.none
    )


-- UPDATE

type Msg
    = ProductCardMsg ProductCard.Msg
    | WindowResized Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductCardMsg _ ->
            -- Forward messages to product cards if needed
            ( model, Cmd.none )

        WindowResized width ->
            ( { model | windowWidth = width }, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
    let
        -- Responsive column count based on window width
        columns =
            if model.windowWidth < 640 then
                1
            else if model.windowWidth < 1024 then
                2
            else if model.windowWidth < 1280 then
                3
            else
                4
    in
    div [ class "product-grid-container" ]
        [ div
            [ class "product-grid"
            , style "grid-template-columns" ("repeat(" ++ String.fromInt columns ++ ", 1fr)")
            ]
            (List.map
                (\product ->
                    Html.map (\msg -> ProductCardMsg msg)
                        (ProductCard.view (ProductCard.init product))
                )
                model.products
            )
        ]