//
//  IResponse.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 13/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction;

protocol IResponse {
    func onError(exception: NSError?)
}