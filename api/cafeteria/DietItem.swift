//
//  DietItem.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

extension Diet {
    static let vegetarian: Self = .init(rawValue: 1<<0)
    static let vegan: Self = .init(rawValue: 1<<1)
    static let regional: Self = .init(rawValue: 1<<2)
    
    static let coloring: Self = .init(rawValue: 1<<3)
    static let preservative: Self = .init(rawValue: 1<<4)
    static let antioxidant: Self = .init(rawValue: 1<<5)
    static let flavorEnhancer: Self = .init(rawValue: 1<<6)
    static let sulphurized: Self = .init(rawValue: 1<<7)
    static let blackened: Self = .init(rawValue: 1<<8)
    static let waxed: Self = .init(rawValue: 1<<9)
    static let phosphate: Self = .init(rawValue: 1<<10)
    static let sweetener: Self = .init(rawValue: 1<<11)
    static let phenylalanine: Self = .init(rawValue: 1<<12)
    static let cocoabasedFatGlaze: Self = .init(rawValue: 1<<13)
    static let caffeine: Self = .init(rawValue: 1<<14)
    static let quinine: Self = .init(rawValue: 1<<15)
    static let animalGelatin: Self = .init(rawValue: 1<<16)
    static let animalRennet: Self = .init(rawValue: 1<<17)
    static let carmine: Self = .init(rawValue: 1<<18)
    static let sepia: Self = .init(rawValue: 1<<19)
    static let honey: Self = .init(rawValue: 1<<20)
    
    static let wheat: Self = .init(rawValue: 1<<21)
    static let rye: Self = .init(rawValue: 1<<22)
    static let barley: Self = .init(rawValue: 1<<23)
    static let oats: Self = .init(rawValue: 1<<24)
    static let spelt: Self = .init(rawValue: 1<<25)
    static let khorasanWheat: Self = .init(rawValue: 1<<26)
    static let crustacean: Self = .init(rawValue: 1<<27)
    static let chickenEgg: Self = .init(rawValue: 1<<28)
    static let fish: Self = .init(rawValue: 1<<29)
    static let peanut: Self = .init(rawValue: 1<<30)
    static let soy: Self = .init(rawValue: 1<<31)
    static let milk: Self = .init(rawValue: 1<<32)
    static let almond: Self = .init(rawValue: 1<<33)
    static let hazel: Self = .init(rawValue: 1<<34)
    static let walnut: Self = .init(rawValue: 1<<35)
    static let cashew: Self = .init(rawValue: 1<<36)
    static let pekan: Self = .init(rawValue: 1<<37)
    static let brazilNut: Self = .init(rawValue: 1<<38)
    static let pistachio: Self = .init(rawValue: 1<<39)
    static let macadamia: Self = .init(rawValue: 1<<40)
    static let celery: Self = .init(rawValue: 1<<41)
    static let mustard: Self = .init(rawValue: 1<<42)
    static let sesame: Self = .init(rawValue: 1<<43)
    static let sulfur: Self = .init(rawValue: 1<<44)
    static let lupine: Self = .init(rawValue: 1<<45)
    static let mollusk: Self = .init(rawValue: 1<<46)
    
    static let alcohol: Self = .init(rawValue: 1<<47)
    static let poultry: Self = .init(rawValue: 1<<48)
    static let garlic: Self = .init(rawValue: 1<<49)
    static let rabbit: Self = .init(rawValue: 1<<50)
    static let lamb: Self = .init(rawValue: 1<<51)
    static let beef: Self = .init(rawValue: 1<<52)
    static let pork: Self = .init(rawValue: 1<<53)
    static let gameMeat: Self = .init(rawValue: 1<<54)
    static let wildBoar: Self = .init(rawValue: 1<<55)
    
    static let gluten: Self = [.wheat, .rye, .barley, .oats, .spelt, .khorasanWheat]
}

extension Diet {
    enum Item: Int64 {
        case vegetarian = 0
        case vegan = 1
        case regional = 2
        
        case coloring = 3
        case preservative = 4
        case antioxidant = 5
        case flavorEnhancer = 6
        case sulphurized = 7
        case blackened = 8
        case waxed = 9
        case phosphate = 10
        case sweetener = 11
        case phenylalanine = 12
        case cocoabasedFatGlaze = 13
        case caffeine = 14
        case quinine = 15
        case animalGelatin = 16
        case animalRennet = 17
        case carmine = 18
        case sepia = 19
        case honey = 20
        
        case wheat = 21
        case rye = 22
        case barley = 23
        case oats = 24
        case spelt = 25
        case khorasanWheat = 26
        case crustacean = 27
        case chickenEgg = 28
        case fish = 29
        case peanut = 30
        case soy = 31
        case milk = 32
        case almond = 33
        case hazel = 34
        case walnut = 35
        case cashew = 36
        case pekan = 37
        case brazilNut = 38
        case pistachio = 39
        case macadamia = 40
        case celery = 41
        case mustard = 42
        case sesame = 43
        case sulfur = 44
        case lupine = 45
        case mollusk = 46
        
        case alcohol = 47
        case poultry = 48
        case garlic = 49
        case rabbit = 50
        case lamb = 51
        case beef = 52
        case pork = 53
        case gameMeat = 54
        case wildBoar = 55
    }
}

extension Diet.Item: CustomStringConvertible {
    var description: String {
        switch self {
        case .vegetarian: "Vegetarian"
        case .vegan: "Vegan"
        case .regional: "Regional"
        
        case .coloring: "Coloring"
        case .preservative: "Preservative"
        case .antioxidant: "Antioxidant"
        case .flavorEnhancer: "Flavor Enhancer"
        case .sulphurized: "Sulphurized"
        case .blackened: "Blackened"
        case .waxed: "Waxed"
        case .phosphate: "Phosphate"
        case .sweetener: "Sweetener"
        case .phenylalanine: "Phenylalanine"
        case .cocoabasedFatGlaze: "Cocoabased Fat Glaze"
        case .caffeine: "Caffeine"
        case .quinine: "Quinine"
        case .animalGelatin: "Animal Gelatin"
        case .animalRennet: "Animal Rennet"
        case .carmine: "Carmine"
        case .sepia: "Sepia"
        case .honey: "Honey"
        
        case .wheat: "Wheat"
        case .rye: "Rye"
        case .barley: "Barley"
        case .oats: "Oats"
        case .spelt: "Spelt"
        case .khorasanWheat: "Khorasan Wheat"
        case .crustacean: "Crustacean"
        case .chickenEgg: "Chicken Egg"
        case .fish: "Fish"
        case .peanut: "Peanut"
        case .soy: "Soy"
        case .milk: "Milk"
        case .almond: "Almond"
        case .hazel: "Hazel"
        case .walnut: "Walnut"
        case .cashew: "Cashew"
        case .pekan: "Pekan"
        case .brazilNut: "Brazil Nut"
        case .pistachio: "Pistachio"
        case .macadamia: "Macadamia"
        case .celery: "Celery"
        case .mustard: "Mustard"
        case .sesame: "Sesame"
        case .sulfur: "Sulfur"
        case .lupine: "Lupine"
        case .mollusk: "Mollusk"
        
        case .alcohol: "Alcohol"
        case .poultry: "Poultry"
        case .garlic: "Garlic"
        case .rabbit: "Rabbit"
        case .lamb: "Lamb"
        case .beef: "Beef"
        case .pork: "Pork"
        case .gameMeat: "Game Meat"
        case .wildBoar: "Wild Boar"
        }
    }
}

extension Diet.Item: Hashable { }
extension Diet.Item: CaseIterable { }

extension Diet {
    init(item: Item) {
        self.init(rawValue: 1 << item.rawValue)
    }
    
    init(items: [Item]) {
        var rawValue: Int64 = 0
        
        for item in items {
            rawValue |= 1 << item.rawValue
        }
        
        self.init(rawValue: rawValue)
    }
}

extension Diet.Item {
    var diet: Diet {
        .init(item: self)
    }
}
