//: [Previous](@previous)

import Foundation

//Same-type requirements in protocols can model relationships between multiple different sets of concrete types.

//  Let's look at AnimalFeed. Every protocol has a 'Self' type, which stands for the concrete conforming type. Our protocol has an associated 'CropType', which conforms to Crop. The associated 'CropType' has a nested associated 'FeedType', which conforms to AnimalFeed, which has a nested associated 'CropType' conforming to Crop, and so on. In fact, this back-and-forth continues forever, with an infinite nesting of associated types that alternate between conforming to AnimalFeed and Crop.
protocol AnimalFeed {
    associatedtype CropType: Crop
        //  We can express the relationship between these associated types using a same-type requirement, written in a 'where' clause. A same-type requirement expresses a static guarantee that two different, possibly nested associated types must in fact be the same concrete type. Adding a same-type requirement here imposes a restriction on the concrete types that conform to the AnimalFeed protocol.
        where CropType.FeedType == Self 
    static func grow() -> CropType
    var str: String { get }
}

//  With the Crop protocol, we have a similar situation, just shifted by one. We start with the 'Self' type, conforming to 'Crop', which has an associated 'FeedType', conforming to AnimalFeed. This has a nested associated 'CropType', conforming to Crop and so on...
protocol Crop {
    associatedtype FeedType: AnimalFeed
        //  Here, the Crop's FeedType has collapsed down to a pair of types, but we still have one too many associated types. We want to say that the Crop's FeedType's Crop Type is the same type as the Crop that we originally started with.
        where FeedType.CropType == Self
    func harvest() -> FeedType
    var str: String { get }
    
}

protocol Animal {
    var isHungry: Bool { get }
    
    associatedtype FeedType: AnimalFeed
    func eat(_: FeedType)
}
//Set 1-Start
struct Cow: Animal {
    var isHungry: Bool = false
    
    func eat(_: Hay) {
        print("This cow is eating!")
    }
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

//let cow = Cow()
//let alfalfa = Hay.grow()
//let hay = alfalfa.harvest()
//cow.eat(hay)
//Set 1-End

//Set 2-Start
struct Chicken: Animal {
    var isHungry: Bool = true
    
    func eat(_: Scratch) {
        print("This chicken is eating!")
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

//let chicken = Chicken()
//let millet = Scratch.grow()
//let scratch = millet.harvest()
//chicken.eat(scratch)
//Set 2-End

struct Farm {
    var animals: [any Animal]
    var hungryAnimals: some Collection<any Animal> {
        animals.lazy.filter(\.isHungry)
    }
}
extension Farm {
    func feedAnimals() {
        for animal in hungryAnimals {
            feedAnimal(animal)
        }
    }
    private func feedAnimal(_ animal: some Animal) {
        let crop = type(of: animal).FeedType.grow()
        let feed = crop.harvest()
        animal.eat(feed) // Error: Cannot convert value of type '(some Animal).FeedType.CropType.FeedType' (associated type of protocol 'Crop') to expected argument type '(some Animal).FeedType' (associated type of protocol 'Animal').
        //Error gone after where clauses used in AnimalFeed and Crop protocols
    }
}

//By understanding your data model, you can use same-type requirements to define equivalences between these different nested associated types. Generic code can then rely on these relationships when chaining together multiple calls to protocol requirements.

let farm = Farm(animals: [Cow(), Chicken(), Cow()])
farm.feedAnimals()

//we saw how to identify and guarantee type relationships between sets of concrete types using same-type requirements across the protocols that represent those related sets of types.



//: [Next](@next)
