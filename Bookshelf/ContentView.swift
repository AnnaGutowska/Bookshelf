//
//  ContentView.swift
//  Bookshelf
//
//  Created by Anna Gutowska on 9/14/23.
//

import SwiftUI
struct ContentView: View {
    @State var bookModels: [BookModel] = []
    @State var bookSelected: Bool = false
    @State var selectedBookId: Int64 = 0
    
    var body: some View {
        NavigationView {
            VStack {
                
                NavigationLink (destination: EditBookView(id: self.$selectedBookId), isActive: self.$bookSelected) {
                    
                }
                
                HStack {
                    Spacer()
                    NavigationLink (destination: AddBookView(), label: {
                        Text("Add Book")
                    }).font(.subheadline)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                
                List (self.bookModels) { (model) in
                    HStack {
                        Text(model.title)
                        Spacer()
                        Text(model.author)
                        Spacer()
                        Text(model.genre)
                        
                        Button(action: {
                            self.selectedBookId = model.id
                            self.bookSelected = true
                        }, label: {
                            Text("Edit")
                                .foregroundColor(Color.blue)
                                
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            let dbManager: DB_Manager = DB_Manager()
                            
                            dbManager.deleteBook(idValue: model.id)
                            
                            self.bookModels = dbManager.getBooks()
                        }, label: {
                            Text("Delete")
                                .foregroundColor(Color.red)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
            }.padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("**Your Bookshelf**").font(.largeTitle).foregroundColor(Color.white)
                    }
                }
            }
            .modifier(BackgroundImage())
            .onAppear (perform: {
                self.bookModels = DB_Manager().getBooks()

            })
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BackgroundImage: ViewModifier {
    func body(content: Content) -> some View {
        
        content
            .opacity(0.8)
            .background(Image("shelves")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            )
        
    }
}

