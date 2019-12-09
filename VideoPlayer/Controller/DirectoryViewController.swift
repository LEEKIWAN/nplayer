//
//  DirectoryViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/12/05.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit

enum OperationMode {
    case copy
    case move
}


class DirectoryViewController: UIViewController {
    var mode: OperationMode = .copy
    var fileListViewController: FileListViewController?
    var fileList: [FileObject] = []
    var selectedFiles: [FileObject]?
    
    var currentDirectoryURL: URL?
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var loadingViewController: LoadingViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FileItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        
        let buttonTitle = mode == .copy ? "복사" : "이동"
        self.confirmButton.setTitle(buttonTitle, for: .normal)
                
        
                
        if self == self.navigationController?.viewControllers[0] {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            listFilesFromUrl(with: paths!)
        }
        
        
    }
    
    func listFilesFromUrl(with url: URL) {
        fileList.removeAll()
        currentDirectoryURL = url
        
        let documentsProvider = LocalFileProvider()
        documentsProvider.contentsOfDirectory(path: url.path) { (fileList, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            if self.currentDirectoryURL!.path != self.documentsDirectoryURL.path {
                self.fileList.append(self.createBackFolder())
            }
            
            
            self.fileList.append(contentsOf: fileList.sort(by: .name, ascending: true, isDirectoriesFirst: true).filter {
                $0.isDirectory
            })

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }        
    }
    
    func createBackFolder() -> FileObject {
        let backFolder = FileObject(url: nil, name: "...", path: "...")
        backFolder.thumbnailImage = UIImage(systemName: "folder")
        return backFolder
    }
    
    func startProgressView() {
        let storyBoard = UIStoryboard(name: "LoadingViewController", bundle: nil)
        loadingViewController = storyBoard.instantiateInitialViewController()
        self.present(loadingViewController!, animated: false, completion: nil)
    }
    
    func stopProgressView() {
        loadingViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    
    // MARK: - Event
    @IBAction func onCloseTouched(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddDirectoryTouched(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "새 폴더", message: "폴더 이름을 입력하세요.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default) { (action) in
        }
        let confirm = UIAlertAction(title: "확인", style: .default) { (action) in
            let folderName: String = alert.textFields!.first!.text!
            
            do {
                let folderPath = self.currentDirectoryURL!.appendingPathComponent(folderName)
                if !FileManager.default.fileExists(atPath: folderPath.path) {
                    try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.listFilesFromUrl(with: self.currentDirectoryURL!)
                    }
                }
            }
            catch {
                print("Document directory is \(error.localizedDescription)")
            }
        }
        
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func onConfirmTouched(_ sender: UIButton) {
        guard let files = selectedFiles else { return }
        
        self.startProgressView()
        let documentsProvider = LocalFileProvider()
        var selectedFileCount = files.count
        
        
        for i in 0 ..< files.count {
            let moveTo = currentDirectoryURL!.absoluteString.appending(files[i].name)
            
            
            if self.mode == .move {
                documentsProvider.moveItem(path: files[i].url.absoluteString, to: moveTo, overwrite: true) { (error) in
                    selectedFileCount -= 1
                    
                    if selectedFileCount == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.stopProgressView()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            self.dismiss(animated: true) {
                                
                                self.fileListViewController?.reloadTableView()
                            }
                            
                        }
                    }
                }
            }
            else {
                documentsProvider.copyItem(path: files[i].url.absoluteString, to: moveTo, overwrite: true) { (error) in
                    selectedFileCount -= 1
                    
                    if selectedFileCount == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.stopProgressView()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            self.dismiss(animated: true) {
                                self.fileListViewController?.reloadTableView()
                            }
                        }
                    }
                }
            }

        }
        
        
    }
}

extension DirectoryViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! FileItemTableViewCell
        cell.setData(data: fileList[indexPath.row])
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data: FileObject = fileList[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
        
        if data.name == "..." {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        
        let storyBoard = UIStoryboard(name: "DirectoryViewController", bundle: nil)
        let navigationController = storyBoard.instantiateInitialViewController()
        let directoryViewController = navigationController?.children.first as! DirectoryViewController
        directoryViewController.mode = self.mode
        directoryViewController.selectedFiles = self.selectedFiles
        directoryViewController.fileListViewController = self.fileListViewController
        directoryViewController.listFilesFromUrl(with: data.url)
        directoryViewController.navigationItem.title = data.fileName
        self.navigationController?.pushViewController(directoryViewController, animated: true)
        
        
    }
    
}
 
