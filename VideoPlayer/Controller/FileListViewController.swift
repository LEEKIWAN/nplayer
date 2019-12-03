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
import LinkPresentation

class FileListViewController: UIViewController {
    
    var currentDirectoryURL: URL?
    var directoryMonitor: DirectoryMonitor?
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var consTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var consEditViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var toggleCheckButton: UIButton!
    @IBOutlet weak var fileMoveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var fileRemoveButton: UIButton!
    
    
    var fileOfImageToShare: FileObject?
    
    var fileList: [FileObject] = []
    var filteredFileList: [FileObject] = []
    let searchController = UISearchController()
    
    override var isEditing: Bool {
        didSet {
            self.editModeUI(isEditing: isEditing)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSearchController()
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(hexFromString: "#363636")
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsSelection = true
        //
        if self == self.navigationController?.viewControllers[0] {
            currentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            //            do {
            //                let folderPath =  currentDirectoryURL!.appendingPathComponent("즐겨찾기")
            //                if !FileManager.default.fileExists(atPath: folderPath.path) {
            //                    try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            //                }
            //            }
            //            catch {
            //                print("Document directory is \(error.localizedDescription)")
            //            }
            
            listFilesFromUrl(with: currentDirectoryURL!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        directoryMonitor?.startMonitoring()
        navigationItem.searchController = searchController
        tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterForKeyboardNotifications()
    }
    
    func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.placeholder = "필터"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor(hexFromString: "#F7C203")
        searchController.searchBar.barStyle = .black
    }
    
    // MARK: - FileManager
    
    func listFilesFromUrl(with url: URL) {
        fileList.removeAll()
        currentDirectoryURL = url
        directoryMonitor = DirectoryMonitor(URL: url)
        directoryMonitor?.delegate = self
        
        let documentsProvider = LocalFileProvider()
        documentsProvider.contentsOfDirectory(path: url.path) { (fileList, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            self.fileList.append(contentsOf: fileList.sort(by: .name, ascending: true, isDirectoriesFirst: true))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    // MARK: - Filter SearchController
    
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
    
    func editModeUI(isEditing: Bool) {
        if isEditing {
            self.consEditViewHeight.constant = 50
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onETCTouched(_:)))
            self.tableView.setEditing(true, animated: true)
        }
        else {
            self.consEditViewHeight.constant = 0
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(onETCTouched(_:)))
            self.tableView.setEditing(false, animated: true)
        }
    }
    
    // MARK: - Event
    
    @IBAction func onETCTouched(_ sender: UIBarButtonItem) {
        if !isEditing {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "선택", style: .default, handler: { (alert) in
                self.isEditing = true
            }))
            
            alert.addAction(UIAlertAction(title: "정렬", style: .default, handler: { (alert) in
                
            }))
            
            alert.addAction(UIAlertAction(title: "재생 정보 초기화", style: .default, handler: { (alert) in
                
            }))
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.isEditing = false
        }
    }
    
    
    @IBAction func onToggleCheckTouched(_ sender: UIButton) {
        var isAllChecked = false
        
        if tableView.indexPathsForSelectedRows?.count == fileList.count {
            isAllChecked = true
        }
        
        if !isAllChecked {
            for i in 0 ..< fileList.count {
                tableView.selectRow(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .none)
            }
        }
        else {
            for i in 0 ..< fileList.count {
                tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
            }
        }
        updateBottomUI()
    }
    @IBAction func onFileMoveTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func onShareTouched(_ sender: UIButton) {
        fileOfImageToShare = nil
        
        var fileURLs: [URL] = []
        for i in 0 ..< tableView.indexPathsForSelectedRows!.count {
            let indexPath = tableView.indexPathsForSelectedRows![i]
            fileURLs.append(fileList[indexPath.row].url)
            if self.fileOfImageToShare == nil {
                self.fileOfImageToShare = fileList[indexPath.row]
            }
        }
        
        let vc = UIActivityViewController(activityItems: [self] + fileURLs , applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onFileRemoveTouched(_ sender: UIButton) {
        var selectedFiles: [FileObject] = []
        for i in 0 ..< tableView.indexPathsForSelectedRows!.count {
            let indexPath = tableView.indexPathsForSelectedRows![i]
            selectedFiles.append(fileList[indexPath.row])
        }
        
        
        let documentsProvider = LocalFileProvider()
        documentsProvider.removeItem(path: "new.txt", completionHandler: nil)

        //        documentsProvider.contentsOfDirectory(path: url.path) { (fileList, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//            self.fileList.append(contentsOf: fileList.sort(by: .name, ascending: true, isDirectoriesFirst: true))
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }

    }
    
    private func updateBottomUI() {
        self.fileMoveButton.isEnabled = tableView.indexPathsForSelectedRows?.count ?? 0 > 0 ? true : false
        self.fileRemoveButton.isEnabled = tableView.indexPathsForSelectedRows?.count ?? 0 > 0 ? true : false
        self.shareButton.isEnabled = tableView.indexPathsForSelectedRows?.count ?? 0 > 0 ? true : false
    }
    
    
    // MARK: - KeyBoard
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let notiInfo = notification.userInfo
        
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        var keyboardHeight = keyboardRectangle.height
        
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
        }
        
        let animationDuration = (notiInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
        
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: {
            self.consTableViewBottom.constant = CGFloat(keyboardHeight)
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc func keyboardWasHidden(notification: Notification) {
        let notiInfo = notification.userInfo
        let animationDuration = (notiInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
        
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: {
            self.consTableViewBottom.constant = 0
            self.view.layoutIfNeeded()
        })
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
        
        fileList[indexPath.row].tableView = tableView
        fileList[indexPath.row].indexPath = indexPath
        
        if isFiltering() {
            cell.setData(data: filteredFileList[indexPath.row])
        }
        else {
            cell.setData(data: fileList[indexPath.row])
        }
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isEditing {
            updateBottomUI()
        }
        else {
            var data: FileObject
            if isFiltering() {
                data = filteredFileList[indexPath.row]
            }
            else {
                data = fileList[indexPath.row]
            }
            
            switch data.getFileType() {
            case .directory:
                let storyBoard = UIStoryboard(name: "FileListViewController", bundle: nil)
                let fileListViewController = storyBoard.instantiateViewController(withIdentifier: "FileListViewController") as! FileListViewController
                fileListViewController.listFilesFromUrl(with: data.url)
                fileListViewController.navigationItem.title = data.fileName
                self.navigationController?.pushViewController(fileListViewController, animated: true)
            case .text:
                let storyBoard = UIStoryboard(name: "TextViewerController", bundle: nil)
                let textViewerController = storyBoard.instantiateInitialViewController() as! TextViewerController
                textViewerController.data = data
                self.present(textViewerController, animated: true, completion: nil)
            case .image:
                let storyBoard = UIStoryboard(name: "ImageViewerController", bundle: nil)
                let imageViewerController = storyBoard.instantiateInitialViewController() as! ImageViewerController
                imageViewerController.data = data
                self.present(imageViewerController, animated: true, completion: nil)
                
            case .video:
                let storyBoard = UIStoryboard(name: "VideoDetailViewController", bundle: nil)
                let videoDetailViewController = storyBoard.instantiateInitialViewController() as! VideoDetailViewController
                videoDetailViewController.data = data
                videoDetailViewController.navigationItem.title = data.fileName
                self.navigationController?.pushViewController(videoDetailViewController, animated: true)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if self.isEditing {
            updateBottomUI()
        }
    }
    
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


extension FileListViewController: DirectoryMonitorDelegate {
    func directoryMonitorDidObserveChange(directoryMonitor: DirectoryMonitor) {
        guard let currentDirectoryURL = currentDirectoryURL else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.listFilesFromUrl(with: currentDirectoryURL)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension FileListViewController: UIActivityItemSource {

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage()
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return self.fileOfImageToShare
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()

        metadata.title = self.fileOfImageToShare!.name
//        metadata.originalURL = self.fileOfImageToShare!.thumbnailImage
//        metadata.url = self.fileOfImageToShare!.thumbnailImage
//        metadata.imageProvider = NSItemProvider.init(contentsOf: self.fileOfImageToShare!.thumbnailImage)
//        NSItemProvider(
//        metadata.iconProvider = NSItemProvider.init(contentsOf: self.fileOfImageToShare!.thumbnailImage)

        return metadata
    }
}
