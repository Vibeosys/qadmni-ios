//
//  MyFavouritesTableViewController.swift
//  Qadmni
//
//  Created by Prakash Sabale on 31/01/17.
//  Copyright © 2017 Qadmni. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import EVReflection
import Cosmos

class MyFavouritesTableViewController: UITableViewController,CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var userDefaultManager : UserDefaultManager = UserDefaultManager()
    var customerLattitude : Double = 0
    var customerLongitude : Double = 0
    let coreData = CoreData()
    
    var itemList:[DisplayItemList]=[]
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewDidLayoutSubviews()
    {
    
    }
    
    // Mark :- CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        customerLattitude = 18.5248902//locValue.latitude
        customerLongitude = 73.7225364//locValue.longitude
        if(customerLattitude>0&&customerLongitude>0)
        {
            locationManager.stopUpdatingLocation()
            
                coreData.deleteMyFavourite()
                let addfavouriteReqModel = AddfavouriteReqModel()
                let customerAddfavUser :CustomerUserRequestModel = self.userDefaultManager.getCustomerCredential()
                let customerAddfavLangCode = CustomerLangCodeRequestModel()
                let serviceFacadeUser = ServiceFacadeUser(configUrl : PropertyReaderFile.getBaseUrl())
                serviceFacadeUser.customerAddFavourites(customerDataRequest: addfavouriteReqModel,
                                                        customerUserRequest: customerAddfavUser,
                                                        customerLangCodeRequest: customerAddfavLangCode,
                                                        completionHandler: {
                                                            response in
                                                            if (response?.errorCode == 0)
                                                            {
                                                                for item in (response?.itemInfoList)!
                                                                {
                                                                    let myFavorite = MyFavouritesModel()
                                                                    myFavorite.itemId = item.itemId
                                                                    self.coreData.saveUserFavourites(myfavourites: myFavorite)
                                                                    
                                                                }
                                                                let producerLocationsData : [ProducerLocationModel]=(response?.producerLocations)!
                                                                var producerList:[ProducerItemListdataModel]=[]
                                                                for producerLocationmodel:ProducerLocationModel in producerLocationsData
                                                                {
                                                                    var producerListData : ProducerItemListdataModel=ProducerItemListdataModel()
                                                                    producerListData.businessLat=producerLocationmodel.businessLat
                                                                    producerListData.businessLong=producerLocationmodel.businessLong
                                                                    producerListData.businessName=producerLocationmodel.businessName
                                                                    producerListData.producerId=producerLocationmodel.producerId
                                                                    producerList.append(producerListData)
                                                                }
                                                                self.getLocationInBack(producers: producerList, items: (response?.itemInfoList)!)

                                                            }else{
                                                                print("No favourite found")
                                                            }
                                                           
                })
                
            
            
        }
        
    }

   
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyFavouritesTableViewCell
        if(cell != nil)
        {
            cell?.itemName.text = self.itemList[indexPath.row].itemName
            cell?.itemDescription.text = self.itemList[indexPath.row].itemDesc
            cell?.distanceLabel.text = self.itemList[indexPath.row].producerData.distance
            cell?.timeLabel.text = self.itemList[indexPath.row].producerData.time
            cell?.producerNameLabel.text = self.itemList[indexPath.row].producerData.businessName
            cell?.offerLabel.text = self.itemList[indexPath.row].offerText
            cell?.itemName.text = self.itemList[indexPath.row].itemName
            let amountString : String = String(self.itemList[indexPath.row].unitPrice)
            cell?.amountLabel.text = amountString
            let reviewString : String = String(self.itemList[indexPath.row].reviews)
            cell?.reviewLabel.text = reviewString + " Review"
            let rating : Double = Double(self.itemList[indexPath.row].rating)!
            cell?.itemRatingView.rating = rating
            
            
            let url = URL(string:self.itemList[indexPath.row].imageUrl)
            if(url == nil){}
            else
            {
                let data = NSData(contentsOf:url!)
                cell?.itemImage.image = UIImage(data:data as! Data)
            }
            
            cell?.qautityLabel.text = String(self.itemList[indexPath.row].itemQuantity)
            if (self.itemList[indexPath.row].isFavourite)
            {
                cell?.favImage.image = UIImage(named :"favouritesSelected")
            }else{
                cell?.favImage.image = UIImage(named :"favourites")
            }
            cell?.stepperValue.tag = indexPath.row
            cell?.stepperValue.addTarget(self, action:#selector(stepperTapped(sender:)), for: .touchUpInside)
            cell?.favImage.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedMe(sender:)))
            
            cell?.favImage.addGestureRecognizer(tap)
            cell?.favImage.isUserInteractionEnabled = true
            
        }
        return cell!
            }
    
    func getLocationInBack(producers:[ProducerItemListdataModel],items:[ItemInfoModel])
    {
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            for producerModel: ProducerItemListdataModel in producers{
                let googleDistanceUrl : String = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="
                let apiKey : String = "&key="+"AIzaSyA8CA7g54OOFJFaMp9j8FzS0K0uh4azFCM"
                let custCurrentLocation : String = String(self.customerLattitude)+","+String(self.customerLongitude)
                // let producerLocation : String = "&destinations=" + String(producerModel.businessLat)+","+String(producerModel.businessLong)
                let producerLocation : String = "&destinations=18.5319231,73.829899"
                let finalString : String = googleDistanceUrl+custCurrentLocation+producerLocation+apiKey
                
                Alamofire.request(finalString,
                                  method: .get,
                                  encoding: JSONEncoding.default)
                    .responseJSON{
                        response in
                        
                        guard response.result.isSuccess else{
                            return
                        }
                        //                    guard  let responseValue = response.result.value as? [String : AnyObject]
                        //                        else{
                        //                            return
                        //                    }
                        
                        //debugPrint(responseValue)
                        let dict : NSDictionary = response.result.value  as! NSDictionary
                        var rows: NSArray = dict.value(forKey: "rows") as! NSArray
                        let rowsDict:NSDictionary=rows[0] as! NSDictionary
                        var elements : NSArray = rowsDict.value(forKey: "elements") as! NSArray
                        let elementDist:NSDictionary=elements[0] as! NSDictionary
                        //  var googleDistanceResModel : [GoogleDistanceResModel] = [GoogleDistanceResModel](json:elementDist)
                        //                   var rows:[GoogleDistanceResModel] = []
                        //rows=EVReflection.setPropertiesfromDictionary(dict, anyObject:rows )
                        let distance:NSDictionary=elementDist.value(forKey: "distance") as! NSDictionary
                        producerModel.distance=distance.value(forKey: "text") as! String
                        producerModel.distanceDouble=distance.value(forKey: "value") as! Double
                        let duration : NSDictionary = elementDist.value(forKey: "duration") as! NSDictionary
                        producerModel.time=duration.value(forKey: "text") as! String
                        print(dict)
                        print(elementDist)
                        
                }
            }
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                self.prepareDataForList(producers: producers,items:items)
            }
        }
        
    }
    
    func prepareDataForList(producers:[ProducerItemListdataModel],items:[ItemInfoModel])
    {
        self.itemList.removeAll()
        print("Ready to prepare data")
        for itemInfo: ItemInfoModel in items{
            let displayItem = DisplayItemList()
            displayItem.itemId=itemInfo.itemId
            displayItem.itemName=itemInfo.itemName
            displayItem.itemDesc=itemInfo.itemDesc
            displayItem.imageUrl=itemInfo.imageUrl
            displayItem.unitPrice=itemInfo.unitPrice
            displayItem.rating=itemInfo.rating
            displayItem.offerText=itemInfo.offerText
            displayItem.categoryId=itemInfo.categoryId
            displayItem.reviews=itemInfo.reviews
            displayItem.itemQuantity = coreData.getItemQuantity(itemId: itemInfo.itemId)
            displayItem.isFavourite = coreData.isMyfavourites(itemId: itemInfo.itemId)
            
            displayItem.producerData=self.getProducerById(producerId:itemInfo.producerId,producers:producers)
            self.itemList.append(displayItem)
            
        }
        self.tableView.reloadData()
        
    }
    
    func getProducerById(producerId:Int32,producers:[ProducerItemListdataModel]) -> ProducerItemListdataModel
    {
        var producer=ProducerItemListdataModel()
        for producerData in producers
        {
            if(producerData.producerId==producerId)
            {
                producer=producerData}
        }
        return producer
    }
    func stepperTapped(sender : UIStepper)
    {
        itemList[sender.tag].itemQuantity = Int32(sender.value)
        let cartModel:MyCartModel=MyCartModel()
        cartModel.productId=itemList[sender.tag].itemId
        cartModel.producerId=itemList[sender.tag].producerData.producerId
        cartModel.productName=itemList[sender.tag].itemName
        cartModel.productQuantity = Int16(itemList[sender.tag].itemQuantity)
        cartModel.unitPrice=itemList[sender.tag].unitPrice
        coreData.storeUserData(cartModel: cartModel)
        tableView.reloadData()
        
        
    }
    func tappedMe(sender:UITapGestureRecognizer)
    {
        let itemInfoData : DisplayItemList = itemList[(sender.view?.tag)!]
        let addRemoveFavReqModel = AddRemoveFavReqModel()
        addRemoveFavReqModel.productId = itemInfoData.itemId
        if (itemInfoData.isFavourite)
        {
            addRemoveFavReqModel.favFlag = 0
        }
        else{
            addRemoveFavReqModel.favFlag = 1
        }
        let customerAddfavUser :CustomerUserRequestModel = self.userDefaultManager.getCustomerCredential()
        let customerAddfavLangCode = CustomerLangCodeRequestModel()
        let serviceFacadeUser = ServiceFacadeUser(configUrl : PropertyReaderFile.getBaseUrl())
        serviceFacadeUser.customerAddRemoveFavourites(customerDataRequest: addRemoveFavReqModel,
                                                      customerUserRequest: customerAddfavUser,
                                                      customerLangCodeRequest: customerAddfavLangCode,
                                                      completionHandler: {
                                                        response in
                                                        debugPrint(response)
                                                        if(response?.errorCode == 0)
                                                        {
                                                            itemInfoData.isFavourite = !itemInfoData.isFavourite
                                                            if(itemInfoData.isFavourite)
                                                            {
                                                                var myfavourites = MyFavouritesModel()
                                                                myfavourites.itemId = itemInfoData.itemId
                                                                self.coreData.saveUserFavourites(myfavourites: myfavourites)
                                                            }else{
                                                                self.coreData.deletemyFavouriteItem(itemId: itemInfoData.itemId)
                                                                
                                                            }
                                                            self.tableView.reloadData()
                                                        }
                                                        
        })
        
        
    }




    
}
