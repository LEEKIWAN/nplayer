//
//  PlayListViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 26/07/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class FileListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var consTableViewBottom: NSLayoutConstraint!
    
    var fileList: [FileObject] = []
    var filteredFileList: [FileObject] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSearchController()
        self.listFilesFromDocumentsFolder()
        self.sortLoadedFileFromDocumentsFolder()
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//    }
    
    func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "필터"
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor(hexFromString: "#F7C203")
        searchController.searchBar.barStyle = .black
    }

    
    func listFilesFromDocumentsFolder() {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String = paths[0]
        let fileManager: FileManager = FileManager()
        let fileList = try? fileManager.contentsOfDirectory(atPath: documentsDirectory)
        
        guard fileList != nil else {
            self.fileList.removeAll()
            return
        }
        
        for file in fileList! {
            loadFileFromDocumentsFolder(fileName: file)
        }
    }
    
    func loadFileFromDocumentsFolder(fileName: String) {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let filePath: String = documentsDirectory.appendingPathComponent(fileName);
        let fileUrl = URL(fileURLWithPath: filePath)
        let file = FileObject(url: fileUrl)
        self.fileList.append(file)
        
    }
    
    func sortLoadedFileFromDocumentsFolder() {
        var directoryList: [FileObject] = []
        
        for i in (0 ..< fileList.count).reversed() {
            let file = fileList[i]
            if file.extension == "directory" {
                directoryList.append(file)
                fileList.remove(at: i)
            }
        }
        

        directoryList.sort { (lhs, rhs) -> Bool in
            return lhs.fileName.lowercased() < rhs.fileName.lowercased()
        }
        
        fileList.sort { (lhs, rhs) -> Bool in
            return lhs.fileName.lowercased() < rhs.fileName.lowercased()
        }
        
        fileList.insert(contentsOf: directoryList, at: 0)
    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFileList = fileList.filter({( file: FileObject) -> Bool in
            return file.fileName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}


extension FileListViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredFileList.count
        }
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! FileItemTableViewCell
        
        if isFiltering() {
            cell.setData(data: filteredFileList[indexPath.row])
        }
        else {
            cell.setData(data: fileList[indexPath.row])
        }
        
        return cell
    }
    
    
    //MARK: - UITableViewDelegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard = UIStoryboard(name: "PlayViewController", bundle: nil)
//        let playViewController = storyBoard.instantiateInitialViewController() as! PlayViewController
//
//        playViewController.playItem = videoItems[indexPath.row]
//
//        self.present(playViewController, animated: true, completion: nil)
//    }
    
}

extension FileListViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension FileListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

