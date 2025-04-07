module ProductGrid exposing (Model, Msg(..), init, update, view)

import Array exposing (Array)
import Html exposing (..)
import Html.Attributes exposing (..)
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
            case Array.get index model.productCards of
                Just card ->
                    let
                        (updatedCard, _) = ProductCard.update cardMsg card
                        updatedCards = Array.set index updatedCard model.productCards
                    in
                    ( { model | productCards = updatedCards }, Cmd.none )
                
                Nothing ->
                    ( model, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "product-grid-container" ]
        [ div
            [ class "product-grid" ]
            (Array.toIndexedList model.productCards
                |> List.map (\(index, cardModel) ->
                    Html.map (ProductCardMsg index)
                        (ProductCard.view cardModel)
                )
            )
        ]