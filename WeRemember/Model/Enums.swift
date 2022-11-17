//
//  Enums.swift
//  WeRemember
//
//  Created by alice812 on 2022/11/8.
//

import Foundation

//列舉資料類型: 必填資料/選填資料
enum DataType: String, CaseIterable {
    case requiredData
    case additionalData
}

//列舉必填資料欄位
enum RequiredData: String, CaseIterable {
    case date, amount, category, account
}

//列舉選填資料欄位
enum additionalData: String, CaseIterable {
    case photo, memo
}

//列舉必填資料欄位中的消費category
enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "餐飲"
    case transportation = "交通"
    case grocery = "日常用品"
    case shopping = "購物"
    case entertainment = "娛樂"
    case bill = "帳單"
    case other = "其他"
}

//列舉必填資料欄位中的收入category
enum IncomeCategory: String, CaseIterable, Codable {
    case salary = "薪資"
    case bonus = "獎金"
    case investmant = "投資"
    case wedding = "禮金"
}

//列舉必填資料欄位中的帳戶
enum Account: String, CaseIterable, Codable {
    case cash = "現金"
    case bank = "銀行"
    case creditCard = "信用卡"
}

