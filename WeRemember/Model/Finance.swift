//
//  Finance.swift
//  WeRemember
//
//  Created by Alice on 2022/11/14.
//

import Foundation

struct Finance: Codable {
    var date: Date
    var amount: Int
    var category: String
    var account: String
    var memo: String
    var isExpense: Bool
    var additionalPic: Data
    
    
    static func loadFinances() -> [Finance]? {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: "finances") else {return nil}
        let decoder = JSONDecoder()
        return try? decoder.decode([Finance].self, from: data)
    }
    
    static func saveFinances(_ finances:[Finance]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(finances) else {return}
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "finances")
    }
    
    
}

struct Spend {
    static var expenseCategories: [ExpenseCategory] {
        ExpenseCategory.allCases
    }
    static var incomeCategories: [IncomeCategory] {
        IncomeCategory.allCases
    }
    static var account: [Account] {
        Account.allCases
    }
    
}
