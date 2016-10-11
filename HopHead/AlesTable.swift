//
//  AlesTable.swift
//  HopHead
//
//  Created by Sophie Gairo on 10/10/16.
//  Copyright © 2016 Sophie Gairo. All rights reserved.
//

import UIKit


class AlesTable: UIViewController, UITableViewDataSource{
    var beerNames = ["Sophie","Gairo"]
    var abvs = [Int]()
    var ibus = [Int]()
    var colors = [UIColor]()
    //colors.append(UIColor.white)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //open Database
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("hophead.db")
    
    
    
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //in case no beer or table has been added, create table here
        if sqlite3_exec(db, "create table if not exists beers (id integer primary key autoincrement, beerName varchar not null, breweryName varchar, breweryLocation varchar, abv integer, ibu integer, category varchar, style varchar, favorites integer, notes varchar)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        
        
        //query database
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, "select * from beers where category = (?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 1, "Ales", -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding Ales cat: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int64(statement, 0)
            print("id = \(id); ", terminator: "")
            
            if let name = sqlite3_column_text(statement, 1) {
                let nameString = String(cString: name)
                beerNames.append(nameString)
                print("beer name = \(nameString)")
            } else {
                print("name not found")
            }
            
            
           // if let abv = sqlite3_column_int(statement, 4) {
           //     //let abvInt = Int8(CInt: abv)
           //     abvs.append(abv)
            //    print("abv = \(abv)")
            //} else {
            //    print("name not found")
           // }
            
            
          //  if let ibu = sqlite3_column_int(statement, 5) {
            //    //let ibuInt = Int8(CInt: ibu)
              //  ibus.append(ibu)
                //print("ibu = \(ibu)")
            //} else {
              //  print("name not found")
            //}
            
            
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
 
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) 
        cell.textLabel?.text = beerNames[indexPath.item]
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return beerNames.count
        }
        else
        {
            return 4//number of color accents
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0
        {
            let beer = beerNames[indexPath.row]
            cell.textLabel?.text = beer
        }
        else
        {
            //var colorIndex = Int(arc4random_uniform(4) + 1)
            let color = alesColor
            cell.textLabel?.backgroundColor = color
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0
        {
            return "Beer Name"
        }
        else
        {
            return "Color"
        }
    }

    
    //query database
    
    
    
    //populate tables
    
    
    
    
    
    //close database 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //var color = UIColor.white
    
    ////////////////////////////////////////////
    /////////////...COLORS...///////////////////
    ////////////////////////////////////////////
    let alesColor = UIColor(red: 247, green: 183, blue: 45)
    //NOTE: The above colors are the 3rd hue in each color gradient.
    //Example color gradient: alesAccent1Color, alesAccent2Color, alesColor, alesAccent4Color
    
    let alesAccent1Color = UIColor(red: 244, green: 204, blue: 132)
    let alesAccent2Color = UIColor(red: 244, green: 193, blue: 103)
    let alesAccent4Color = UIColor(red: 216, green: 157, blue: 39)

    
    //colors.append(alesColor)
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
