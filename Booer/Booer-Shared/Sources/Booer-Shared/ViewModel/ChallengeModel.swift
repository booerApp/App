//
//  ChallengeModel.swift
//  EBookTracking
//
//  Created by Veit Progl on 07.01.21.
//

import Foundation
import Combine
import CoreData

public class CalcChallengeDays: CalcChallengeDaysProtocol {
    public func readDays(challenge: Challenges) -> Set<Date> {
        let start = challenge.start?.removeTime() ?? Date().removeTime()
        let end = Calendar.current.date(byAdding: .day, value: Int(challenge.time), to: challenge.start!)!.removeTime()

        var dates = Set<Date>()
        var check = start

        while check <= end {
            dates.insert(check)
            check = Calendar.current.date(byAdding: .day, value: 1, to: check)!.removeTime()
        }

        return dates
    }
    
    public func neededDays(challenge: Challenges) -> Set<Date> {
        if challenge.challengeBook != nil {
            var days = challenge.challengeBook!.bookProgress!.map({
                ($0 as! ReadProgress).date!.removeTime()
            })
            days = days.filter { item in
                return item >= challenge.start!.removeTime()
            }
            return Set(days)
        } else {
            return Set()
        }
    }
}

public class ChallengeModel: ChallengeModelProtocol {
    var challenge: Challenges
    var readDays: Set<Date> = []
    var days: Set<Date> = []
    
    var context: NSManagedObjectContext
    
    internal var bookIsRead = false
        
    init(challenge: Challenges,
         context: NSManagedObjectContext,
         days: CalcChallengeDaysProtocol = CalcChallengeDays()) {
        self.context = context
        self.challenge = challenge
       
        self.readDays = days.neededDays(challenge: challenge)
        self.days = days.neededDays(challenge: challenge)
    }
    
    public func calcStreak() {
        print("===== \(challenge.challengeBook?.title ?? "ww") ======")
        print("===== \(challenge.time) ======")
        print(Array(readDays).sorted())
        print(Array(days).sorted())
        print(readDays.isSubset(of: days))
        
        if !readDays.isEmpty {
            if readDays.isSubset(of: days) {
                challenge.isFailed = false
                challenge.streak = Int16(readDays.count)
            } else {
                challenge.streak = 0
                challenge.isFailed = true
                challenge.isDone = false
            }
        } else {
            challenge.streak = 0
            challenge.isFailed = false
        }
    }
    
    @discardableResult public func setDone() -> Bool {
        if readDays.max() != nil {
            let end = Calendar.current.date(byAdding: .day, value: Int(challenge.time) - 1, to: challenge.start!)!
            if readDays.max()?.removeTime() == end.removeTime() {
                challenge.isDone = true
            } else if challenge.challengeBook?.done ?? bookIsRead {
                challenge.isDone = true
            } else {
                challenge.isDone = false
            }
            return true
        }
        return false
    }
    
    @discardableResult private func setProgress(read: Float, date:Date = Date()) -> Bool {
        if read > challenge.challengeBook!.pages {
            return true
        } else {
            challenge.challengeBook!.progress = read
            
            let progress = ReadProgress(context: context)
            progress.date = date
            progress.progress = Int64(read)
            progress.bookid = challenge.challengeBook!.id
            challenge.challengeBook!.addToBookProgress(progress)
            
            return false
        }
    }
    
    public func saveItem() {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension Date {
    public func getDay() -> Int {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return components.day!
    }
    
    public func removeTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
}
