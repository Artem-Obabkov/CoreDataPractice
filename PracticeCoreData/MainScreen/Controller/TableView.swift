//
//  TableView.swift
//  PracticeCoreData
//
//  Created by pro2017 on 19/09/2021.
//

import UIKit
import CoreData

class TableView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var cars = [Car]()
    
    
    let imageArray = [UIImage(systemName: "00.circle"), UIImage(systemName: "15.square.fill"), UIImage(systemName: "arrow.down.left.circle"), UIImage(systemName: "backward.fill")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        // Сортировка с помощью fetchRequest
        // -----------------------------------------------------
        let sortDescriptor = NSSortDescriptor(key: "carPower", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        // -----------------------------------------------------
        
        do {
            cars = try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        delay(2000) { [unowned self] in
            self.createAlert(with: "Add new car", message: "Enter name and power", style: .alert, indexPath: nil, isEditing: false)
        }
        
    }
    
}

extension TableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.isEmpty ? 0 : cars.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Cell
        
        let carObject = cars[indexPath.row]
        
        
        cell.modelLabel.text = carObject.carModel
        cell.powerLabel.text = "Power: \(String(carObject.carPower))"
        cell.carImage.image = UIImage(data: carObject.randomImage!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createAlert(with: "Edit car", message: "Edit your car here", style: .alert, indexPath: indexPath, isEditing: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteCar(at: indexPath)
        }
    }
    
    func delay(_ delay: Int, clouser: @escaping () -> () ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            clouser()
        }
    }
    
    
}
