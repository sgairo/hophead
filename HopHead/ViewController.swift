//
//  ViewController.swift
//  HopHead
//
//  Created by Sophie Gairo on 9/14/16.
//  Copyright © 2016 Sophie Gairo. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate{

    //handle the UIPicker w/ datasource etc. 
    var pickerDataSource = ["Ale", "Lager", "Porter/Stout", "Malt"];
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(row == 0)
        {
            self.catView.backgroundColor = alesColor;
            self.catLabel.text = "Ale"
            category = "Ales"
        }
        else if(row == 1)
        {
            self.catView.backgroundColor = lagersColor;
            self.catLabel.text = "Lager"
            category = "Lagers"
        }
        else if(row == 2)
        {
            self.catView.backgroundColor =  portersStoutsColor;
            self.catLabel.text = "Porter/Stout"
            category = "PorterStouts"
        }
        else
        {
            self.catView.backgroundColor = maltsColor;
            self.catLabel.text = "Malt"
            category = "Malts"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
       
            attributedString = NSAttributedString(string: pickerDataSource[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        return attributedString
    }

    
    
    
    
    
    
    //define variables for databases
    //TO-DO: Change anv and ibu to doubles
    var category=""
    var favorites=0
    var name = ""
    var brewName = ""
    var brewLoc = ""
    var style = ""
    var abv = 0
    var ibu = 0
    var notes = ""
    //favorites 0== false 1==true
    
    
    
    //make all connections
    
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var catLabel: UILabel!
    
    @IBAction func fav_swch(_ sender: UISwitch) {
        if sender.isOn{
            favorites = 1
        }
    }
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBOutlet weak var beerName_txt: UITextField!
    @IBOutlet weak var beerStyle_txt: UITextField!
    
    @IBOutlet weak var brewName_txt: UITextField!
    @IBOutlet weak var brewLoc_txt: UITextField!
    @IBOutlet weak var abv_txt: UITextField!
    @IBOutlet weak var ibu_txt: UITextField!
    @IBOutlet weak var notes_txt: UITextView!
    
    @IBAction func addBeer_btn(_ sender: UIButton) {
        
        //check that there is a beername
        if (self.beerName_txt.text?.isEmpty)! {
            let alert = UIAlertController(title: "Required Field Left Blank", message: "You must enter a beer name.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if !(self.beerName_txt.text?.isEmpty)! {
            name = self.beerName_txt.text!
        }
        if !(self.brewName_txt.text?.isEmpty)! {
            brewName = self.brewName_txt.text!
        }
        if !(self.brewLoc_txt.text?.isEmpty)! {
            brewLoc = self.brewLoc_txt.text!
        }
        if !(self.beerStyle_txt.text?.isEmpty)! {
            style = self.beerStyle_txt.text!
        }
        if !(self.abv_txt.text?.isEmpty)! {
            abv = Int(self.abv_txt.text!)!
        }
        if !(self.ibu_txt.text?.isEmpty)! {
            ibu = Int(self.ibu_txt.text!)!
        }
        if !(self.notes_txt.text?.isEmpty)! {
            notes = self.notes_txt.text!
        }
        
        
        //open Database
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("hophead.db")
        
        
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //create table if doesnt exist
        if sqlite3_exec(db, "create table if not exists beers (id integer primary key autoincrement, beerName varchar not null, breweryName varchar, breweryLocation varchar, abv integer, ibu integer, category varchar, style varchar, favorites integer, notes varchar)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        
        
        //insert statement
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, "insert into beers (beerName,breweryName,breweryLocation,abv,ibu,category,style,favorites,notes) values (?,?,?,?,?,?,?,?,?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing insert: \(errmsg)")
        }
        
        
        //bind everything
        //let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(statement, 1, self.name, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding beer name: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 2, self.brewName, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding brewName: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 3, self.brewLoc, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding brewLoc: \(errmsg)")
        }
        
        if sqlite3_bind_int(statement, 4, Int32(self.abv)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding abv: \(errmsg)")
        }
        if sqlite3_bind_int(statement, 5, Int32(self.ibu)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding ibu: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 6, self.category, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding category: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 7, self.style, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding style: \(errmsg)")
        }
        
        if sqlite3_bind_int(statement, 8, Int32(self.favorites)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding favorites: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 7, self.notes, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding notes: \(errmsg)")
        }
        
        
        
        //one step
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure inserting beer: \(errmsg)")
        }
        
        
        //finalize & reset statement
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        
        
        
        //TESTING ONLY REMOVE IF WORKS
        ///////////////////////////////////////
        ///////////////////////////////////////
        
        
        if sqlite3_prepare_v2(db, "select id, beerName from beers", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int64(statement, 0)
            print("id = \(id); ", terminator: "")
            
            if let name = sqlite3_column_text(statement, 1) {
                let nameString = String(cString: name)
                print("beer name = \(nameString)")
            } else {
                print("name not found")
            }
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        ///ABOVE IS TESTING
        ///////////////////////////////////////////////
        ///////////////////////////////////////////////
        
        //close db & set to nil
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
        db = nil
        
        
       
        let alert = UIAlertController(title: "Success", message: "Your beer has been successfully added!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cool!", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
            
        
        
        
        
    }
 
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up picker delegate and datasource
        
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
    }
    
    
    
    ////////////////////////////////////////////
    /////////////...COLORS...///////////////////
    ////////////////////////////////////////////
    let alesColor = UIColor(red: 247, green: 183, blue: 45)
    let lagersColor = UIColor(red: 241, green: 149, blue: 40)
    let portersStoutsColor = UIColor(red: 196, green: 79, blue: 25)
    let maltsColor = UIColor(red: 171, green: 41, blue: 26)
    let allBeersColor = UIColor(red: 94, green: 26, blue: 4)
    
    //NOTE: The above colors are the 3rd hue in each color gradient.
    //Example color gradient: alesAccent1Color, alesAccent2Color, alesColor, alesAccent4Color
    
    let alesAccent1Color = UIColor(red: 244, green: 204, blue: 132)
    let alesAccent2Color = UIColor(red: 244, green: 193, blue: 103)
    let alesAccent4Color = UIColor(red: 216, green: 157, blue: 39)
    
    let lagersAccent1Color = UIColor(red: 237, green: 178, blue: 108)
    let lagersAccent2Color = UIColor(red: 239, green: 164, blue: 82)
    let lagersAccent4Color = UIColor(red: 214, green: 128, blue: 33)
    
    let portersStoutsAccent1Color = UIColor(red: 242, green: 121, blue: 73)
    let portersStoutsAccent2Color = UIColor(red: 221, green: 96, blue: 47)
    let portersStoutsAccent4Color = UIColor(red: 160, green: 57, blue: 16)
    
    let maltsAccent1Color = UIColor(red: 234, green: 91, blue: 80)
    let maltsAccent2Color = UIColor(red: 211, green: 54, blue: 42)
    let maltsAccent4Color = UIColor(red: 142, green: 23, blue: 14)
    
    let allBeersAccent1Color = UIColor(red: 158, green: 53, blue: 25)
    let allBeersAccent2Color = UIColor(red: 114, green: 34, blue: 13)
    let allBeersAccent4Color = UIColor(red: 66, green: 16, blue: 3)
    
    
    
    
    //instead of image , fill view with color based on category
}

