//
//  TableViewExtension.swift
//  PracticeCoreData
//
//  Created by pro2017 on 19/09/2021.
//

import Foundation
import UIKit
import CoreData

extension TableView {
    
    func createAlert(with title: String, message: String?, style: UIAlertController.Style, indexPath: IndexPath?, isEditing: Bool) {
        
        var currentCar: Car?
        
        var firstTFText = ""
        var secondTfText = ""
        var actionLabel = "Add"
        
        if isEditing, let indexPath = indexPath  {
            actionLabel = "Edit"
            
            let car = cars[indexPath.row]
            firstTFText = car.carModel!
            secondTfText = "\(car.carPower)"
            
            currentCar = car
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        alertController.addTextField { (tf) in
            tf.placeholder = "Car model..."
            tf.text = firstTFText
        }
        
        alertController.addTextField { (tf) in
            tf.placeholder = "Power..."
            tf.text = secondTfText
            tf.keyboardType = UIKeyboardType.numberPad
        }
        
        let addAction = UIAlertAction(title: actionLabel, style: .default) { [unowned self] _ in
            
            let firstTF = alertController.textFields![0]
            let secondTF = alertController.textFields![1]
            
            guard let model = firstTF.text, let power = secondTF.text else { return }
            
            currentCar?.carModel = model
            currentCar?.carPower = Int16(power)!
            
            if isEditing == true {
                editCar(car: currentCar!, indexPath: indexPath!)
                
            } else {
                saveCar(model: model, power: Int16(power)!)
            }
            
            tableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] _ in
            tableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveCar(model: String, power: Int16) {
        
        let randomInt = Int.random(in: 0...3)
        let imageData = imageArray[randomInt]!.pngData()
        
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: context) else { return }
        
        let carObject = Car(entity: entity, insertInto: context)
        
        carObject.carModel = model
        carObject.carPower = power
        carObject.randomImage = imageData
        
        do {
            try context.save()
            cars.append(carObject)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteCar(at indexPath: IndexPath) {
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        if let cars = try? context.fetch(fetchRequest) {
            context.delete(cars[indexPath.row])
        }
        
        do {
            try context.save()
            self.cars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func editCar(car: Car, indexPath: IndexPath) {
        
        let context = getContext()
    
        do {
            try context.save()
            
            let carToEdit = cars[indexPath.row]
            carToEdit.carModel = car.carModel
            carToEdit.carPower = car.carPower
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
