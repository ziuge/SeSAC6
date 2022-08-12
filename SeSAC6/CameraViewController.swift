//
//  CameraViewController.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/12.
//

import UIKit

import Alamofire
import SwiftyJSON
import YPImagePicker

class CameraViewController: UIViewController {

    @IBOutlet weak var resultImageView: UIImageView!
    
    // UIImagePickerController 1.
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIImagePickerController 2.
        picker.delegate = self
    }
    
    // Open Source
    // 권한은 다 허용하기!
    @IBAction func YPImagePickerBtnClicked(_ sender: UIButton) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    // UIImagePickerController
    @IBAction func cameraBtnClicked(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트/알럿")
            return
        }
        
        picker.sourceType = .camera
        picker.allowsEditing = true // 편집 화면
        present(picker, animated: true)
        
    }
    
    // UIImagePickerController
    @IBAction func photoLibraryBtnClicked(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용불가 + 사용자에게 토스트/알럿")
            return
        }
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true // 편집 화면
        present(picker, animated: true)
    }
    
    // 저장
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        if let image = resultImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

    // ClovaFace 얼굴 분석 > 응답
    // 문자열이 아닌 파일, 이미지, PDF 자체가 그대로 전송되지 않음 -> 텍스트 형태로 인코딩
    // 어떤 파일의 종류가 서버에게 전달이 되는지 명시 = Content Type
    @IBAction func clovaFaceBtnClicked(_ sender: UIButton) {
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "\(APIKey.NAVER_ID)",
            "X-Naver-Client-Secret" : "\(APIKey.NAVER_SECRET)",
//            "Content-Type": "multipart/form-data" 라이브러리에 내장되어 있어서 작성하지 않아도 됨
        ]
        
        // UIImage를 텍스트 형태(바이너리 타입)로 반환해서 전달
        guard let imageData = resultImageView.image?.pngData() else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image") //
        }, to: url, headers: header)
            .validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print( "JSON: \(json)")
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

// UIImagePickerController 3.
// 네비게이션 컨트롤러를 상속받고 있음.
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerController 4. 사진을 선택하거나 카메라 촬영 직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        // 원본, 편집, 메타 데이터 등 - infoKey 로 가져옴
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.resultImageView.image = image
            dismiss(animated: true)
        }
        // imagePicker 아이폰 기본 카메라 -> UI 변경은 불가능
    }
    
    // UIImagePickerController 5. 취소 버튼 클릭 시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }
    
}
