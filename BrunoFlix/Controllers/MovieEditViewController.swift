//
//  MovieEditViewController.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 07/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import UIKit
import CoreData
import AVKit
import UserNotifications

class MovieEditViewController: UIViewController {

    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfGenre: UITextField!
    @IBOutlet weak var tfReleaseDate: UITextField!
    @IBOutlet weak var tfSummary: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnCover: UIButton!
    @IBOutlet weak var bbiGenre: UIBarButtonItem!
    @IBOutlet weak var tfLembrete: UITextField!
    
    var movie: Movie!
    var genres = [Genre]()
    
    var player: AVPlayer!
    let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    //MARK: - Properties
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    let dpLembrete: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        return dp
    }()
    
    lazy var pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = .white
        pv.dataSource = self
        pv.delegate = self
        return pv
    }()
    
    var listGenres: [Genre] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bbiGenre.title = Localization.genresTitle
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        prepareTextFields()
        
        if movie != nil {
            self.navigationItem.title = Localization.editMovieTitle
            tfTitle.text = movie.title
            tfSummary.text = movie.summary
            tfReleaseDate.text = movie.releaseDate?.formatted
            tfGenre.text = movie.strGenres
            if let unwrappedGenres = movie.genres?.allObjects as? [Genre] {
                genres = unwrappedGenres
            }
            if let photoData = movie.cover {
                ivCover.image = UIImage(data: photoData)
            }
            
            if UserDefaultsManager.autoPlay() {
                playTrailer()
            }
        } else {
            self.navigationItem.title = Localization.newMovieTitle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGenres()
        bgView.backgroundColor = UIColor(named: SegmentedColors.allValues[UserDefaultsManager.colorNumber()].rawValue )
    }
    
    func loadGenres() {
        let fetchRequest: NSFetchRequest<Genre> = Genre.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Genre.name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        listGenres = try! context.fetch(fetchRequest)
        pickerView.reloadAllComponents()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).size.height
        scrollView.contentInset.bottom = height
        scrollView.scrollIndicatorInsets.bottom = height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    // MARK: - Methods
    func prepareTextFields(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let btDoneDate = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneDate))
        let btCancelDate = UIBarButtonItem(title: Localization.btnCancel, style: .done, target: self, action: #selector(cancelDate))
        let btFlexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancelDate, btFlexible, btDoneDate]
        tfReleaseDate.inputView = datePicker
        tfReleaseDate.inputAccessoryView = toolbar
        
        let toolbarGenre = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let btDoneGenre = UIBarButtonItem(title: Localization.btnAdd, style: .done, target: self, action: #selector(doneCourse))
        let btRemoveGenre = UIBarButtonItem(title: Localization.btnRemove, style: .done, target: self, action: #selector(removeGenre))
        toolbarGenre.items = [btRemoveGenre, btFlexible, btDoneGenre]
        tfGenre.inputView = pickerView
        tfGenre.inputAccessoryView = toolbarGenre
        
        let toolbarLembrete = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let btDoneLembrete = UIBarButtonItem(title: Localization.btnAdd, style: .done, target: self, action: #selector(doneLembrete))
        toolbarLembrete.items = [btCancelDate, btFlexible, btDoneLembrete]
        tfLembrete.inputView = dpLembrete
        tfLembrete.inputAccessoryView = toolbarLembrete
        
        tfTitle.placeholder = Localization.placeholderMovieTitle
        tfGenre.placeholder = Localization.placeholderGenre
        tfReleaseDate.placeholder = Localization.placeholderReleaseDate
        btnCover.setTitle(Localization.btnImgCover, for: UIControl.State.normal)
    }
    
    @objc func doneDate() {
        tfReleaseDate.text = datePicker.date.formatted
        cancelDate()
    }
    
    @objc func doneCourse() {
        
        if !genres.contains(listGenres[pickerView.selectedRow(inComponent: 0)]) {
            genres.append(listGenres[pickerView.selectedRow(inComponent: 0)])
            tfGenre.text = (genres.map{ $0.name } as! [String]).joined(separator: ",")
        }
        cancelDate()
    }
    
    @objc func doneLembrete() {
        tfLembrete.text = dpLembrete.date.formattedWithHour
        cancelDate()
        
    }
    
    @objc func cancelDate() {
        view.endEditing(true)
    }
    
    @objc func removeGenre(){
        
        if genres.contains(listGenres[pickerView.selectedRow(inComponent: 0)]) {
            genres.remove(at: genres.firstIndex(of: listGenres[pickerView.selectedRow(inComponent: 0)])!)
        }
        
        if genres.count > 0 {
            tfGenre.text = (genres.map{ $0.name } as! [String]).joined(separator: ",")
        } else {
            tfGenre.text = ""
        }
        
        if movie != nil {
            movie.removeFromGenres(listGenres[pickerView.selectedRow(inComponent: 0)])
        }
        cancelDate()
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        
        if movie == nil {
            movie = Movie(context: context)
        }
        
        movie.title = tfTitle.text
        movie.releaseDate = datePicker.date
        movie.genres = []
        
        for gen in genres {
            movie.addToGenres(gen)
        }
        
        if let photoData = ivCover.image?.pngData() {
            movie.cover = photoData
        }
        
        movie.summary = tfSummary.text
        
        saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseFoto(_ sender: Any) {
        let alert = UIAlertController(title: Localization.lblMovieCover, message: Localization.lblChoseImage, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: Localization.lblCamera, style: .default) { (_) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        let photoAlbumAction = UIAlertAction(title: Localization.lblPhotoLibrary, style: .default) { (_) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photoAlbumAction)
        let cancelAction = UIAlertAction(title: Localization.btnCancel, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    let videoLauncher = VideoView()
    
    @IBAction func btnTrailer(_ sender: Any) {
        playTrailer()
    }
    
    func playTrailer(){
        guard let _ = tfTitle.text else { return }
        videoLauncher.showVideo(with: tfTitle.titleUrl)
    }
    
    @IBAction func scheduleTrailer(_ sender: Any) {
        
        if tfLembrete.text == "" { return }
        
        let id = String(Date().timeIntervalSince1970)
        let content = UNMutableNotificationContent()
        content.title = tfTitle.text!
        content.body = Localization.msgScheduleMovie
        content.categoryIdentifier = "lembrete"
        
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dpLembrete.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error as Any)
        }
        
        let alert = UIAlertController(title: "Lembrete Agendado", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension MovieEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let smallSize = CGSize(width: image.size.width/10, height: image.size.height/10)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ivCover.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}

extension MovieEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return listGenres.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return listGenres[row].name }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print( listGenres[row].name )
    }
    
}

