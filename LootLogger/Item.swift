//
//  ViewController.swift
//  LootLogger
//
//  Created by Jordan White on 10/21/25.
//

import UIKit

class Item: Equatable, Codable {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
    let itemKey: String
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
           self.name = name
           self.valueInDollars = valueInDollars
           self.serialNumber = serialNumber
           self.dateCreated = Date()
            self.itemKey = UUID().uuidString
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]

            let randomAdjective = adjectives.randomElement()!
            let randomNoun = nouns.randomElement()!

            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int.random(in: 0..<100)
            let randomSerialNumber =
                UUID().uuidString.components(separatedBy: "-").first!

            self.init(name: randomName,
                      serialNumber: randomSerialNumber,
                      valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    static func ==(lhs: Item, rhs: Item) -> Bool {
           return lhs.name == rhs.name
               && lhs.serialNumber == rhs.serialNumber
               && lhs.valueInDollars == rhs.valueInDollars
               && lhs.dateCreated == rhs.dateCreated
       }
    
    enum Category {
        case electronics
        case clothing
        case book
        case other
    }

    var category = Category.other
    
    enum CodingKeys: String, CodingKey {
        case name
        case valueInDollars
        case serialNumber
        case dateCreated
        case category
        case itemKey
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(valueInDollars, forKey: .valueInDollars)
        try container.encode(serialNumber, forKey: .serialNumber)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(itemKey, forKey: .itemKey)

        switch category {
        case .electronics:
            try container.encode("electronics", forKey: .category)
        case .clothing:
            try container.encode("clothing", forKey: .category)
        case .book:
            try container.encode("book", forKey: .category)
        case .other:
            try container.encode("other", forKey: .category)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        valueInDollars = try container.decode(Int.self, forKey: .valueInDollars)
        serialNumber = try container.decode(String?.self, forKey: .serialNumber)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        itemKey = try container.decode(String.self, forKey: .itemKey)   


        let categoryString = try container.decode(String.self, forKey: .category)
        switch categoryString {
        case "electronics":
            category = .electronics
        case "clothing":
            category = .clothing
        case "book":
            category = .book
        case "other":
            category = .other
        default:
            category = .other
        }
    }
}



