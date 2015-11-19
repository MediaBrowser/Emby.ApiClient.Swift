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
    private var device: DeviceProtocol?
    private var privateApplicationVersion: String?
    private var privateServerAddress: String
    private var privateAccessToken: String?
    private var privateImageQuality: Int?
    private var privateCurrentUserId: String?
    private let httpHeaders = HttpHeaders()
    
    internal init(logger: ILogger, jsonSerializer: IJsonSerializer, serverAddress: String, clientName: String,
        device: DeviceProtocol, applicationVersion: String) {
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
    
    public final func getDevice() -> DeviceProtocol? {
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

    internal final func getItemListUrl(query: ItemQuery) -> String {
        let dict = QueryStringDictionary()
        
        dict.addIfNotNilOrEmpty("ParentId", value: query.parentId)
        dict.addIfNotNil("StartIndex", value: query.startIndex)
        dict.addIfNotNil("Limit", value: query.limit)
        dict.add("SortBy", value: query.sortBy)
        dict.addIfNotNil("sortOrder", value: query.sortOrder?.rawValue)
        dict.add("SeriesStatues", value: query.seriesStatus?.map({$0.rawValue}))
        dict.add("Fields", value: query.fields?.map({$0.rawValue}))
        dict.add("Filters", value: query.filters?.map({$0.rawValue}))
        dict.add("ImageTypes", value: query.imageTypes?.map({$0.rawValue}))
        dict.addIfNotNil("Is3d", value: query.is3d)
        dict.add("AirDays", value: query.airDays)
        dict.add("VideoTypes", value: query.videoTypes?.map({$0.rawValue}))
        dict.addIfNotNilOrEmpty("MinOfficialRating", value: query.minOfficialRating)
        dict.addIfNotNilOrEmpty("MaxOfficialRating", value: query.maxOfficialRating)
        dict.addIfNotNil("recursive", value: query.recursive)
        dict.addIfNotNil("MinIndexNumber", value: query.minIndexNumber)
        dict.add("MediaTypes", value: query.mediaTypes)
        dict.addIfNotNil("Genres", value: query.genres?.joinWithSeparator("|"))
        dict.add("Ids", value: query.ids)
        dict.addIfNotNil("StudioIds", value: query.studioIds?.joinWithSeparator("|"))
        dict.add("ExcludeItemTypes", value: query.excludeItemTypes)
        dict.add("IncludeItemTypes", value: query.includeItemTypes)
        dict.add("ArtistIds", value: query.artistIds)
        dict.addIfNotNil("IsPlayed", value: query.isPlayed)
        dict.addIfNotNil("IsInBoxSet", value: query.isInBoxSet)
        dict.add("PersonIds", value: query.personIds)
        dict.add("PersonTypes", value: query.personTypes)
        dict.add("Years", value: query.years)
        dict.addIfNotNil("ParentIndexNumber", value: query.parentIndexNumber)
        dict.addIfNotNil("IsHD", value: query.isHd)
        dict.addIfNotNil("HasParentalRating", value: query.hasParentRating)
        dict.addIfNotNilOrEmpty("SearchTerm", value: query.searchTerm)
        dict.addIfNotNil("MinCriticRating", value: query.minCriticRating)
        dict.addIfNotNil("MinCommunityRating", value: query.minCommunityRating)
        dict.addIfNotNil("MinPlayers", value: query.minPlayers)
        dict.addIfNotNil("MaxPlayers", value: query.maxPlayers)
        dict.addIfNotNilOrEmpty("NameStartsWithOrGreater", value: query.nameStartsWithOrGreater)
        dict.addIfNotNilOrEmpty("NameStartsWith", value: query.nameStartsWith)
        dict.addIfNotNilOrEmpty("NameLessThan", value: query.nameLessThan)
        dict.addIfNotNilOrEmpty("AlbumArtistStartsWithOrGreater", value: query.albumArtistStartsWithOrGreater)
        dict.addIfNotNil("LocationTypes", value: query.locationTypes.map({String($0)}))
        dict.addIfNotNil("ExcludeLocationTypes", value: query.excludeLocationTypes.map({String($0)}))
        dict.addIfNotNil("IsMissing", value: query.isMissing)
        dict.addIfNotNil("IsUnaired", value: query.isUnaired)
        dict.addIfNotNil("IsVirtualUnaired", value: query.isVirtualUnaired)
        dict.addIfNotNil("EnableImages", value: query.enableImages)
        dict.addIfNotNil("ImageTypeLimit", value: query.imageTypeLimit)
        dict.add("EnableImageTypes", value: query.enableImageTypes?.map({$0.rawValue}))
        dict.addIfNotNil("AiredDuringSeason", value: query.airedDuringSeasion)
        
        return getApiUrl("Users/\(query.userId)/Items", queryString: dict)
    }
    
    internal final func getNextUpUrl(query: NextUpQuery) -> String {
        let dict = QueryStringDictionary()
        
        dict.add("Fields", value: query.fields?.map({$0.rawValue}))
        dict.addIfNotNil("Limit", value: query.limit)
        dict.addIfNotNil("StartIndex", value: query.startIndex)
        dict.addIfNotNil("UserId", value: query.userId);
        dict.addIfNotNilOrEmpty("SeriesId", value: query.seriesId);
        dict.addIfNotNil("EnableImages", value: query.enableImages)
        dict.addIfNotNil("ImageTypeLimit", value: query.imageTypeLimit)
        dict.add("EnableImageTypes", value: query.enableImageTypes?.map({$0.rawValue}))
        
        return getApiUrl("Shows/NextUp", queryString: dict)
    }

    internal final func getSimilarItemListUrl(query: SimilarItemsQuery, type: String?) -> String {
        let dict = QueryStringDictionary()
        
        dict.addIfNotNil("Limit", value: query.limit)
        dict.addIfNotNilOrEmpty("UserId", value: query.userId)
        dict.add("Fields", value: query.fields?.map({$0.rawValue}))
        
        return getApiUrl("\(type!)/\(query.id!)/Similar", queryString: dict)
    }

    internal final func getInstantMixUrl(query: SimilarItemsQuery, type: String?) -> String {
        let dict = QueryStringDictionary()
        
        dict.addIfNotNil("Limit", value: query.limit)
        dict.addIfNotNilOrEmpty("UserId", value: query.userId)
        dict.add("Fields", value: query.fields?.map({$0.rawValue}))
        
        return getApiUrl("\(type!)/\(query.id!)/InstantMix", queryString: dict)
    }

    internal final func getItemByNameListUrl(query: ItemsByNameQuery, type: String?) -> String {
        let dict = QueryStringDictionary()
        
        dict.addIfNotNilOrEmpty("ParentId", value: query.parentId)
        dict.addIfNotNil("UserId", value: query.userId);
        dict.addIfNotNil("StartIndex", value: query.startIndex)
        dict.addIfNotNil("Limit", value: query.limit)
        dict.add("SortBy", value: query.sortBy)
        dict.addIfNotNil("sortOrder", value: query.sortOrder?.rawValue)
        dict.add("Fields", value: query.fields?.map({$0.rawValue}))
        dict.addIfNotNil("IsPlayed", value: query.isPlayed)
        dict.add("Filters", value: query.filters?.map({$0.rawValue}))
        dict.add("ImageTypes", value: query.imageTypes?.map({$0.rawValue}))
        dict.addIfNotNil("recursive", value: query.recursive)
        dict.add("MediaTypes", value: query.mediaTypes)
        dict.add("ExcludeItemTypes", value: query.excludeItemTypes)
        dict.add("IncludeItemTypes", value: query.includeItemTypes)
        dict.addIfNotNilOrEmpty("NameStartsWithOrGreater", value: query.nameStartsWithOrGreater)
        dict.addIfNotNilOrEmpty("NameStartsWith", value: query.nameStartsWith)
        dict.addIfNotNilOrEmpty("NameLessThan", value: query.nameLessThan)
        dict.addIfNotNil("EnableImages", value: query.enableImages)
        dict.addIfNotNil("ImageTypeLimit", value: query.imageTypeLimit)
        dict.add("EnableImageTypes", value: query.enableImageTypes?.map({$0.rawValue}))

        return getApiUrl(type, queryString: dict)
    }

    private func getImageUrl(baseUrl: String, options: ImageOptions, queryParams: QueryStringDictionary) -> String {
        queryParams.addIfNotNil("Width", value: options.width)
        queryParams.addIfNotNil("Height", value: options.height)
        queryParams.addIfNotNil("MaxWidth", value: options.maxWidth)
        queryParams.addIfNotNil("MaxHeight", value: options.maxHeight)
        
        if let quality = options.quality ?? getImageQuality() {
            queryParams.addIfNotNil("Quality", value: quality)
        }
        
        queryParams.addIfNotNilOrEmpty("Tag", value: options.tag)
        queryParams.addIfNotNil("CropWhitespace", value: options.cropWhiteSpace)
        queryParams.addIfNotNil("EnableImageEnhancers", value: options.enableImageEnhancers)

        queryParams.addIfNotNil("Format", value: options.imageFormat?.rawValue)
        queryParams.addIfNotNil("AddPlayedIndicator", value: options.addPlayedIndicator)
      
        queryParams.addIfNotNil("UnPlayedCount", value: options.unplayedCount);
        queryParams.addIfNotNil("PercentPlayed", value: options.percentPlayed);
        queryParams.addIfNotNilOrEmpty("BackgroundColor", value: options.backgroundColor);

        return getApiUrl(baseUrl, queryString: queryParams);
    }

    public final func getImageUrl(item: BaseItemDto, var options: ImageOptions) -> String? {
        options.tag = getImageTag(item, options: options)
        
        return getImageUrl(item.id, options: options)
    }

    public final func getImageUrl(itemId: String?, options: ImageOptions) -> String? {
        if let id = itemId {
            let url = "Items/\(id)/Images/\(options.imageType)";
            
            return getImageUrl(url, options: options, queryParams: QueryStringDictionary())
        }
        
        return nil
    }
    
    public final func getUserImageUrl(user: UserDto, var options: ImageOptions) -> String? {
        options.tag = user.primaryImageTag
        
        return getUserImageUrl(user.id, options: options)
    }
    
    public final func getUserImageUrl(userId: String?, options: ImageOptions) -> String? {
        if let id = userId {
            let url = "Users/\(id)/Images/\(options.imageType)";
            
            return getImageUrl(url, options: options, queryParams: QueryStringDictionary())
        }
        
        return nil
    }

    public final func getPersonImageUrl(item: BaseItemPerson, var options: ImageOptions) -> String? {
        options.tag = item.primaryImageTag
        
        return getImageUrl(item.id, options: options)
    }

    private func getImageTag(item: BaseItemDto, options: ImageOptions) -> String? {
        switch options.imageType {
        case .Backdrop:
            return item.backdropImageTags?[options.imageIndex ?? 0]
        case .Screenshot:
            return item.screenshotImageTags?[options.imageIndex ?? 0]
        case .Chapter:
            return item.chapters?[options.imageIndex ?? 0].imageTag
        default:
            return item.imageTags?[options.imageType]
        }
    }

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
    internal final func serializeToJson(obj: AnyObject) -> String {
        return getJsonSerializer()!.serializeToString(obj)
    }
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