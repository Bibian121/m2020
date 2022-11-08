//
//  ArtistTableViewController.swift
//  19m
//
//  Created by Matilda Davydov on 07.11.2022.
//

import CoreData
import UIKit

enum Keys {
    static let sorting = "sorting"
}

class ArtistTableViewController: UITableViewController {
    
    let defaults: UserDefaults = {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Keys.sorting)
        return defaults
    }()
    
    @IBOutlet weak var newCell: UIBarButtonItem!
    private let persistentConteiner = NSPersistentContainer(name: "Model")
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Artist> = {
        let fetchRequest = Artist.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastname", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentConteiner.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortCell()
        
        persistentConteiner.loadPersistentStores { (persistentConteiner, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }else{
                do{
                    try self.fetchedResultsController.performFetch()
                }catch{
                    print(error)
                }
            }
        }
    }
    
    @objc func sortCell() {
        let sortDescriptor = NSSortDescriptor(key: "lastname", ascending: defaults.bool(forKey: Keys.sorting))
        switch UserDefaults.standard.bool(forKey: Keys.sorting) {
        case true:
            UserDefaults.standard.set(false, forKey: Keys.sorting)
            UserDefaults.standard.bool(forKey: Keys.sorting)
        case false:
            UserDefaults.standard.set(true, forKey: Keys.sorting)
            UserDefaults.standard.bool(forKey: Keys.sorting)
        }
        fetchedResultsController.fetchRequest.sortDescriptors = [sortDescriptor]
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    @IBAction func addNewRecipe() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            vc.artist = Artist.init(entity: NSEntityDescription.entity(forEntityName: "Artist", in: persistentConteiner.viewContext)!, insertInto: persistentConteiner.viewContext)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addSort() {
       // let sort: NSFetchRequest<Artist> = Artist.fetchRequest()
       // sort.sortDescriptors = [NSSortDescriptor(key: "lastname", ascending: true)]
        sortCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = fetchedResultsController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = artist.lastname
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let artist = fetchedResultsController.object(at: indexPath)
            persistentConteiner.viewContext.delete(artist)
            try? persistentConteiner.viewContext.save()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            vc.artist = fetchedResultsController.object(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension ArtistTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let artist = fetchedResultsController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath)
                cell!.textLabel?.text = artist.lastname
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
}

