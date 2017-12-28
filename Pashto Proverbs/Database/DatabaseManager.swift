//
//  DatabaseManager.swift
//  Pashto Proverbs
//
//  Created by Maihan Nijat on 2017-12-17.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//
import SQLite

class DatabaseManager {
    
    // Properties
    var db: Connection?
    var databaseUrl: URL?
    
    // Table
    let table = Table("proverbs")
    
    // Columns
    let id = Expression<Int>("id")
    let category = Expression<String>("category")
    let proverb = Expression<String>("proverb")
    let fav = Expression<Int>("fav")
    
    init() {
        // Path to database file
        do {
            let documentDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            databaseUrl = documentDir.appendingPathComponent("database.sqlite3")
            
            // Copy database for the first time from bundle to the documents directory
            copyDatabaseIfNeeded()
            
            // Create connection
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            db = try Connection("\(path)/database.sqlite3")

        } catch {
            print(error)
        }
    }
    
    // Copy database
    func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let databaseUrl = documentsUrl.first!.appendingPathComponent("database.sqlite3")
        
        if !( (try? databaseUrl.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("database.sqlite3")
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: databaseUrl.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Database file found at path: \(databaseUrl.path)")
        }
        
    }
    
    // Select all categories and return it as String array
    func getCategories() ->Set<String> {
        
        var categories = Set<String>()
        
        if db != nil {
            let query = table.select(category)
            do {
                for row in try db!.prepare(query) {
                    categories.insert(row[category])
                }
            } catch {
                print("Error selecting categories: ", error)
            }
        }
        return categories
    }
    
    // Count proverbs in each category and return as dictionary
    // ["Category": Count]
    func selectCategories() ->[String: Int] {
        
        var categories = [String: Int]()
        
        if db != nil {
            let query = table.select(category)
            do {
                for cat in getCategories() {
                    let count = try db!.scalar(query.filter(category == cat).count)
                    categories[cat] = count
                }
            } catch {
                print("Error selecting categories: ", error)
            }
        }
        return categories
    }
    
    // Select proverbs by category or favorite and return as proverbs array
    func selectProverbs(condition: String?) ->[Proverb] {
        
        var proverbs = [Proverb]()
        
        if db != nil {
            let query: Table?
            if condition == nil {
                query = table.select(id, category, proverb, fav).filter(fav == 1)
            } else {
                query = table.select(id, category, proverb, fav).filter(category == condition!)
            }
    
            do {
                for row in try db!.prepare(query!) {
                    let proverb = Proverb(id: row[id], category: row[category], proverb: row[self.proverb], fav: row[fav])
                    proverbs.append(proverb)
                }
            } catch {
                print("Error selecting proverbs: ", error)
            }
        }
        return proverbs
    }
    
    // Return single proverb based on id
    // Check returned value for nil to avoid crash
    func getProverb(proverbId: Int) ->Proverb {
        
        var pro: Proverb!
        
        if db != nil {
            let query = table.select(id, category, proverb, fav).filter(id == proverbId)
            do {
                let row = try db!.pluck(query)
                if row != nil {
                    pro = Proverb(id: row![id], category: row![category], proverb: row![self.proverb], fav: row![fav])
                }
            } catch {
                print("Error getting proverb: ", error)
            }
        }
        return pro
    }
    
    // Update proverb favorite
    func updateFavorite(proverb: Proverb, value: Int) {
        if db != nil {
            let query = table.filter(id == proverb.id!)
            do {
                try db!.run(query.update(fav <- value))
            } catch {
                print("Unable to update proverb favorite status: ", error)
            }
        }
    }
}
