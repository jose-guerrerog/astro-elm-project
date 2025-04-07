module ProductCard exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave)
import ProductData exposing (Product)


-- MODEL

type alias Model =
    { product : Product
    , isHovered : Bool
    , selectedColorIndex : Int
    }


init : Product -> Model
init product =
    { product = product
    , isHovered = False
    , selectedColorIndex = 0
    }


-- UPDATE

type Msg
    = MouseEnter
    | MouseLeave
    | SelectColor Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseEnter ->
            ( { model | isHovered = True }, Cmd.none )

        MouseLeave ->
            ( { model | isHovered = False }, Cmd.none )
            
        SelectColor colorIndex ->
            ( { model | selectedColorIndex = colorIndex }, Cmd.none )


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
            , viewColorOptions model model.product
            , div [ class "product-description" ] [ text model.product.description ]
            ]
        ]


viewProductImage : Model -> Html Msg
viewProductImage model =
    let
        imageUrl =
            if model.selectedColorIndex < List.length model.product.colorImages then
                -- Get the image at the selected index
                Maybe.withDefault 
                    (List.head model.product.images |> Maybe.withDefault "") 
                    (List.head (List.drop model.selectedColorIndex model.product.colorImages))
            else
                -- Fallback to first image if index is out of bounds
                List.head model.product.images |> Maybe.withDefault ""
    in
    div [ class "product-image-container" ]
        [ img
            [ src imageUrl
            , alt model.product.name
            , class "product-image"
            ]
            []
        , if model.isHovered then
            button 
                [ class "show-inside-btn" ] 
                [ text "SHOW INSIDE +" ]
          else
            text ""
        ]


viewColorOptions : Model -> Product -> Html Msg
viewColorOptions model product =
    div [ class "color-options" ]
        (List.indexedMap
            (\index color ->
                button
                    [ class 
                        (if index == model.selectedColorIndex then
                            "color-option color-option-selected"
                         else
                            "color-option"
                        )
                    , style "background-color" color.hex
                    , title color.name
                    , onClick (SelectColor index)
                    ]
                    []
            )
            product.colors
        )