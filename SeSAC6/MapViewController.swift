//
//  MapViewController.swift
//  SeSAC6
//
//  Created by CHOI on 2022/08/11.
//

import UIKit
import MapKit
// Location 1. import
import CoreLocation
import AVFoundation

/*
 MapView
 - 지도와 위치 권한은 상관 X
 - 만약 지도에 현재 위치 등을 표현하고 싶다면 위치 권한 등록 해주어야 함 - 상관 O
 - 중심, 범위 지정
 - 핀(어노테이션)
 */

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // Location 2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location 3. 프로토콜 연결
        locationManager.delegate = self

//        checkUserDeviceLocationServiceAuthorization() 제거 가능한 이유 정확히 알기!
        
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegionAndAnnotation(center: center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showRequestLocationServiceAlert()
    }

    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        // 지도 중심 설정: 애플맵 활용해 좌표 복사
//        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        
        // 지도 기반으로 보이는 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        
        
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "이곳은.. 영등포 캠퍼스"
        
        // 지도에 핀 추가
        mapView.addAnnotation(annotation)
    }
    

}

// Location 4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    // Location 5. 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        // ex. 위도 경도 기반으로 날씨 정보 조회, 지도 다시 세팅
        
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate)
        }
        
        // 위치 업데이트 멈추기
        locationManager.stopUpdatingLocation()
        
    }
    
    // Location 6. 사용자의 위치를 가지고 오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // Location 9. 사용자의 권한 상태가 바뀔 때를 알려줌
    // 거부 했다가 설정에서 변경했거나, 혹은 notDetermined에서 허용을 했거나 등
    // 허용 했어서 위치를 가져오는 도중에 설정에서 거부하고 돌아온다면?
    // iOS 14 이상: 사용자의 권한 상태가 변경이 될 때, 위치 관리자 생성할 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}

// 위치 관련된 User Defined 메서드
extension MapViewController {
    // Location 7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
    // 위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져 있다면 커스텀 얼럿으로 상황 알려주기
    /*
     CLAuthorizationStatus
     - denied: 허용 안함 / 설정에서 추후에 거부 / 위치 서비스 중지 / 비행기 모드
     - restricted: 앱 권한 자체가 없는 경우 / 자녀 보호 기능 등으로 아예 제한
     */
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            // 프로퍼티를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 체크: locationServicesEnabled()
        if CLLocationManager.locationServicesEnabled() {
            // 위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    // Location 8. 사용자의 위치 권한 상태 확인
    // 사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인 (단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
            // plist WhenInUse -> request 메서드 OK
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            // 사용자가 위치 허용해두면 startUpdatingLocation을 통해 didUpdateLocations 메서드 실행됨
            locationManager.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          
          // 설정까지 이동하거나 설정 세부화면까지 이동하거나
          // 한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 <- 설정 화면까지 이동
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
}





//extension MapViewController: MKMapViewDelegate {
//    // 지도에 커스텀 핀 추가
////    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
////        <#code#>
////    }
//    
//    // ex. 택시 위치 바뀔때 바로 반영되는 것
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        <#code#>
//    }
//    
//}
