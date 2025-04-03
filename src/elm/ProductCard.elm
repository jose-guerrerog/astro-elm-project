module ProductCard exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave)
import ProductData exposing (Product)


-- MODEL

type alias Model =
    { product : Product
    , isHovered : Bool
    , currentImageIndex : Int
    , isQuickViewOpen : Bool
    }


init : Product -> Model
init product =
    { product = product
    , isHovered = False
    , currentImageIndex = 0
    , isQuickViewOpen = False
    }


-- UPDATE

type Msg
    = MouseEnter
    | MouseLeave
    | QuickView Int
    | CloseQuickView
    | SelectColor String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseEnter ->
            ( { model | isHovered = True }, Cmd.none )

        MouseLeave ->
            ( { model | isHovered = False }, Cmd.none )

        QuickView _ ->
            ( { model | isQuickViewOpen = True }, Cmd.none )

        CloseQuickView ->
            ( { model | isQuickViewOpen = False }, Cmd.none )
            
        SelectColor _ ->
            -- In a real app, we would update the selected color here
            ( model, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
    div
        [ class "product-card"
        , onMouseEnter MouseEnter
        , onMouseLeave MouseLeave
        ]
        [ viewProductImage model
        , div [ class "product-info" ]
            [ div [ class "product-title" ]
                [ div [ class "product-name" ] [ text model.product.name ]
                , div [ class "product-category" ] [ text ("– " ++ model.product.category) ]
                ]
            , div [ class "product-price" ] [ text ("$" ++ String.fromFloat model.product.price) ]
            , div [ class "product-description" ] [ text model.product.description ]
            , viewColorOptions model.product
            ]
        , if model.isQuickViewOpen then
            viewQuickViewModal model
          else
            text ""
        ]


viewProductImage : Model -> Html Msg
viewProductImage model =
    let
        currentImage =
            List.head model.product.images |> Maybe.withDefault ""
    in
    div [ class "product-image-container" ]
        [ img
            [ src currentImage
            , alt model.product.name
            , class "product-image"
            ]
            []
        , if model.isHovered then
            button 
                [ class "show-inside-btn"
                , onClick (QuickView model.product.id)
                ] 
                [ text "SHOW INSIDE +" ]
          else
            text ""
        ]


viewColorOptions : Product -> Html Msg
viewColorOptions product =
    div [ class "color-options" ]
        (List.map
            (\color ->
                button
                    [ class "color-option"
                    , style "background-color" color.hex
                    , title color.name
                    , onClick (SelectColor color.name)
                    ]
                    []
            )
            product.colors
        )


viewQuickViewModal : Model -> Html Msg
viewQuickViewModal model =
    div [ class "quick-view-overlay" ]
        [ div [ class "quick-view-modal" ]
            [ button [ class "close-modal-btn", onClick CloseQuickView ] [ text "×" ]
            , div [ class "modal-content" ]
                [ div [ class "modal-image-container" ]
                    [ img
                        [ src (List.head model.product.images |> Maybe.withDefault "")
                        , alt model.product.name
                        , class "modal-image"
                        ]
                        []
                    ]
                , div [ class "modal-info" ]
                    [ h2 [ class "modal-product-name" ] [ text model.product.name ]
                    , div [ class "modal-product-category" ] [ text model.product.category ]
                    , p [ class "modal-product-description" ] [ text model.product.description ]
                    , div [ class "modal-price" ] [ text ("$" ++ String.fromFloat model.product.price) ]
                    , div [ class "modal-colors-section" ]
                        [ h3 [] [ text "Available Colors" ]
                        , div [ class "modal-color-options" ]
                            (List.map
                                (\color ->
                                    div
                                        [ class "modal-color-option"
                                        , style "background-color" color.hex
                                        , title color.name
                                        ]
                                        []
                                )
                                model.product.colors
                            )
                        ]
                    , button [ class "add-to-cart-btn" ] [ text "Add to Cart" ]
                    ]
                ]
            ]
        ]