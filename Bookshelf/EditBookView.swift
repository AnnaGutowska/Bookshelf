
import SwiftUI
 
struct EditBookView: View {
     
    @Binding var id: Int64
    @State var author: String = ""
    @State var title: String = ""
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
                DB_Manager().updateBook(idValue: self.id, titleValue: self.title, authorValue: self.author, genreValue: self.genre)
 
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Confirm Edit")
            })
                .padding(.top, 10)
                .padding(.bottom, 10)
        }.padding()
 
        .onAppear(perform: {
             
            let bookModel: BookModel = DB_Manager().getBook(idValue: self.id)
             
            self.title = bookModel.title
            self.author = bookModel.author
            self.genre = bookModel.genre
        })
    }
}
 
struct EditBookView_Previews: PreviewProvider {
     
    @State static var id: Int64 = 0
     
    static var previews: some View {
        EditBookView(id: $id)
    }
}
