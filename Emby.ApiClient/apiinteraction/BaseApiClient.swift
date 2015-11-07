//
//  BaseApiClient.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 03/11/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction;
//
//import mediabrowser.apiinteraction.device.IDevice;
//import mediabrowser.apiinteraction.http.HttpHeaders;
//import mediabrowser.model.apiclient.ApiHelpers;
//import mediabrowser.model.extensions.*;
//import mediabrowser.model.drawing.*;
//import mediabrowser.model.dto.*;
//import mediabrowser.model.entities.*;
//import mediabrowser.model.livetv.*;
//import mediabrowser.model.logging.*;
//import mediabrowser.model.querying.*;
//import mediabrowser.model.serialization.*;
//
//import java.text.DateFormat;
//import java.text.SimpleDateFormat;
//import java.util.Date;
//import java.util.TimeZone;

/**
Provides api methods that are usable on all platforms
*/
//public abstract class BaseApiClient implements IDisposable
public class BaseApiClient// implements IDisposable
{
//    //C# TO JAVA CONVERTER TODO TASK: Events are not available in Java:
//    //	public event EventHandler ServerLocationChanged;
//    private void OnServerLocationChanged()
//    {
//        //if (ServerLocationChanged != null)
//        //{
//        //ServerLocationChanged(this, EventArgs.Empty);
//        //}
//    }
//    
    private var logger: ILogger
    private var jsonSerializer: IJsonSerializer
    private var clientName: String?
    private var device: IDevice?
    private var privateApplicationVersion: String?
    private var privateServerAddress: String
    private var privateAccessToken: String?
    private var privateImageQuality: Int?
    private var privateCurrentUserId: String?
    private let httpHeaders = HttpHeaders()
    
    internal init(logger: ILogger, jsonSerializer: IJsonSerializer, serverAddress: String, clientName: String,
        device: IDevice, applicationVersion: String) {
        self.logger = logger
        self.jsonSerializer = jsonSerializer
        self.clientName = clientName
        self.device = device
        self.privateApplicationVersion = applicationVersion
        self.privateServerAddress = serverAddress
    }
    
    internal init(logger: ILogger, jsonSerializer: IJsonSerializer, serverAddress: String, accessToken: String) {
        self.logger = logger
        self.jsonSerializer = jsonSerializer
        self.privateServerAddress = serverAddress
        self.privateAccessToken = accessToken
    }
    
    public final func setJsonSerializer(value: IJsonSerializer) {
        self.jsonSerializer = value
    }
    
    public final func getJsonSerializer() -> IJsonSerializer? {
        return jsonSerializer
    }
    
    public final func setClientName(value: String) {
        self.clientName = value
    }
    
    public final func getClientName() -> String? {
        return clientName
    }
    
    public final func setApplicationVersion(value: String) {
        self.privateApplicationVersion = value
    }
    
    public final func getApplicationVersion() -> String? {
        return privateApplicationVersion
    }
    
    public final func setServerAddress(value: String) {
        self.privateServerAddress = value
    }
    
    public final func getServerAddress() -> String {
        return privateServerAddress
    }
    
    public final func setAccessToken(value: String?) {
        self.privateAccessToken = value
    }
    
    public final func getAccessToken() -> String? {
        return privateAccessToken
    }
    
    public final func getDevice() -> IDevice? {
        return device
    }
    
    public final func getDeviceName() -> String? {
        return getDevice()?.deviceName
    }
    
    public final func getDeviceId() -> String? {
        return getDevice()?.deviceId
    }
    
    public final func setImageQuality(value: Int) {
        self.privateImageQuality = value
    }
    
    public final func getImageQuality() -> Int? {
        return privateImageQuality
    }
    
    public final func setCurrentUserId(value: String?) {
        self.privateCurrentUserId = value
    }
    
    public final func getCurrentUserId() -> String? {
        return privateCurrentUserId
    }
    
    public final func getApiUrl() -> String {
        return getServerAddress() + "/mediabrowser"
    }
    
    internal final func getAuthorizationScheme() -> String {
        return "MediaBrowser"
    }
    
    public final func changeServerLocation(address: String) {
        setServerAddress(address)
        
        setAuthenticationInfo(nil, userId: nil)
    }
    
    public func setAuthenticationInfo(accessToken: String?, userId: String?) {
        setCurrentUserId(userId)
        setAccessToken(accessToken)
        resetHttpHeaders()
    }
    
    public func setAuthenticationInfo(accessToken: String?) {
        setCurrentUserId(nil)
        setAccessToken(accessToken)
        resetHttpHeaders()
    }
    
    public func clearAuthenticationInfo() {
        setCurrentUserId(nil)
        setAccessToken(nil)
        resetHttpHeaders()
    }
    
    internal func resetHttpHeaders() {
        httpHeaders.setAccessToken(getAccessToken())
        
        if let authValue = getAuthorizationParameter() {
            setAuthorizationHttpRequestHeader(getAuthorizationScheme(), parameter: authValue)
        } else {
            clearHttpRequestHeader("Authorization")
            setAuthorizationHttpRequestHeader(nil, parameter: nil)
        }
    }
    
    internal func setAuthorizationHttpRequestHeader(scheme: String?, parameter: String?) {
        httpHeaders.setAuthorizationScheme(scheme)
        httpHeaders.setAuthorizationParameter(parameter)
    }
    
    private func clearHttpRequestHeader(name: String) {
        httpHeaders.remove(name)
    }
    
    internal func getAuthorizationParameter() -> String? {
        if let clientName = getClientName(),
            let deviceId = getDeviceId(),
            let deviceName = getDeviceName() {
                var header = "Client=\"\(clientName)\", DeviceId=\"\(deviceId)\", Device=\"\(deviceName)\", Version=\"\(getApplicationVersion())\""
                
                if let currentUserId = getCurrentUserId() {
                    header += ", UserId=\"\(currentUserId)\""
                }
                
                return header
        } else {
            return nil
        }
    }
    
    internal final func getSlugName(name: String?) -> String {
        return ApiHelpers.getSlugName(name)
    }
//
//    /**
//    Changes the server location.
//    
//    @param address The address.
//    */
//    public final void ChangeServerLocation(String address)
//    {
//        setServerAddress(address);
//        
//        SetAuthenticationInfo(null, null);
//        
//        OnServerLocationChanged();
//    }
//    
   
    public final func getApiUrl(handler: String?) -> String {
        return getApiUrl(handler, queryString: QueryStringDictionary())
    }
    
    internal final func getApiUrl(handler: String?, queryString: QueryStringDictionary?) -> String {
        return queryString!.getUrl(getApiUrl() + "/" + handler!)
    }

    public final func getSubtitleUrl(options: SubtitleDownloadOptions) -> String {
        let partialUrl: String = "Videos/\(options.itemId)/\(options.mediaSourceId)/Subtitles/\(options.streamIndex)Stream.\(options.format)"
     
        return getApiUrl(partialUrl)
    }

    internal final func getItemListUrl(query: ItemQuery?) -> String {
        let unwrappedQuery = query!
        let dict = QueryStringDictionary()
        
        //dict.addIfNotNil("ParentId", value: unwrappedQuery.parentId)
        //dict.addIfNotNil("ParentId", value: unwrappedQuery.parentId)
        //dict.addIfNotNil("Limit", value: unwrappedQuery.limit)
        //dict.addIfNotNil("SortBy", unwrappedQuery.sortBy)
        //
        //        dict.addIfNotNil("sortOrder", unwrappedQuery.SortOrder)
        //
        //        dict.addIfNotNil("SeriesStatuses", unwrappedQuery.SeriesStatuses)
        //        dict.addIfNotNil("Fields", unwrappedQuery.Fields)
        //        dict.addIfNotNil("Filters", unwrappedQuery.Filters)
        //        dict.addIfNotNil("ImageTypes", unwrappedQuery.ImageTypes)
        //
        //        dict.addIfNotNil("Is3D", unwrappedQuery.Is3D)
        //
        //        dict.addIfNotNil("AirDays", unwrappedQuery.AirDays)
        //        dict.addIfNotNil("VideoTypes", unwrappedQuery.VideoTypes)
        //
        //        dict.addIfNotNil("MinOfficialRating", unwrappedQuery.MinOfficialRating)
        //        dict.addIfNotNil("MaxOfficialRating", unwrappedQuery.MaxOfficialRating)
        //
        //        dict.Add("recursive", unwrappedQuery.Recursive)
        //
        //        dict.addIfNotNil("MinIndexNumber", unwrappedQuery.MinIndexNumber)
        //
        //        dict.addIfNotNil("MediaTypes", unwrappedQuery.MediaTypes)
        //        dict.addIfNotNil("Genres", unwrappedQuery.Genres(), "|")
        //        dict.addIfNotNil("Ids", unwrappedQuery.Ids)
        //        dict.addIfNotNil("StudioIds", unwrappedQuery.StudioIds(), "|")
        //        dict.addIfNotNil("ExcludeItemTypes", unwrappedQuery.ExcludeItemTypes)
        //        dict.addIfNotNil("IncludeItemTypes", unwrappedQuery.IncludeItemTypes)
        //        dict.addIfNotNil("ArtistIds", unwrappedQuery.ArtistIds)
        //
        //        dict.addIfNotNil("IsPlayed", unwrappedQuery.IsPlayed)
        //        dict.addIfNotNil("IsInBoxSet", unwrappedQuery.IsInBoxSet)
        //
        //        dict.addIfNotNil("PersonIds", unwrappedQuery.PersonIds)
        //        dict.addIfNotNil("PersonTypes", unwrappedQuery.PersonTypes)
        //
        //        dict.addIfNotNil("Years", unwrappedQuery.Years)
        //
        //        dict.addIfNotNil("ParentIndexNumber", unwrappedQuery.ParentIndexNumber)
        //        dict.addIfNotNil("IsHD", unwrappedQuery.IsHD)
        //        dict.addIfNotNil("HasParentalRating", unwrappedQuery.HasParentalRating)
        //
        //        dict.addIfNotNil("SearchTerm", unwrappedQuery.SearchTerm)
        //
        //        dict.addIfNotNil("MinCriticRating", unwrappedQuery.MinCriticRating)
        //        dict.addIfNotNil("MinCommunityRating", unwrappedQuery.MinCommunityRating)
        //
        //        dict.addIfNotNil("MinPlayers", unwrappedQuery.MinPlayers)
        //        dict.addIfNotNil("MaxPlayers", unwrappedQuery.MaxPlayers)
        //        dict.addIfNotNil("NameStartsWithOrGreater", unwrappedQuery.NameStartsWithOrGreater)
        //        dict.addIfNotNil("NameStartsWith", unwrappedQuery.NameStartsWith)
        //        dict.addIfNotNil("NameLessThan", unwrappedQuery.NameLessThan)
        //        dict.addIfNotNil("AlbumArtistStartsWithOrGreater", unwrappedQuery.AlbumArtistStartsWithOrGreater)
        //
        //        dict.addIfNotNil("LocationTypes", unwrappedQuery.LocationTypes)
        //        dict.addIfNotNil("ExcludeLocationTypes", unwrappedQuery.ExcludeLocationTypes)
        //
        //        dict.addIfNotNil("IsMissing", unwrappedQuery.IsMissing)
        //        dict.addIfNotNil("IsUnaired", unwrappedQuery.IsUnaired)
        //        dict.addIfNotNil("IsVirtualUnaired", unwrappedQuery.IsVirtualUnaired)
        //        
        //        dict.addIfNotNil("EnableImages", unwrappedQuery.EnableImages)
        //        dict.addIfNotNil("ImageTypeLimit", unwrappedQuery.ImageTypeLimit)
        //        dict.addIfNotNil("EnableImageTypes", unwrappedQuery.EnableImageTypes)
        //        
        //        dict.AddIfNotNull("AiredDuringSeason", unwrappedQuery.AiredDuringSeason)
        
        return getApiUrl("Users/\(unwrappedQuery.userId)/Items", queryString: dict)
    }
//    
//    /**
//    Creates a url to return a list of items
//    
//    @param query The query.
//    @return System.String.
//    @exception System.ArgumentNullException query
//    */
//    protected final String GetItemListUrl(ItemQuery query)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNullOrEmpty("ParentId", query.getParentId())
//        
//        dict.AddIfNotNull("StartIndex", query.getStartIndex());
//        
//        dict.AddIfNotNull("Limit", query.getLimit());
//        
//        dict.AddIfNotNull("SortBy", query.getSortBy());
//        
//        dict.AddIfNotNull("sortOrder", query.getSortOrder());
//        
//        dict.AddIfNotNull("SeriesStatuses", query.getSeriesStatuses());
//        dict.AddIfNotNull("Fields", query.getFields());
//        dict.AddIfNotNull("Filters", query.getFilters());
//        dict.AddIfNotNull("ImageTypes", query.getImageTypes());
//        
//        dict.AddIfNotNull("Is3D", query.getIs3D());
//        
//        dict.AddIfNotNull("AirDays", query.getAirDays());
//        dict.AddIfNotNull("VideoTypes", query.getVideoTypes());
//        
//        dict.AddIfNotNullOrEmpty("MinOfficialRating", query.getMinOfficialRating());
//        dict.AddIfNotNullOrEmpty("MaxOfficialRating", query.getMaxOfficialRating());
//        
//        dict.Add("recursive", query.getRecursive());
//        
//        dict.AddIfNotNull("MinIndexNumber", query.getMinIndexNumber());
//        
//        dict.AddIfNotNull("MediaTypes", query.getMediaTypes());
//        dict.AddIfNotNull("Genres", query.getGenres(), "|");
//        dict.AddIfNotNull("Ids", query.getIds());
//        dict.AddIfNotNull("StudioIds", query.getStudioIds(), "|");
//        dict.AddIfNotNull("ExcludeItemTypes", query.getExcludeItemTypes());
//        dict.AddIfNotNull("IncludeItemTypes", query.getIncludeItemTypes());
//        dict.AddIfNotNull("ArtistIds", query.getArtistIds());
//        
//        dict.AddIfNotNull("IsPlayed", query.getIsPlayed());
//        dict.AddIfNotNull("IsInBoxSet", query.getIsInBoxSet());
//        
//        dict.AddIfNotNull("PersonIds", query.getPersonIds());
//        dict.AddIfNotNull("PersonTypes", query.getPersonTypes());
//        
//        dict.AddIfNotNull("Years", query.getYears());
//        
//        dict.AddIfNotNull("ParentIndexNumber", query.getParentIndexNumber());
//        dict.AddIfNotNull("IsHD", query.getIsHD());
//        dict.AddIfNotNull("HasParentalRating", query.getHasParentalRating());
//        
//        dict.AddIfNotNullOrEmpty("SearchTerm", query.getSearchTerm());
//        
//        dict.AddIfNotNull("MinCriticRating", query.getMinCriticRating());
//        dict.AddIfNotNull("MinCommunityRating", query.getMinCommunityRating());
//        
//        dict.AddIfNotNull("MinPlayers", query.getMinPlayers());
//        dict.AddIfNotNull("MaxPlayers", query.getMaxPlayers());
//        dict.AddIfNotNullOrEmpty("NameStartsWithOrGreater", query.getNameStartsWithOrGreater());
//        dict.AddIfNotNullOrEmpty("NameStartsWith", query.getNameStartsWith());
//        dict.AddIfNotNullOrEmpty("NameLessThan", query.getNameLessThan());
//        dict.AddIfNotNullOrEmpty("AlbumArtistStartsWithOrGreater", query.getAlbumArtistStartsWithOrGreater());
//        
//        dict.AddIfNotNull("LocationTypes", query.getLocationTypes());
//        dict.AddIfNotNull("ExcludeLocationTypes", query.getExcludeLocationTypes());
//        
//        dict.AddIfNotNull("IsMissing", query.getIsMissing());
//        dict.AddIfNotNull("IsUnaired", query.getIsUnaired());
//        dict.AddIfNotNull("IsVirtualUnaired", query.getIsVirtualUnaired());
//        
//        dict.AddIfNotNull("EnableImages", query.getEnableImages());
//        dict.AddIfNotNull("ImageTypeLimit", query.getImageTypeLimit());
//        dict.AddIfNotNull("EnableImageTypes", query.getEnableImageTypes());
//        
//        dict.AddIfNotNull("AiredDuringSeason", query.getAiredDuringSeason());
//        
//        return GetApiUrl("Users/" + query.getUserId() + "/Items", dict);
//    }
//    
//    /**
//    Gets the next up.
//    
//    @param query The query.
//    @return System.String.
//    @exception System.ArgumentNullException query
//    */
//    protected final String GetNextUpUrl(NextUpQuery query)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNull("Fields", query.getFields());
//        
//        dict.AddIfNotNull("Limit", query.getLimit());
//        
//        dict.AddIfNotNull("StartIndex", query.getStartIndex());
//        
//        dict.Add("UserId", query.getUserId());
//        dict.AddIfNotNullOrEmpty("SeriesId", query.getSeriesId());
//        
//        dict.AddIfNotNull("EnableImages", query.getEnableImages());
//        dict.AddIfNotNull("ImageTypeLimit", query.getImageTypeLimit());
//        dict.AddIfNotNull("EnableImageTypes", query.getEnableImageTypes());
//        
//        return GetApiUrl("Shows/NextUp", dict);
//    }
//    
//    /**
//    Gets the similar item list URL.
//    
//    @param query The query.
//    @param type The type.
//    @return System.String.
//    @exception System.ArgumentNullException
//    query
//    or
//    type
//    
//    */
//    protected final String GetSimilarItemListUrl(SimilarItemsQuery query, String type)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(type))
//        {
//            throw new IllegalArgumentException("type");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNull("Limit", query.getLimit());
//        dict.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        
//        dict.AddIfNotNull("Fields", query.getFields());
//        
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(query.getId()))
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        return GetApiUrl(type + "/" + query.getId() + "/Similar", dict);
//    }
//    
//    /**
//    Gets the instant mix URL.
//    
//    @param query The query.
//    @param type The type.
//    @return System.String.
//    @exception System.ArgumentNullException
//    query
//    or
//    type
//    
//    */
//    protected final String GetInstantMixUrl(SimilarItemsQuery query, String type)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(type))
//        {
//            throw new IllegalArgumentException("type");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNull("Limit", query.getLimit());
//        dict.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        
//        dict.AddIfNotNull("Fields", query.getFields());
//        
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(query.getId()))
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        return GetApiUrl(type + "/" + query.getId() + "/InstantMix", dict);
//    }
//    
//    /**
//    Gets the item by name list URL.
//    
//    @param type The type.
//    @param query The query.
//    @return System.String.
//    @exception System.ArgumentNullException query
//    */
//    protected final String GetItemByNameListUrl(String type, ItemsByNameQuery query)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.AddIfNotNullOrEmpty("ParentId", query.getParentId());
//        
//        dict.Add("UserId", query.getUserId());
//        dict.AddIfNotNull("StartIndex", query.getStartIndex());
//        
//        dict.AddIfNotNull("Limit", query.getLimit());
//        
//        dict.AddIfNotNull("SortBy", query.getSortBy());
//        
//        dict.AddIfNotNull("sortOrder", query.getSortOrder());
//        
//        dict.AddIfNotNull("IsPlayed", query.getIsPlayed());
//        
//        dict.AddIfNotNull("Fields", query.getFields());
//        
//        dict.AddIfNotNull("Filters", query.getFilters());
//        dict.AddIfNotNull("ImageTypes", query.getImageTypes());
//        
//        dict.Add("recursive", query.getRecursive());
//        
//        dict.AddIfNotNull("MediaTypes", query.getMediaTypes());
//        dict.AddIfNotNull("ExcludeItemTypes", query.getExcludeItemTypes());
//        dict.AddIfNotNull("IncludeItemTypes", query.getIncludeItemTypes());
//        
//        dict.AddIfNotNullOrEmpty("NameLessThan", query.getNameLessThan());
//        dict.AddIfNotNullOrEmpty("NameStartsWith", query.getNameStartsWith());
//        dict.AddIfNotNullOrEmpty("NameStartsWithOrGreater", query.getNameStartsWithOrGreater());
//        
//        dict.AddIfNotNull("EnableImages", query.getEnableImages());
//        dict.AddIfNotNull("ImageTypeLimit", query.getImageTypeLimit());
//        dict.AddIfNotNull("EnableImageTypes", query.getEnableImageTypes());
//        
//        return GetApiUrl(type, dict);
//    }
//    
//    /**
//    Gets the image URL.
//    
//    @param baseUrl The base URL.
//    @param options The options.
//    @param queryParams The query params.
//    @return System.String.
//    @exception System.ArgumentNullException options
//    */
//    private String GetImageUrl(String baseUrl, ImageOptions options, QueryStringDictionary queryParams)
//    {
//        if (options == null)
//        {
//            throw new IllegalArgumentException("options");
//        }
//        
//        if (queryParams == null)
//        {
//            throw new IllegalArgumentException("queryParams");
//        }
//        
//        if (options.getImageIndex() != null)
//        {
//            baseUrl += "/" + options.getImageIndex().intValue();
//        }
//        
//        queryParams.AddIfNotNull("Width", options.getWidth());
//        queryParams.AddIfNotNull("Height", options.getHeight());
//        queryParams.AddIfNotNull("MaxWidth", options.getMaxWidth());
//        queryParams.AddIfNotNull("MaxHeight", options.getMaxHeight());
//        queryParams.AddIfNotNull("Quality", (options.getQuality() != null) ? options.getQuality() : getImageQuality());
//        
//        queryParams.AddIfNotNullOrEmpty("Tag", options.getTag());
//        
//        queryParams.AddIfNotNull("CropWhitespace", options.getCropWhitespace());
//        queryParams.Add("EnableImageEnhancers", options.getEnableImageEnhancers());
//        
//        if (options.getFormat() != null)
//        {
//            queryParams.Add("Format", options.getFormat().toString());
//        }
//        
//        if (options.getAddPlayedIndicator())
//        {
//            queryParams.Add("AddPlayedIndicator", true);
//        }
//        queryParams.AddIfNotNull("UnPlayedCount", options.getUnPlayedCount());
//        queryParams.AddIfNotNull("PercentPlayed", options.getPercentPlayed());
//        queryParams.AddIfNotNullOrEmpty("BackgroundColor", options.getBackgroundColor());
//        
//        return GetApiUrl(baseUrl, queryParams);
//    }
//    
//    /**
//    Gets the image URL.
//    
//    @param item The item.
//    @param options The options.
//    @return System.String.
//    */
//    public final String GetImageUrl(BaseItemDto item, ImageOptions options)
//    {
//        if (item == null)
//        {
//            throw new IllegalArgumentException("item");
//        }
//        
//        if (options == null)
//        {
//            throw new IllegalArgumentException("options");
//        }
//        
//        options.setTag(GetImageTag(item, options));
//        
//        return GetImageUrl(item.getId(), options);
//    }
//    
//    public final String GetImageUrl(ChannelInfoDto item, ImageOptions options)
//    {
//        if (item == null)
//        {
//            throw new IllegalArgumentException("item");
//        }
//        
//        if (options == null)
//        {
//            throw new IllegalArgumentException("options");
//        }
//        
//        options.setTag(item.getImageTags().get(options.getImageType()));
//        
//        return GetImageUrl(item.getId(), options);
//    }
//    
//    /**
//    Gets an image url that can be used to download an image from the api
//    
//    @param itemId The Id of the item
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException itemId
//    */
//    public final String GetImageUrl(String itemId, ImageOptions options)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId))
//        {
//            throw new IllegalArgumentException("itemId");
//        }
//        
//        String url = "Items/" + itemId + "/Images/" + options.getImageType();
//        
//        return GetImageUrl(url, options, new QueryStringDictionary());
//    }
//    
//    /**
//    Gets the user image URL.
//    
//    @param user The user.
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException user
//    */
//    public final String GetUserImageUrl(UserDto user, ImageOptions options)
//    {
//        if (user == null)
//        {
//            throw new IllegalArgumentException("user");
//        }
//        
//        if (options == null)
//        {
//            throw new IllegalArgumentException("options");
//        }
//        
//        options.setTag(user.getPrimaryImageTag());
//        
//        return GetUserImageUrl(user.getId(), options);
//    }
//    
//    /**
//    Gets an image url that can be used to download an image from the api
//    
//    @param userId The Id of the user
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException userId
//    */
//    public final String GetUserImageUrl(String userId, ImageOptions options)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(userId))
//        {
//            throw new IllegalArgumentException("userId");
//        }
//        
//        String url = "Users/" + userId + "/Images/" + options.getImageType();
//        
//        return GetImageUrl(url, options, new QueryStringDictionary());
//    }
//    
//    /**
//    Gets the person image URL.
//    
//    @param item The item.
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException item
//    */
//    public final String GetPersonImageUrl(BaseItemPerson item, ImageOptions options)
//    {
//        if (item == null)
//        {
//            throw new IllegalArgumentException("item");
//        }
//        
//        if (options == null)
//        {
//            throw new IllegalArgumentException("options");
//        }
//        
//        options.setTag(item.getPrimaryImageTag());
//        
//        return GetImageUrl(item.getId(), options);
//    }
//    
//    /**
//    Gets the image tag.
//    
//    @param item The item.
//    @param options The options.
//    @return System.String.
//    */
//    private String GetImageTag(BaseItemDto item, ImageOptions options)
//    {
//        if (options.getImageType() == ImageType.Backdrop)
//        {
//            return item.getBackdropImageTags().get((options.getImageIndex() != null) ? options.getImageIndex() : 0);
//        }
//        
//        if (options.getImageType() == ImageType.Screenshot)
//        {
//            return item.getScreenshotImageTags().get((options.getImageIndex() != null) ? options.getImageIndex() : 0);
//        }
//        
//        if (options.getImageType() == ImageType.Chapter)
//        {
//            return item.getChapters().get((options.getImageIndex() != null) ? options.getImageIndex() : 0).getImageTag();
//        }
//        
//        return item.getImageTags().get(options.getImageType());
//    }
//    
//    /**
//    Gets an image url that can be used to download an image from the api
//    
//    @param name The name.
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException name
//    */
//    public final String GetGenreImageUrl(String name, ImageOptions options)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(name))
//        {
//            throw new IllegalArgumentException("name");
//        }
//        
//        String url = "Genres/" + GetSlugName(name) + "/Images/" + options.getImageType();
//        
//        return GetImageUrl(url, options, new QueryStringDictionary());
//    }
//    
//    /**
//    Gets the music genre image URL.
//    
//    @param name The name.
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException name
//    */
//    public final String GetMusicGenreImageUrl(String name, ImageOptions options)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(name))
//        {
//            throw new IllegalArgumentException("name");
//        }
//        
//        String url = "MusicGenres/" + GetSlugName(name) + "/Images/" + options.getImageType();
//        
//        return GetImageUrl(url, options, new QueryStringDictionary());
//    }
//    
//    /**
//    Gets the game genre image URL.
//    
//    @param name The name.
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException name
//    */
//    public final String GetGameGenreImageUrl(String name, ImageOptions options)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(name))
//        {
//            throw new IllegalArgumentException("name");
//        }
//        
//        String url = "GameGenres/" + GetSlugName(name) + "/Images/" + options.getImageType();
//        
//        return GetImageUrl(url, options, new QueryStringDictionary());
//    }
//    
//    /**
//    Gets an image url that can be used to download an image from the api
//    
//    @param name The name.
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException name
//    */
//    public final String GetStudioImageUrl(String name, ImageOptions options)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(name))
//        {
//            throw new IllegalArgumentException("name");
//        }
//        
//        String url = "Studios/" + GetSlugName(name) + "/Images/" + options.getImageType();
//        
//        return GetImageUrl(url, options, new QueryStringDictionary());
//    }
//    
//    /**
//    Gets the artist image URL.
//    
//    @param name The name.
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException name
//    */
//    public final String GetArtistImageUrl(String name, ImageOptions options)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(name))
//        {
//            throw new IllegalArgumentException("name");
//        }
//        
//        String url = "Artists/" + GetSlugName(name) + "/Images/" + options.getImageType();
//        
//        return GetImageUrl(url, options, new QueryStringDictionary());
//    }
//    
//    /**
//    This is a helper to get a list of backdrop url's from a given ApiBaseItemWrapper. If the actual item does not have any backdrops it will return backdrops from the first parent that does.
//    
//    @param item A given item.
//    @param options The options.
//    @return System.String[][].
//    @exception System.ArgumentNullException item
//    */
//    public final String[] GetBackdropImageUrls(BaseItemDto item, ImageOptions options)
//    {
//        if (item == null)
//        {
//            throw new IllegalArgumentException("item");
//        }
//        
//        if (options == null)
//        {
//            throw new IllegalArgumentException("options");
//        }
//        
//        options.setImageType(ImageType.Backdrop);
//        
//        String backdropItemId;
//        java.util.ArrayList<String> backdropImageTags;
//        
//        if (item.getBackdropCount() == 0)
//        {
//            backdropItemId = item.getParentBackdropItemId();
//            backdropImageTags = item.getParentBackdropImageTags();
//        }
//        else
//        {
//            backdropItemId = item.getId();
//            backdropImageTags = item.getBackdropImageTags();
//        }
//        
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(backdropItemId))
//        {
//            return new String[] { };
//        }
//        
//        String[] files = new String[backdropImageTags.size()];
//        
//        for (int i = 0; i < backdropImageTags.size(); i++)
//        {
//            options.setImageIndex(i);
//            options.setTag(backdropImageTags.get(i));
//            
//            files[i] = GetImageUrl(backdropItemId, options);
//        }
//        
//        return files;
//    }
//    
//    /**
//    This is a helper to get the logo image url from a given ApiBaseItemWrapper. If the actual item does not have a logo, it will return the logo from the first parent that does, or null.
//    
//    @param item A given item.
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException item
//    */
//    public final String GetLogoImageUrl(BaseItemDto item, ImageOptions options)
//    {
//        if (item == null)
//        {
//            throw new IllegalArgumentException("item");
//        }
//        
//        if (options == null)
//        {
//            throw new IllegalArgumentException("options");
//        }
//        
//        options.setImageType(ImageType.Logo);
//        
//        //C# TO JAVA CONVERTER TODO TASK: There is no equivalent to implicit typing in Java:
//        String logoItemId = item.getHasLogo() ? item.getId() : item.getParentLogoItemId();
//        //C# TO JAVA CONVERTER TODO TASK: There is no equivalent to implicit typing in Java:
//        String imageTag = item.getHasLogo() ? item.getImageTags().get(ImageType.Logo) : item.getParentLogoImageTag();
//        
//        if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(logoItemId))
//        {
//            options.setTag(imageTag);
//            
//            return GetImageUrl(logoItemId, options);
//        }
//        
//        return null;
//    }
//    
//    public final String GetThumbImageUrl(BaseItemDto item, ImageOptions options)
//    {
//        if (item == null)
//        {
//            throw new IllegalArgumentException("item");
//        }
//        
//        if (options == null)
//        {
//            throw new IllegalArgumentException("options");
//        }
//        
//        options.setImageType(ImageType.Thumb);
//        
//        //C# TO JAVA CONVERTER TODO TASK: There is no equivalent to implicit typing in Java:
//        String itemId = item.getHasThumb() ? item.getId() : item.getSeriesThumbImageTag() != null ? item.getSeriesId() : item.getParentThumbItemId();
//        //C# TO JAVA CONVERTER TODO TASK: There is no equivalent to implicit typing in Java:
//        String imageTag = item.getHasThumb() ? item.getImageTags().get(ImageType.Thumb) : (item.getSeriesThumbImageTag() != null) ? item.getSeriesThumbImageTag() : item.getParentThumbImageTag();
//        
//        if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId))
//        {
//            options.setTag(imageTag);
//            
//            return GetImageUrl(itemId, options);
//        }
//        
//        return null;
//    }
//    
//    /** 
//    This is a helper to get the art image url from a given BaseItemDto. If the actual item does not have a logo, it will return the logo from the first parent that does, or null.
//    
//    @param item A given item.
//    @param options The options.
//    @return System.String.
//    @exception System.ArgumentNullException item
//    */
//    public final String GetArtImageUrl(BaseItemDto item, ImageOptions options)
//    {
//        if (item == null)
//        {
//            throw new IllegalArgumentException("item");
//        }
//        
//        if (options == null)
//        {
//            throw new IllegalArgumentException("options");
//        }
//        
//        options.setImageType(ImageType.Art);
//        
//        //C# TO JAVA CONVERTER TODO TASK: There is no equivalent to implicit typing in Java:
//        String artItemId = item.getHasArtImage() ? item.getId() : item.getParentArtItemId();
//        //C# TO JAVA CONVERTER TODO TASK: There is no equivalent to implicit typing in Java:
//        String imageTag = item.getHasArtImage() ? item.getImageTags().get(ImageType.Art) : item.getParentArtImageTag();
//        
//        if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(artItemId))
//        {
//            options.setTag(imageTag);
//            
//            return GetImageUrl(artItemId, options);
//        }
//        
//        return null;
//    }
//    
//    protected final <T> T DeserializeFromString(String stream, java.lang.Class type)
//    {
//        return getJsonSerializer().DeserializeFromString(stream, type);
//    }
//    
//    /** 
//    Serializers to json.
//    
//    @param obj The obj.
//    @return System.String.
//    */
//    protected final String SerializeToJson(Object obj)
//    {
//        return getJsonSerializer().SerializeToString(obj);
//    }
//    
//    /** 
//    Adds the data format.
//    
//    @param url The URL.
//    @return System.String.
//    */
//    protected final String AddDataFormat(String url)
//    {
//        if (url == null)
//        {
//            throw new IllegalArgumentException("url");
//        }
//        
//        final String format = "json";
//        
//        if (url.indexOf('?') == -1)
//        {
//            url += "?format=" + format;
//        }
//        else
//        {
//            url += "&format=" + format;
//        }
//        
//        return url;
//    }
//    
//    public String getIsoString(Date date){
//        
//        if (date == null)
//        {
//            throw new IllegalArgumentException("date");
//        }
//        
//        TimeZone tz = TimeZone.getTimeZone("UTC");
//        DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm'Z'");
//        df.setTimeZone(tz);
//        
//        return df.format(date);
//    }
//    
//    /** 
//    Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
//    */
//    public final void Dispose()
//    {
//        Dispose(true);
//    }
//    
//    /** 
//    Releases unmanaged and - optionally - managed resources.
//    
//    @param disposing <c>true</c> to release both managed and unmanaged resources; <c>false</c> to release only unmanaged resources.
//    */
//    protected void Dispose(boolean disposing)
//    {
//        
//    }
}