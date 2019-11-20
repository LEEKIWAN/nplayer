//
//  VideoDetailViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 21/08/2019.
//  Copyright © 2019 kiwan. All rights reserved.
//

import Foundation
import AVFoundation

class VideoDetailViewController: UIViewController, VideoViewDelegate {
    var shouldHideHomeBarIndicator = false
    
    var data: FileObject?
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    var videoView: VideoView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var audioDescriptionLabel: UILabel!
    
    @IBOutlet weak var creatorView: UIStackView!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var writerView: UIStackView!
    @IBOutlet weak var writerLabel: UILabel!
    
    @IBOutlet weak var castView: UIStackView!
    @IBOutlet weak var castLabel: UILabel!
    
    @IBOutlet weak var genreView: UIStackView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var starView: UIStackView!
    @IBOutlet var starImageArray: [UIImageView]!
    
    @IBOutlet weak var moreButton: UIButton!

    var moreURL: URL?
    var theMovieTitle = ""
    var settingPopupViewController: PopupViewController?
    let movieDB = TheMovieDB.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return shouldHideHomeBarIndicator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        
        self.navigationController?.navigationBar.isTranslucent = false;
        guard let data = data else { return }
        
        movieDB.initMemberVariable(fileName: data.fileName)
        movieDB.requestDB(fileName: data.fileName) { (success, result) in
            if success {
                if result!.results.count > 0 {
                    let tvID = result!.results.first!.id
                    self.movieDB.requestTVDB(id: tvID!) { (success, responseData) in
                        self.setTVUI(responseData: responseData!)
                    }
                    
                    self.movieDB.requestTVEpisodeDB(id: tvID!) { (success, responseData) in
                        self.setTVUI(responseData: responseData!)
                    }
                    
                    self.moreButton.isHidden = false
                    self.moreURL = URL(string: "https://www.themoviedb.org/tv/\(tvID!)?language=ko-KR")
                    self.theMovieTitle = "\(result?.results.first?.name ?? "") - The Movie Database"
                }
                else {
                    self.setInitialUI()
                }
            }
            else {
                self.setInitialUI()
            }
        }
    }
    
    func setInitialUI() {
        guard let data = data else { return }
        titleLabel.text = "\(data.fileName).\(data.extension)"
        thumbnailImageView.image = data.thumbnailImage
        backgroundImageView.image = data.thumbnailImage
        totalDurationLabel.text = data.totalDurationText
        setBackgroundBlurView()
        
        guard let tracksInformation = data.vlcMedia?.tracksInformation else {
            return
        }
        
        
        var videoInfo: Dictionary<String, Any>? = nil
        var audioInfo: Dictionary<String, Any>? = nil
        
        for i in 0 ..< tracksInformation.count {
            let info = tracksInformation[i] as! Dictionary<String, Any>
            if info["type"] as! String == "audio" {
                audioInfo = info
            }
            else if info["type"] as! String == "video" {
                videoInfo = info
            }
        }
        
        if let videoInfo = videoInfo {
            videoInformationUpdate(track: videoInfo)
        }
        
        if let audioInfo = audioInfo {
            audioInformationUpdate(track: audioInfo)
        }
    }
    
    func setTVUI(responseData: Any) {
        if responseData is SearchTVEpisodeObject {
            let data = responseData as! SearchTVEpisodeObject
            
            // contents
            contentLabel.isHidden = false
            contentLabel.text = data.overview ?? ""
            
            let writerText = data.getCrewText(job: "Writer")
            
            if writerText.count > 0 {
                writerView.isHidden = false
                writerLabel.text = writerText
            }
            else {
                writerView.isHidden = true
            }
            
            let guestText = data.getGuestText()
            
            if guestText.count > 0 {
                castView.isHidden = false
                castLabel.text = guestText
            }
            else {
                castView.isHidden = true
            }
            
            self.setVoteStarImageView(average: data.vote_average)
            
        }
        else if responseData is SearchTVObject {
            let data = responseData as! SearchTVObject
            
            // creator
            if data.created_by.count > 0 {
                creatorView.isHidden = false
                creatorLabel.text = data.created_by.first!.name
            }
            else {
                creatorView.isHidden = true
            }
            
            // genres
            if data.genres.count > 0 {
                genreView.isHidden = false
                genreLabel.text = data.getGenreText()
            }
            else {
                genreView.isHidden = true
            }
            
    
        }
    }
    
    func setVoteStarImageView(average: Float) {
        if average > 0 {
            starView.isHidden = false
            
            if average >= 2 {
                starImageArray[0].image = UIImage(systemName: "star.fill")
            }
            if average >= 4 {
                starImageArray[1].image = UIImage(systemName: "star.fill")
            }
            if average >= 6 {
                starImageArray[2].image = UIImage(systemName: "star.fill")
            }
            if average >= 8 {
                starImageArray[3].image = UIImage(systemName: "star.fill")
            }
            if average >= 10 {
                starImageArray[4].image = UIImage(systemName: "star.fill")
            }
        }
        else {
            starView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurView.frame = backgroundImageView.bounds
        
        if let videoView = videoView {
            videoView.frame = (self.navigationController?.view.window?.bounds)!
        }
    }
    
    func setResponseDataUI(data: SearchTVObject) {
        
    }
    
    //MARK: - UI
    
    func videoInformationUpdate(track: Dictionary<String, Any>) {
        let videoResolution = "\(track["width"] as! Int)x\(track["height"] as! Int)"
        let codecFourCC = FourCharCode(integerLiteral: track["codec"] as! UInt32).toString()
        
        videoDescriptionLabel.text = "\(videoResolution)" + ", \(codecFourCC.toCodecName())"
    }
    
    func audioInformationUpdate(track: Dictionary<String, Any>) {
        let channels = "\(track["channelsNumber"] as! Int)ch"
        let bitrate = "\(track["rate"] as! Float / 1000)kHz"
        let codecFourCC = FourCharCode(integerLiteral: track["codec"] as! UInt32).toString()
        
        audioDescriptionLabel.text = "\(channels)" + ", \(bitrate)" + ", \(codecFourCC.toCodecName())"
    }
    
    func setBackgroundBlurView() {
        blurView.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurView)
    }
    
    func setPrefersHomeIndicator(autoHidden: Bool) {
        self.shouldHideHomeBarIndicator = autoHidden
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let videoView = videoView else {
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            videoView.configureVisibleStatusBar()
            videoView.onRotateScreenUpdate()
            
        }) { (_) in
        }
    }
    
    
    //MARK: - Event     - 플레이
    @IBAction func onMoreTouched(_ sender: UIButton) {
        guard let url = moreURL else { return }
        let storyBoard = UIStoryboard(name: "WebViewController", bundle: nil)
        let webViewController = storyBoard.instantiateInitialViewController() as! WebViewController
        webViewController.url = url
        
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    
    @IBAction func onPlayTouched(_ sender: UIButton) {
        videoView = VideoView(frame: (self.navigationController?.view.window!.bounds)!)
        videoView.delegate = self
        videoView.setPlayItem(item: data!)
        
        videoView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            self.videoView.alpha = 1
            self.navigationController?.view.addSubview(self.videoView)
            
        }) { (completion) in
            //            AppUtility.lockOrientation(.landscape)
            self.setPrefersHomeIndicator(autoHidden: true)
        }
    }
    
    //MARK: - VideoViewDelegate     - 클로즈
    func videoViewDidClosed(videoView: VideoView) {
        AppUtility.lockOrientation(.all)
        self.setPrefersHomeIndicator(autoHidden: false)
        videoView.removeFromSuperview()
        self.videoView = nil
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    
    func videoViewDidPlayed(videoView: VideoView) {
        
    }
    
    
    func videoViewSettingTouched(videoView: VideoView) {
        let storyBoard = UIStoryboard(name: "SettingPopupViewController", bundle: nil)
        let tabViewController = storyBoard.instantiateInitialViewController()
        let settingPopupViewController = PopupViewController(contentController: tabViewController!, popupWidth: 300, popupHeight: 300)
        settingPopupViewController.backgroundAlpha = 0
        settingPopupViewController.cornerRadius = 10
        
        
        let _ = tabViewController?.children.map {
            if $0.children[0] is SubTitlePopupViewController {
                ($0.children[0] as! SubTitlePopupViewController).mediaPlayer = videoView.mediaPlayer
            }
            else if $0.children[0] is VideoPopupViewController {
                ($0.children[0] as! VideoPopupViewController).videoView = videoView
                ($0.children[0] as! VideoPopupViewController).mediaPlayer = videoView.mediaPlayer                
            }
            else if $0.children[0] is AudioPopupViewController {
                ($0.children[0] as! AudioPopupViewController).videoView = videoView
                ($0.children[0] as! AudioPopupViewController).mediaPlayer = videoView.mediaPlayer
            }
        }
        
        present(settingPopupViewController, animated: true, completion: nil)
    }
    
    deinit {
        print("Asdf")
    }
    
}
