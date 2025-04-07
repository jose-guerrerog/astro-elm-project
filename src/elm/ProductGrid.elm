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
    , productCards : List (ProductCard.Model)
    }


init : Int -> ( Model, Cmd Msg )
init windowWidth =
    let
        products = getWallets
        productCards = List.map ProductCard.init products
    in
    ( { products = products
      , windowWidth = windowWidth
      , productCards = productCards
      }
    , Cmd.none
    )


-- UPDATE

type Msg
    = ProductCardMsg Int ProductCard.Msg
    | WindowResized Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductCardMsg index cardMsg ->
            let
                updateCard i card =
                    if i == index then
                        let
                            (updatedCard, _) = ProductCard.update cardMsg card
                        in
                        updatedCard
                    else
                        card
                        
                updatedCards = 
                    List.indexedMap updateCard model.productCards
            in
            ( { model | productCards = updatedCards }, Cmd.none )

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
            else
                3
    in
    div [ class "product-grid-container" ]
        [ div
            [ class "product-grid"
            , style "grid-template-columns" ("repeat(" ++ String.fromInt columns ++ ", 1fr)")
            ]
            (List.indexedMap
                (\index cardModel ->
                    Html.map (\msg -> ProductCardMsg index msg)
                        (ProductCard.view cardModel)
                )
                model.productCards
            )
        ]