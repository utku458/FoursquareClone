//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Utku Altınay on 2.12.2024.
//

import UIKit
import MapKit
import ParseCore

class DetailsVC: UIViewController , MKMapViewDelegate{

    @IBOutlet weak var detailsImageView: UIImageView!
    
    
    @IBOutlet weak var detailsNameLabel: UILabel!
    
    @IBOutlet weak var detailsTypeLabel: UILabel!
    
    @IBOutlet weak var detailsAthmosphereLabel: UILabel!
    
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    
    @IBOutlet weak var detailsMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromParse()
        detailsMapView.delegate = self
        
     
        

        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil{
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
            
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    
    
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { [self] object, error in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: "hata", preferredStyle: UIAlertController.Style.alert)
                
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }
            
            else{
                if object != nil {
                    let myObject = object![0]
                    if let placeName =  myObject.object(forKey: "name") as? String{
                        self.detailsNameLabel.text = placeName
                    }
                    
                    
                    if let placeType =  myObject.object(forKey: "type") as? String{
                        self.detailsTypeLabel.text = placeType
                    }
                    
                    
                    if let placeAtmosphere =  myObject.object(forKey: "atmosphere") as? String{
                        self.detailsAthmosphereLabel.text = placeAtmosphere
                    }
                    if let placeLatitude = myObject.object(forKey: "latitude") as? String{
                        
                        self.chosenLatitude = Double(placeLatitude) ??  0.0
                        if let placeLongitude = myObject.object(forKey: "longitude") as? String{
                            
                            self.chosenLongitude = Double(placeLongitude) ??  0.0
                            
                        }
                        
                        
                    }
                    
                  
                    
                    if let imageData = myObject.object(forKey: "image") as? PFFileObject{
                        imageData.getDataInBackground { data, error in
                            if error == nil {
                                
                                self.detailsImageView.image = UIImage(data: data!)
                            }
                        }
                    }
                    
                    //maps
                    let location  = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.detailsMapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.detailsNameLabel.text
                    annotation.subtitle = self.detailsTypeLabel.text
                    self.detailsMapView.addAnnotation(annotation)
                    
                    
                    

                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
