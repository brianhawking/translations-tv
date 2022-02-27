//
//  ViewController.swift
//  Translations-TV
//
//  Created by Brian Veitch on 2/26/22.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var array = [Translation]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textToTranslate: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        convertButton.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
    
    }

    @IBAction func convertText(_ sender: Any) {
                
        guard let text = textToTranslate.text, textToTranslate.text != "" else {
            return
        }
        
        let publishers = WebService().fetchTranslations(text: text)
   
        for publisher in publishers {
            publisher.sink(receiveValue: { translation in
                self.array.append(translation)
                print(translation.contents.translated)
            }).store(in: &cancellables)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = array[indexPath.row].contents.translation.capitalized
        cell.detailTextLabel?.text = array[indexPath.row].contents.translated
        
        return cell
    }
    
    
}

