//: [Previous](@previous)

import Foundation

// Using opaque result types to improve encapsulation by separating interface from implementation.

protocol Animal {
    var isHungry: Bool { get }
}

struct Chicken: Animal {
    var isHungry: Bool = true
}

struct Cow: Animal {
    var isHungry: Bool = false
}

struct Farm {
    var animals: [any Animal]
}
extension Farm {
    //Constrained opaque result type(New is Swift 5.7), For the Collection the Element associated type(which is a primary associated type) is equal to 'any Animal'
    //Constrained existensial types == any Collection<any Animal>
    //Constrained opaque types == some Collection<any Animal>
    //We can declare custom protocols to have primary associated types
    var hungryAnimals: some Collection<any Animal> {
        animals.lazy.filter(\.isHungry)
    }
    func feedAnimals() {
        for animal in hungryAnimals {
            print(animal)
        }
    }
}

let farm = Farm(animals: [Chicken(), Cow(), Cow(), Chicken()])
farm.feedAnimals()

//we discussed how to strike the right balance between preserving rich type information and hiding implementation details using primary associated types, which can be used with both opaque result types and existential types.

//: [Next](@next)
