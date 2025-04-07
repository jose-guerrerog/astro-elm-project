module ProductGrid exposing (Model, Msg(..), init, update, view, subscriptions)

import Array exposing (Array)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import ProductCard
import ProductData exposing (Product, getWallets)


-- MODEL

type alias Model =
    { products : List Product
    , productCards : Array ProductCard.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        products = getWallets
        productCards = Array.fromList (List.map ProductCard.init products)
    in
    ( { products = products
      , productCards = productCards
      }
    , Cmd.none
    )


-- UPDATE

type Msg
    = ProductCardMsg Int ProductCard.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductCardMsg index cardMsg ->
            let
                maybeCard = Array.get index model.productCards
                updatedCards = 
                    case maybeCard of
                        Just card ->
                            let
                                (updatedCard, _) = ProductCard.update cardMsg card
                            in
                            Array.set index updatedCard model.productCards
                        
                        Nothing ->
                            model.productCards
            in
            ( { model | productCards = updatedCards }, Cmd.none )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none  -- No subscriptions needed


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "product-grid-container" ]
        [ div
            [ class "product-grid" ]  -- CSS handles responsiveness
            (Array.toIndexedList model.productCards
                |> List.map (\(index, cardModel) ->
                    Html.map (\msg -> ProductCardMsg index msg)
                        (ProductCard.view cardModel)
                )
            )
        ]