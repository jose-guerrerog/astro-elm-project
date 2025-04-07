module ProductCardTest exposing (suite)

import Expect
import ProductCard exposing (Model, Msg(..), init, update, view)
import ProductData exposing (Product, getWallets)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


-- Get the first product for testing
testProduct : Product
testProduct =
    List.head getWallets
        |> Maybe.withDefault
            { id = 0
            , name = ""
            , category = ""
            , price = 0
            , description = ""
            , images = []
            , colorImages = []
            , colors = []
            , features = []
            , isInStock = False
            , rating = 0
            }


initialModel : Model
initialModel =
    init testProduct


suite : Test
suite =
    describe "ProductCard"
        [ describe "init"
            [ test "initializes with the correct product" <|
                \_ ->
                    let
                        model =
                            init testProduct
                    in
                    Expect.equal model.product testProduct
            , test "initializes with default values" <|
                \_ ->
                    let
                        model =
                            init testProduct
                    in
                    Expect.all
                        [ \m -> Expect.equal m.isHovered False
                        , \m -> Expect.equal m.selectedColorIndex 0
                        ]
                        model
            ]
        , describe "update"
            [ test "MouseEnter sets isHovered to True" <|
                \_ ->
                    let
                        ( updatedModel, _ ) =
                            update MouseEnter initialModel
                    in
                    Expect.equal updatedModel.isHovered True
            , test "MouseLeave sets isHovered to False" <|
                \_ ->
                    let
                        hoveredModel =
                            { initialModel | isHovered = True }

                        ( updatedModel, _ ) =
                            update MouseLeave hoveredModel
                    in
                    Expect.equal updatedModel.isHovered False
            , test "SelectColor updates the selected color index" <|
                \_ ->
                    let
                        ( updatedModel, _ ) =
                            update (SelectColor 2) initialModel
                    in
                    Expect.equal updatedModel.selectedColorIndex 2
            ]
        , describe "view"
            [ test "renders the product name" <|
                \_ ->
                    if testProduct.name /= "" then
                        view initialModel
                            |> Query.fromHtml
                            |> Query.find [ Selector.class "product-name" ]
                            |> Query.has [ Selector.text testProduct.name ]
                    else
                        Expect.pass
            , test "renders the product category" <|
                \_ ->
                    if testProduct.category /= "" then
                        view initialModel
                            |> Query.fromHtml
                            |> Query.find [ Selector.class "product-category" ]
                            |> Query.has [ Selector.text ("– " ++ testProduct.category) ]
                    else
                        Expect.pass
            , test "renders the product price" <|
                \_ ->
                    view initialModel
                        |> Query.fromHtml
                        |> Query.find [ Selector.class "product-price" ]
                        |> Query.has [ Selector.text ("$" ++ String.fromFloat testProduct.price) ]
            , test "renders color options if available" <|
                \_ ->
                    if List.length testProduct.colors > 0 then
                        view initialModel
                            |> Query.fromHtml
                            |> Query.findAll [ Selector.class "color-option" ]
                            |> Query.count (Expect.equal (List.length testProduct.colors))
                    else
                        Expect.pass
            , test "renders the product description" <|
                \_ ->
                    if testProduct.description /= "" then
                        view initialModel
                            |> Query.fromHtml
                            |> Query.find [ Selector.class "product-description" ]
                            |> Query.has [ Selector.text testProduct.description ]
                    else
                        Expect.pass
            ]
        , describe "hover behavior"
            [ test "does not show 'SHOW INSIDE +' button when not hovered" <|
                \_ ->
                    view initialModel
                        |> Query.fromHtml
                        |> Query.hasNot [ Selector.class "show-inside-btn" ]
            , test "shows 'SHOW INSIDE +' button when hovered" <|
                \_ ->
                    let
                        hoveredModel =
                            { initialModel | isHovered = True }
                    in
                    view hoveredModel
                        |> Query.fromHtml
                        |> Query.find [ Selector.class "show-inside-btn" ]
                        |> Query.has [ Selector.text "SHOW INSIDE +" ]
            ]
        ]