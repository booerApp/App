//
//  AddChallengeHelper.swift
//  EBookTracking
//
//  Created by Veit Progl on 04.03.21.
//

import Foundation
import SwiftUI

struct bookPicker: View {
    @ObservedObject var addChallangeData = AddChallangeData()
    @ObservedObject var data = challengeData(bookTitle: "select a book")
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true)], predicate: NSPredicate(format: "done != true"), animation: .default)
    private var items: FetchedResults<Book>
    
    var body: some View {
        VStack() {
            HStack() {
                Text("the book:").font(.title).bold()
                Spacer()
                Menu(self.data.bookTitle) {
                    Button(action: {
                        self.data.bookTitle = "select a book"
                        self.data.bookID = "-404"
                        self.data.book = nil
                        print(self.data)
                    }, label: {
                        Text("select a book")
                    })
                    ForEach(items) { book in
                        Button(action: {
                            self.data.bookTitle = book.title ?? "error"
                            self.data.bookID = book.id ?? "-404"
                            self.data.book = book
                            print(self.data)
                        }, label: {
                            Text("\(book.title ?? "error")")
                        })
                    }
                }.background(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(addChallangeData.isNotValid ? Color.red : Color.secondary, lineWidth: 1)
                )
            }
        }
    }
}

struct daysTextField: View {
    @ObservedObject var addChallangeData = AddChallangeData()

    var body: some View {
        HStack() {
            Text("for")
                .font(.title)
                .bold()
            Spacer()
            TextField("10", text: $addChallangeData.time)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(addChallangeData.isNotValid ? Color.red : Color.secondary, lineWidth: 1)
                )
            Text("days")
                .font(.title)
                .bold()
        }
    }
}
