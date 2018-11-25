//
//  MoviesTableViewController.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 05/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {

    
    var fetchedResultController: NSFetchedResultsController<Movie>?
    //var movies : [Movie] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localization.moviesTitle
        loadMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.backgroundColor =  UIColor(named: SegmentedColors.allValues[UserDefaultsManager.colorNumber()].rawValue)
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
            TableViewHelper.showEmpty(message: Localization.emptyTableMovies, in: self)
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieItemTableViewCell else { return UITableViewCell() }
        guard let movie = fetchedResultController?.object(at: indexPath) else { return cell }
        cell.prepare(with: movie)
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let movie = fetchedResultController?.object(at: indexPath) else { return }
            context.delete(movie)
            saveContext()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueMovieEdit", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMovieEdit" {
            
            
            
            let viewDestiny = segue.destination as! MovieEditViewController
            
            if let indexPath = sender as? IndexPath {
                viewDestiny.movie = fetchedResultController?.object(at: indexPath) 
                print("Edit Movie")
            } else {
                viewDestiny.movie = nil
                print("New Movie")
            }
        }
    }

     // MARK: - Methods
    private func loadMovies(){

        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Movie.title, ascending: true)
        let sortDescriptorDate = NSSortDescriptor(key: #keyPath(Movie.releaseDate), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptorDate]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController?.delegate = self
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print(error)
        }
    }
    
    // MARK: - IBActions
    @IBAction func newMovieClick(_ sender: Any) {
         performSegue(withIdentifier: "segueMovieEdit", sender: nil)
    }
}

extension MoviesTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}


