import SwiftUI


protocol Crop {
    var str: String { get }
    associatedtype FeedType: AnimalFeed
    func harvest() -> FeedType
}
protocol Food {
    var str: String { get }
}
struct Egg: Food {
    var str: String = "Egg"
}

struct Milk: Food {
    var str: String = "Milk"
}

protocol AnimalFeed {
    var str: String { get }
    associatedtype CropType: Crop
    static func grow() -> CropType
}
struct Hay: AnimalFeed {
    var str: String = "Hay"
    
    static func grow() -> Alfalfa {
        return Alfalfa()
    }
}

struct Alfalfa: Crop {
    var str: String = "Alfalfa"
    
    func harvest() -> Hay {
        return Hay()
    }
}
struct Scratch: AnimalFeed {
    var str: String = "Scratch"
    
    static func grow() -> Millet {
        return Millet()
    }
}
struct Millet: Crop {
    var str: String = "Millet"
    
    func harvest() -> Scratch {
        return Scratch()
    }
}

let cow = Cow()
let alfalfa = Hay.grow()
let hay = alfalfa.harvest()
cow.eat(hay)

let chicken = Chicken()
let millet = Scratch.grow()
let scratch = millet.harvest()
chicken.eat(scratch)

protocol Animal {
    associatedtype CommodityType: Food
    associatedtype FeedType: AnimalFeed
    
    func produce() -> CommodityType
    func eat(_: FeedType)
    
    var isHungry: Bool { get }
}

struct Chicken: Animal {
    
    func eat(_: Scratch) {
        print("Eating scratch")
    }
    
    typealias FeedType = Scratch

    var isHungry: Bool = false
    
    func produce() -> Egg {
        return Egg()
    }
}

struct Cow: Animal {
    func eat(_: Hay) {
        print("Eating Hay")
    }
    
    typealias FeedType = Hay
    
    var isHungry: Bool = false
    
    func produce() -> Milk {
        return Milk()
    }
}

struct Farm {
    var isLazy = true
    var animals: [any Animal]
    
    func produceCommodities() -> [any Food] {
        return animals.map { animal in
            animal.produce()
        }
    }
}

extension Farm {
    
    var hungryAnimals: some Collection<any Animal> {
        return animals.lazy.filter(\.isHungry)
    }
    
    func feedAnimals() {
        for animal in hungryAnimals {
            feedAnimal(animal)
        }
    }
    private func feedAnimal(_ animal: some Animal) {
        let crop = type(of: animal).FeedType.grow()
        let feed = crop.harvest()
        animal.eat(feed)
    }
}
