//
//  MyViewController.swift
//  DataCustom
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class MyViewController: UIViewController,UISearchBarDelegate,DefaultChangeControllerDelegate {
    
    func detailController(_ controller: MyDetailViewController, didFinishAdding person: Student, name: String, age: Int, tution: Double, startDate: Date , isAdd: Bool) {
        
        
        print("IS WHAT \(isAdd)")
        
        if(isAdd){
            self.insertRecord(name:  name, age: age, tution: tution, startDate: startDate)
        }else{
            self.updateRecord(person: person, name:  name, age: age, tution: tution, startDate: startDate)
        }
        self.fetchAndUpdateTable()
        navigationController?.popViewController(animated:true)
    }
    
    

    
    
    var managedContext: NSManagedObjectContext!
  //  let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var serachBar: UISearchBar!
    
    var perArray = [Student]()
    
    var filterArray = [Student]()
    
    @IBAction func addNewData(_ sender: Any) {
        
        
    }
    @IBOutlet weak var tableView: UITableView!

    
    func fetchAndUpdateTable(){
        perArray = fetchRecords()
        filterArray = perArray
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        serachBar.delegate = self
        filterArray = perArray
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAndUpdateTable()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterArray = searchText.isEmpty ? perArray : perArray.filter({ (personString: Student) -> Bool in
            
            return personString.name?.range(of: searchText, options:  .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "detailSegue" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let destination = segue.destination as! MyDetailViewController
                destination.delegateDF = self
                
                destination.itemToEdit = filterArray[indexPath.row].name
                destination.itemToEditAge = String(filterArray[indexPath.row].age)
                destination.itemToEditTution = String(filterArray[indexPath.row].tution)
                destination.isAdd = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .none
                
                destination.itemToEditDate = dateFormatter.string(from:filterArray[indexPath.row].startDate!)
                destination.person = filterArray[indexPath.row]
                
            }
            //   controller1.itemToEdit = defaultText.text!
        }
        if segue.identifier == "addSegue"{
            let destination = segue.destination as! MyDetailViewController
            destination.delegateDF = self
            destination.isAdd = true
        }
    }
    
    func insertRecord(name:String, age:Int, tution:Double, startDate:Date){
             let person = Student(context: managedContext)
             person.name = name
             person.age = Int32(age)
                  person.tution =   tution
                  person.startDate = startDate
        try! managedContext.save()
         }
         
         func fetchRecords() -> [Student]{
         var arrPerson = [Student]()
         let fetchRequest = NSFetchRequest<Student>(entityName: "Student")
         
             do{
                 arrPerson = try managedContext.fetch(fetchRequest)
             }catch{
                 print(error)
             }
             return arrPerson
         }

         func deleteRecord( person : Student){
            managedContext.delete(person)
          try! managedContext.save()
         }
         
         func updateRecord(person : Student, name: String, age:Int, tution:Double, startDate:Date){
         person.name = name
             person.age = Int32(age)
              person.tution =   tution
              person.startDate = startDate
            try! managedContext.save()
         }
}
extension MyViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MyCustomCell
        let person = filterArray[indexPath.row]
        
        cell?.nameTxt?.text = person.name!
        cell?.ageTxt?.text = String(person.age)
        cell?.tutionTxt?.text = String(person.tution)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        cell?.startDateTxt?.text = dateFormatter.string(from:person.startDate!)
        
                
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let person = perArray[indexPath.row]
            deleteRecord(person: person)
            fetchAndUpdateTable()
        }
    }
  
  

}
