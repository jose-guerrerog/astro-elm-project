module ProductData exposing (ColorOption, Product, getWallets)


type alias ColorOption =
    { name : String
    , hex : String
    , imageUrl : String
    }


type alias Product =
    { id : Int
    , name : String
    , category : String
    , price : Float
    , description : String
    , colorOptions : List ColorOption
    , features : List String
    , rating : Float
    }


getWallets : List Product
getWallets =
    [ { id = 1
      , name = "Flip Case"
      , category = "RFID safe"
      , price = 129.00
      , description = "Card wallet for 6 – 8 cards, folded bills"
      , colorOptions =
            [ { name = "Blue", hex = "#3F5D7D", imageUrl = "/images/flip-case-blue.png" }
            , { name = "Green", hex = "#3A5F41", imageUrl = "/images/flip-case-green.png" }
            , { name = "Brown", hex = "#A05B3B", imageUrl = "/images/flip-case-brown.png" }
            ]
      , features =
            [ "Quick access card slots"
            , "RFID protection"
            , "Premium, environmentally certified leather"
            , "3 year warranty"
            ]
      , rating = 4.8
      }
    , { id = 2
      , name = "Slim Sleeve"
      , category = "Carryology Essentials Edition"
      , price = 119.00
      , description = "Billfold for 5 – 11 cards, folded bills"
      , colorOptions =
            [ { name = "Black", hex = "#000000", imageUrl = "/images/slim-sleeve-black.png" }
            ]
      , features =
            [ "Magnetic closure mechanism"
            , "Holds 6-8 cards and cash"
            , "Premium, environmentally certified leather"
            , "5 year warranty"
            ]
      , rating = 4.9
      }
    , { id = 3
      , name = "Travel Wallet"
      , category = "RFID safe"
      , price = 199.00
      , description = "Passport holder for 4 – 10+ cards, flat bills, passport, pen, tickets"
      , colorOptions =
            [ { name = "Green", hex = "#3A5F41", imageUrl = "/images/travel-wallet-green.png" }
            , { name = "Brown", hex = "#A05B3B", imageUrl = "/images/travel-wallet-brown.png" }
            ]
      , features =
            [ "RFID protection"
            , "Passport pocket"
            , "Ticket and boarding pass section"
            , "SIM card storage"
            , "Micro travel pen included"
            ]
      , rating = 4.9
      }
    ]