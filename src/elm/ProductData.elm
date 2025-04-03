module ProductData exposing (Color, Product, getWallets)


type alias Color =
    { name : String
    , hex : String
    }


type alias Product =
    { id : Int
    , name : String
    , category : String
    , price : Float
    , salePrice : Maybe Float
    , description : String
    , images : List String
    , colorImages : List String  -- Images for different color variants
    , colors : List Color
    , features : List String
    , isInStock : Bool
    , rating : Float
    }


getWallets : List Product
getWallets =
    [ { id = 1
      , name = "Flip Case"
      , category = "RFID safe"
      , price = 129.00
      , salePrice = Nothing
      , description = "Card wallet for 6 – 8 cards, folded bills"
      , images =
            [ "/images/flip-case-brown.png" ]
      , colorImages =
            [ "/images/flip-case-blue.png"   -- Blue
            , "/images/flip-case-green.png"  -- Green
            , "/images/flip-case-brown.png"  -- Brown
            ]
      , colors =
            [ { name = "Blue", hex = "#3F5D7D" }
            , { name = "Green", hex = "#3A5F41" }
            , { name = "Brown", hex = "#A05B3B" }
            ]
      , features =
            [ "Quick access card slots"
            , "RFID protection"
            , "Premium, environmentally certified leather"
            , "3 year warranty"
            ]
      , isInStock = True
      , rating = 4.8
      }
    , { id = 2
      , name = "Slim Sleeve"
      , category = "Carryology Essentials Edition"
      , price = 119.00
      , salePrice = Nothing
      , description = "Billfold for 5 – 11 cards, folded bills"
      , images =
            [ "/images/slim-sleeve-black.png" ]
      , colorImages =
            [ "/images/slim-sleeve-black.png" ]
      , colors =
            [ { name = "Black", hex = "#000000" }
            ]
      , features =
            [ "Magnetic closure mechanism"
            , "Holds 6-8 cards and cash"
            , "Premium, environmentally certified leather"
            , "5 year warranty"
            ]
      , isInStock = True
      , rating = 4.9
      }
    , { id = 3
      , name = "Travel Wallet"
      , category = "RFID safe"
      , price = 199.00
      , salePrice = Nothing
      , description = "Passport holder for 4 – 10+ cards, flat bills, passport, pen, tickets"
      , images =
            [ "/images/travel-wallet-brown.png" ]
      , colorImages =
            [ "/images/travel-wallet-green.png"  -- Green
            , "/images/travel-wallet-brown.png"  -- Brown
            ]
      , colors =
            [ { name = "Green", hex = "#3A5F41" }
            , { name = "Brown", hex = "#A05B3B" }
            ]
      , features =
            [ "RFID protection"
            , "Passport pocket"
            , "Ticket and boarding pass section"
            , "SIM card storage"
            , "Micro travel pen included"
            ]
      , isInStock = True
      , rating = 4.9
      }
    ]