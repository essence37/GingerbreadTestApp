//
//  TableViewController.swift
//  GingerbreadTestApp
//
//  Created by Пазин Даниил on 03.02.2021.
//

import UIKit
import Combine
import Kingfisher

class TableViewController: UITableViewController {
    
    // MARK: - Constants and Variables
    
    private let apiClient = APIClient()
    var subscriptions: Set<AnyCancellable> = []
    var sample: Sample?
    var dataObjects = [DataObjects]()
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSampleData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataObjects.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sample?.view[section] == "selector" {
            return 3
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath)
        
        let object = dataObjects[indexPath.section]
        
        cell.imageView?.kf.setImage(with: URL(string: object.data.url ?? "no image")) { result in
            if case .success(_) = result {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        cell.textLabel?.text = object.data.text ?? object.data.variants?[indexPath.row].text
        
        return cell
    }
    
    // Create a standard header that includes the returned text.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return sample?.view[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = dataObjects[indexPath.section].name
        let id = dataObjects[indexPath.section].data.variants?[indexPath.row].id
        
        showAlertController(name, id)
    }
    
    // MARK: - Methods
    
    private func fetchSampleData() {
        apiClient.getSample()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Retrieving data failed with error \(error)")
                }
            } receiveValue: { object in
                print("Retrieved object \(object)")
                self.sample = object
                self.mapTableData(object)
                self.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    private func mapTableData(_ sample: Sample) {
        for i in sample.view {
            let dataObjects = sample.data.publisher
            dataObjects
                .first(where: { $0.name == i })
                .sink(receiveCompletion: { print("Completed with: \($0)") },
                      receiveValue: {
                        print($0)
                        self.dataObjects.append($0)
                      })
                .store(in: &subscriptions)
        }
    }
    
    private func showAlertController(_ name: String, _ id: Int?) {
        var strID = "No ID"
        if let id = id {
            strID = "ID: \(id)"
        }
        
        let alert = UIAlertController(title: name, message: strID, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
