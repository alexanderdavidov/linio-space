//
//  NoteTableViewController.swift
//  LinioSpace
//
//  Created by Александр Утробин on 08.04.17.
//  Copyright © 2017 Aleksandr Utrobin. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    // MARK: properties
    var fetchResultsController: NSFetchedResultsController<Station>!
    var stations: [Station] = []
    var searchController: UISearchController!
    var filteredResultArray: [Station] = []
//        Station(city: "Москва", stationName: "Маяковская", addInformation: "test", image: "mayk.jpg"), Station(city: "Москва", stationName: "Площадь Революции", addInformation: "test", image: "ploshadrev.jpg"), Station(city: "Москва", stationName: "Достоевская", addInformation: "test", image: "dostoev.jpg")]
    
    
//    var city = ["Москва", "Москва", "Москва"] // тестовый массив городов
//    var stationNames = ["Маяковская", "Площадь Революции", "Достоевская"] // тестовый массив станций
//    var stationImages = ["mayk.jpg", "ploshadrev.jpg", "dostoev.jpg"] // тестовый массив фото
//    var addInformation = ["test", "test", "test"] // тестовый массив дополнительной информации
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        searchController.searchBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        definesPresentationContext = true
        // убираем текст в кнопке "назад" в navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.estimatedRowHeight = 125 //загрузка автоматического подбора высоты ячейки
        tableView.rowHeight = UITableViewAutomaticDimension //загрузка автоматического подбора высоты ячейки
        let fetchRequest: NSFetchRequest<Station> = Station.fetchRequest() // создаем запрос
        let sortDescriptor = NSSortDescriptor(key: "city", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                stations = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDf = UserDefaults.standard
        let selected = userDf.bool(forKey: "selected")
        guard !selected else { return }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Fetch request
    // начало изменений
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    // изменения
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        stations =  controller.fetchedObjects as! [Station]
    }
    //конец изменений
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return stations.count
    }
    
    func stationToDisplay(indexPath: IndexPath) -> Station {
        let station: Station
        if searchController.isActive && searchController.searchBar.text != "" {
            station = filteredResultArray[indexPath.row]
        } else {
            station = stations[indexPath.row]
        }
        return station
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell
        let station = stationToDisplay(indexPath: indexPath)
        cell.selectImageView.image = UIImage(data: station.image as! Data)
        cell.selectImageView.layer.cornerRadius = 10
        cell.selectImageView.clipsToBounds = true
        cell.cityLabel.text = station.city
        cell.nameStationLabel.text = station.nameStation
        cell.addInformationLabel.text = station.addInformation
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //убираем выделение
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // поделиться контентом с выделенной ячейки
        let shareContent = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            let specialText = "Моя заметка из приложения Linio Space: "
            if let image = UIImage(data: self.stations[indexPath.row].image as! Data) {
                let ac = UIActivityViewController(activityItems: [specialText, image], applicationActivities: nil)
                self.present(ac, animated: true, completion: nil)
            }
        }
        // Удаление выбранной ячейки
        let deleteRow = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            self.stations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        shareContent.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        deleteRow.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        return [deleteRow, shareContent]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! DetailNoteViewController
                dvc.station = stationToDisplay(indexPath: indexPath)
            }
        }
    }
    
    
    func filterContent(searchText text: String) {
        filteredResultArray = stations.filter({ (station) -> Bool in
            return (station.city?.lowercased().contains(text.lowercased()))!
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
    
}








