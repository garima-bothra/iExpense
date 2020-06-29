//
//  AddView.swift
//  iExpenses
//
//  Created by Garima Bothra on 29/06/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import SwiftUI

struct AddView: View {

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var expenses: Expenses

    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showingAlert = false
    @State private var title: String = ""
    @State private var message: String = ""

    static let types = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {

                if self.name.trimmingCharacters(in: NSCharacterSet.whitespaces) == "" {
                    self.title = "Invalid Expense Name :("
                    self.message = "Please enter a valid name!"
                    self.showingAlert = true
                    return
                }
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.title = "Invalid Amount :("
                    self.message = "Please enter a valid amount!"
                    self.showingAlert = true
                }
            })
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("Okay")))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
