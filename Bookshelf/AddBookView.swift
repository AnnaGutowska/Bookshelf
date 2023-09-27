//
//  AddBookView.swift
//  Bookshelf
//
//  Created by Anna Gutowska on 9/16/23.
//

import SwiftUI
 
struct AddBookView: View {
     
    @State var title: String = ""
    @State var author: String = ""
    @State private var genre = "Fiction"
    let genreslst = ["Fiction", "Mystery", "Horror", "Romance", "Young Adult", "Fantasy"]
     
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
     
    var body: some View {
         
        VStack {
            TextField("Enter title", text: $title)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
             
            TextField("Enter author", text: $author)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
             
            Picker("Select genre", selection: $genre) {
                ForEach(genreslst, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(5)
             
            Button(action: {
                DB_Manager().addBook(titleValue: self.title, authorValue: self.author, genreValue: self.genre)
                 
                // go back to home page
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Add Book")
            })
                //.frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
            
        }.padding()
            
         
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
