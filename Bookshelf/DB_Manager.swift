//
//  DB_Manager.swift
//  Bookshelf
//
//  Created by Anna Gutowska on 9/16/23.
//

import Foundation
import SQLite

class DB_Manager {
    
    private var db: Connection!
    private var books: Table!
    private var id: Expression<Int64>!
    private var title: Expression<String>!
    private var author: Expression<String>!
    private var genre: Expression<String>!
    
    
    init () {
        
        do {
            
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask ,true).first ?? ""
            db = try Connection("\(path)/my_books.sqlite3")
            books = Table("books")
            id = Expression<Int64>("id")
            title = Expression<String>("title")
            author =  Expression<String>("author")
            genre = Expression<String>("genre")
            
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                
                try db.run(books.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(title)
                    t.column(author)
                    t.column(genre)
                    
                })
                
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func addBook(titleValue: String, authorValue: String, genreValue: String) {
        do {
            try db.run(books.insert(title <- titleValue, author <- authorValue, genre <- genreValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteBook(idValue: Int64) {
        do {
            let book: Table = books.filter(id == idValue)
            try db.run(book.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getBooks() -> [BookModel] {
         
        var bookModels: [BookModel] = []
        books = books.order(id.desc)
     
        do {
            for book in try db.prepare(books) {
     
                let bookModel: BookModel = BookModel()
     
                bookModel.id = book[id]
                bookModel.title = book[title]
                bookModel.author = book[author]
                bookModel.genre = book[genre]
     
                bookModels.append(bookModel)
            }
        } catch {
            print(error.localizedDescription)
        }
     
        return bookModels
    }
    
    public func getBook(idValue: Int64) -> BookModel {
     
        let bookModel: BookModel = BookModel()
         
        do {
     
            let book: AnySequence<Row> = try db.prepare(books.filter(id == idValue))
     
            try book.forEach({ (rowValue) in
     
                bookModel.id = try rowValue.get(id)
                bookModel.title = try rowValue.get(title)
                bookModel.author = try rowValue.get(author)
                bookModel.genre = try rowValue.get(genre)
            })
        } catch {
            print(error.localizedDescription)
        }
     
        return bookModel
    }
    
    public func updateBook(idValue: Int64, titleValue: String, authorValue: String, genreValue: String) {
        do {
            let book: Table = books.filter(id == idValue)
             
            try db.run(book.update(title <- titleValue, author <- authorValue, genre <- genreValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
