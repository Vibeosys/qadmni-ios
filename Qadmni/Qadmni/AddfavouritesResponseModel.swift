//
//  AddfavouritesResponseModel.swift
//  Qadmni
//
//  Created by Prakash Sabale on 09/03/17.
//  Copyright © 2017 Qadmni. All rights reserved.
//

import Foundation
import EVReflection

public class AddfavouritesResponseModel : CustomerBaseResponseModel
{
    var itemInfoList : [ItemInfoModel] = []
    var producerLocations : [ProducerLocationModel] = []
}
