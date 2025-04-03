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
    | NextImage
    | PrevImage
    | QuickView Int
    | CloseQuickView
    | SelectColor String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseEnter ->
            ( { model | isHovered = True }, Cmd.none )

        MouseLeave ->
            ( { model | isHovered = False, currentImageIndex = 0 }, Cmd.none )

        NextImage ->
            let
                nextIndex =
                    if model.currentImageIndex >= List.length model.product.images - 1 then
                        0
                    else
                        model.currentImageIndex + 1
            in
            ( { model | currentImageIndex = nextIndex }, Cmd.none )

        PrevImage ->
            let
                prevIndex =
                    if model.currentImageIndex <= 0 then
                        List.length model.product.images - 1
                    else
                        model.currentImageIndex - 1
            in
            ( { model | currentImageIndex = prevIndex }, Cmd.none )

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
        , style "cursor" "default"
        ]
        [ viewProductImage model
        , div [ class "product-info" ]
            [ viewProductName model.product
            , viewProductDescription model.product
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
            case List.drop model.currentImageIndex model.product.images |> List.head of
                Just img ->
                    img

                Nothing ->
                    List.head model.product.images |> Maybe.withDefault ""
    in
    div [ class "product-image-container" ]
        [ img
            [ src currentImage
            , alt model.product.name
            , class "product-image"
            ]
            []
        , div
            [ style "position" "absolute"
            , style "top" "20px"
            , style "left" "20px"
            , style "width" "40px" 
            , style "height" "40px"
            , style "border-radius" "50%"
            , style "background-color" "#4285f4"
            , style "display" "flex"
            , style "align-items" "center"
            , style "justify-content" "center"
            ]
            [ img 
                [ src "https://xsgames.co/randomusers/assets/avatars/male/8.jpg"
                , alt "Profile"
                , style "width" "36px"
                , style "height" "36px"
                , style "border-radius" "50%"
                ]
                []
            ]
        , div 
            [ style "position" "absolute"
            , style "bottom" "20px"
            , style "left" "20px"
            , style "color" "white"
            , style "font-size" "14px"
            , style "font-weight" "bold"
            ]
            [ text "Feeling like a Neo" ]
        , button 
            [ class "show-inside-btn"
            , onClick (QuickView model.product.id)
            ] 
            [ text "SHOW INSIDE +" ]
        ]


viewProductName : Product -> Html Msg
viewProductName product =
    div [ class "product-name-container" ]
        [ div [ class "name-category" ]
            [ span [ class "product-name" ] [ text product.name ]
            , span [ class "product-category" ] [ text ("– " ++ product.category) ]
            ]
        , div [ class "product-price" ] [ text ("$" ++ String.fromFloat product.price) ]
        ]
        
        
viewProductDescription : Product -> Html Msg
viewProductDescription product =
    div [ class "product-description" ] [ text product.description ]


viewPrice : Product -> Html Msg
viewPrice product =
    div [ class "product-price" ]
        [ if product.salePrice /= Nothing then
            div [ class "price-container" ]
                [ span [ class "original-price" ] [ text ("$" ++ String.fromFloat product.price) ]
                , span [ class "sale-price" ]
                    [ text
                        ("$" ++ String.fromFloat (Maybe.withDefault 0 product.salePrice))
                    ]
                ]
          else
            span [] [ text ("$" ++ String.fromFloat product.price) ]
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
                    , viewPrice model.product
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