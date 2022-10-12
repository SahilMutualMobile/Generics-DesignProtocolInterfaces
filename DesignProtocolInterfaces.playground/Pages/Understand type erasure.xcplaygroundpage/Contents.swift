//: [Previous](@previous)

import Foundation


//Protocols with associated types interact with existential 'any' types, by explaining how 'result type erasure' works

//existential types == types with any keyword

protocol AnimalFeed {
    var str: String { get }
}

struct Scratch: AnimalFeed {
    var str: String = "Scratch"
}
struct Hay: AnimalFeed {
    var str: String = "Hay"
}

protocol Animal {
    associatedtype CommodityType: Food
    associatedtype FeedType: AnimalFeed
    
    func produce() -> CommodityType //method has associated type in producing position (right-side of the arrow)
    
    func eat(_: FeedType) //method has associated type in consuming position
    //Type erasure does not allow us to work with associated types in consuming position. Instead, you must unbox the existential 'any' type by passing it to a function that takes an opaque 'some' type.
}

struct Chicken: Animal {
    typealias CommodityType = Egg
    
    typealias FeedType = Scratch
    
    func eat(_: Scratch) {
        print("This chicken is eating!")
    }
    
    func produce() -> Egg {
        return Egg()
    }
}

struct Cow: Animal {
    typealias CommodityType = Milk
    
    typealias FeedType = Hay
    
    func eat(_: Hay) {
        print("This cow is eating!")
    }
    
    func produce() -> Milk {
        return Milk()
    }
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

struct Farm {
    var animals: [any Animal]
    
    func produceCommodities() -> [any Food] {
        //The 'animal' parameter in the map() closure has type 'any Animal'. The return type of 'produce()' is an associated type. When you call a method returning an associated type on an existential type, the compiler will use type erasure to determine the result type of the call. Type erasure replaces these associated types with corresponding existential types that have equivalent constraints. We've erased the relationship between the concrete Animal type and the associated CommodityType by replacing them with 'any Animal' and 'any Food'. The type 'any Food' is called the upper bound of the associated CommodityType. Since the produce() method is called on an 'any Animal', the return value is type erased, giving us a value of type 'any Food'. This is exactly the type we expect here.
        
        return animals.map { animal in
            animal.produce()
        }
    }
}
let farm = Farm(animals: [Chicken(), Cow(), Cow()])

let produce = farm.produceCommodities()
print(produce)

//Recap
//1. 'Any' now supports protocols with associated types
//2. Associated types in producing position are type erased to their upper bound (any Concrete-type)

//we explored when type erasure is safe, and when we need to be in a context where type relationships are guaranteed.
//: [Next](@next)
