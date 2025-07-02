//
//  RunDataModel.swift
//  RunNow
//
//  Created by Foundation-005 on 25/06/25.
//

import Foundation
import SwiftData

@Model
class DailyDataModel {
    var id: UUID
    var date: Date
    var bmi: Double?
    var category: String?
    var weightDifference: Double?
    var caloriesToBurn: Int?
    var name: String
    @Relationship(deleteRule: .nullify, inverse: \RunDataModel.dailyData)
    var runData: RunDataModel?

    init(id: UUID = UUID(), date: Date, bmi: Double? = nil, category: String? = nil, weightDifference: Double? = nil, caloriesToBurn: Int? = nil, name: String, runData: RunDataModel? = nil) {
        self.id = id
        self.date = date
        self.bmi = bmi
        self.category = category
        self.weightDifference = weightDifference
        self.caloriesToBurn = caloriesToBurn
        self.name = name
        self.runData = runData
    }
}

@Model
class RunDataModel {
    var distance: Double
    var duration: Double
    var caloriesBurned: Int
    var updatedWeight: Double
    var runDate: Date
    weak var dailyData: DailyDataModel?

    init(distance: Double, duration: Double, caloriesBurned: Int, updatedWeight: Double, runDate: Date, dailyData: DailyDataModel? = nil) {
        self.distance = distance
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.updatedWeight = updatedWeight
        self.runDate = runDate
        self.dailyData = dailyData
    }
}
