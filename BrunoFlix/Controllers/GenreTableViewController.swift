//
//  GenreTableViewController.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 16/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import UIKit
import CoreData

class GenreTableViewController: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<Genre>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Localization.genresTitle
        loadGenres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(named: SegmentedColors.allValues[UserDefaultsManager.colorNumber()].rawValue )
    }
    
    private func loadGenres() {
        let fetchRequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Genre.name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController?.delegate = self
        
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print(error)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (fetchedResultController?.fetchedObjects?.count ?? 0 ) > 0 {
            TableViewHelper.hideEmpty(in: self)
            return fetchedResultController?.fetchedObjects?.count ?? 0
        } else {
            TableViewHelper.showEmpty(message: Localization.emptyTableGenres, in: self)
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let genre = fetchedResultController?.object(at: indexPath)
        cell.textLabel?.text = genre?.name
        return cell
    }
    
    @IBAction func addGenre(_ sender: Any) {
        let alert = UIAlertController(title: Localization.genresTitle, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let genreName = alert.textFields?.first?.text
            let genre = Genre(context: self.context)
            genre.name = genreName
            self.saveContext()
        }))
        alert.addAction(UIAlertAction(title: Localization.btnCancel, style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = Localization.placeholderGenreName
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let genre = fetchedResultController?.object(at: indexPath) else { return }
            context.delete(genre)
            saveContext()
        }
    }
    
}

extension GenreTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
