//
//  ApiClient.swift
//  Emby.ApiClient
//

import Foundation

public class ApiClient: BaseApiClient {
    private let apiEventListener: ApiEventListener?
    private let httpClient: IAsyncHttpClient
    private var networkConnection: INetworkConnection?
    //private var apiWebSocket: ApiWebSocket?
    private var serverInfo: ServerInfo?
    private var connectionMode = ConnectionMode.Local

    
//    private Observable authenticatedObservable = new AutomaticObservable();
//    public Observable getAuthenticatedObservable() {
//        return authenticatedObservable;
//    }
//    
    
    init(httpClient: IAsyncHttpClient, jsonSerializer: IJsonSerializer, logger: ILogger, serverAddress: String, accessToken: String, apiEventListener: ApiEventListener) {
        self.httpClient = httpClient
        self.apiEventListener = apiEventListener
        
        super.init(logger: logger, jsonSerializer: jsonSerializer, serverAddress: serverAddress, accessToken: accessToken)
        
        resetHttpHeaders()
    }

    init(httpClient: IAsyncHttpClient, jsonSerializer: IJsonSerializer, logger: ILogger, serverAddress: String, appName: String, applicationVersion: String, device: DeviceProtocol, apiEventListener: ApiEventListener) {
        self.httpClient = httpClient
        self.apiEventListener = apiEventListener
        
        super.init(logger: logger, jsonSerializer: jsonSerializer, serverAddress: serverAddress, clientName: appName, device: device, applicationVersion: applicationVersion)
        
        resetHttpHeaders()
    }
    
    init(httpClient: IAsyncHttpClient, jsonSerializer: IJsonSerializer, logger: ILogger, serverAddress: String, appName: String, applicationVersion: String, device: DeviceProtocol) {
        self.httpClient = httpClient
        self.apiEventListener = nil
        
        super.init(logger: logger, jsonSerializer: jsonSerializer, serverAddress: serverAddress, clientName: appName, device: device, applicationVersion: applicationVersion)
        
        resetHttpHeaders()
    }

    
    // MARK: - Request Creation and Sending
    
    private func sendRequest<T: JSONSerializable>(request: HttpRequest, success: @escaping (T) -> Void, failure: @escaping (EmbyError) -> Void) {
        
        var request = request
        request.addHeaders(newHeaders: httpHeaders)
        
        httpClient.sendRequest(request: request, success: success, failure: failure)
    }
    
    private func sendCollectionRequest<Value: JSONSerializable>( request: HttpRequest, success: @escaping ([Value]) -> Void, failure: @escaping (EmbyError) -> Void) {
        
        var request = request
        request.addHeaders(newHeaders: httpHeaders)
        print("Request: \(request)")
        httpClient.sendCollectionRequest(request: request, success: success, failure: failure)
    }
    
    
    // MARK: - Public API Methods
    
    /**
     
     Authenticates a user and returns the result
     
     - Parameter username: The username
     - Parameter password: The password
     - Parameter success: Success callback with an AuthenticationResult
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func authenticateUserAsync(username: String, password: String, success: @escaping (AuthenticationResult) -> Void, failure: @escaping (EmbyError) -> Void) {
        
        precondition(!username.isEmpty, "Illegal Argument: username")
        
        let dict = QueryStringDictionary()
        dict.Add("Username", value: username)
        dict.Add("Pw", value: password)
        dict.Add("Password", value: password.sha1())
        dict.Add("PasswordMd5", value: password.md5())
        
        let urlString = getApiUrl(handler: "Users/AuthenticateByName")
        let request = HttpRequest(url: urlString, method: .post, postData: dict)
        sendRequest(request: request, success: success, failure: failure)
    }
    
    
    /**
     
     Gets a list of public users
     
     - Parameter success: Success callback with an array of UserDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getPublicUsersAsync(success: @escaping ([UserDto]) -> Void, failure:  @escaping (EmbyError) -> Void) {
        let urlString = getApiUrl(handler: "Users/Public")
        
        let request = HttpRequest(url: urlString, method: .get)
        sendCollectionRequest(request: request, success: success, failure: failure)
    }

    /**
     
     Retrieves an item for a user
     
     - Parameter id: The Item Id
     - Parameter userId: The User Id
     - Parameter success: Success callback with an BaseItemDto
     - Parameter failure: Failure callback with an EmbyError

     */
    public func getItemAsync(id: String, userId: String, success: @escaping (BaseItemDto) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!id.isEmpty, "Illegal Argument: id")
        precondition(!userId.isEmpty, "Illegal Argument: userId")
        
        let url = getApiUrl(handler: "/Users/\(userId)/Items/\(id)")
        
        getItemFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Retrieves an array of items for a user
     
     - Parameter query: The ItemQuery
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getItemsAsync(query: ItemQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        //print(query)
        let url = getItemListUrl(query: query)
        print("URL: \(url)")
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Retrieves an array of item counts for a user
     
     - Parameter query: The ItemCountsQuery
     - Parameter success: Success callback with an ItemCounts
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getItemCountsAsync(query: ItemCountsQuery, success: @escaping (ItemCounts) -> Void, failure: @escaping (EmbyError) -> Void) {
        let dict = QueryStringDictionary()
        
        dict.addIfNotNilOrEmpty("UserId", value: query.userId)
        dict.addIfNotNil("IsFavorite", value: query.favorite)
        
        let urlString = getApiUrl(handler: "Items/Counts", queryString: dict)
        let urlWithFormat = addDataFormat(url: urlString)
        let request = HttpRequest(url: urlWithFormat, method: .get, postData: dict)
        
        sendRequest(request: request, success: success, failure: failure)
    }
    
    /**

     Retrieves a list of users
     
     - Parameter query: The user query
     - Parameter success: Success callback with an array of UserDto
     - Parameter failure: Failure callback with an EmbyError

     */
    public func getUsersAsync(query: UserQuery, success: @escaping ([UserDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let dict = QueryStringDictionary()
        
        dict.addIfNotNil("IsDisabled", value: query.disabled)
        dict.addIfNotNil("IsHidden", value: query.hidden)
    
        let urlString = getApiUrl(handler: "Users", queryString: dict)
        let request = HttpRequest(url: urlString, method: .get, postData: dict)
        
        sendCollectionRequest(request: request, success: success, failure: failure)
    }
    
    /**

     Retrieves root items for user

     - Parameter userId: The User Id
     - Parameter success: Success callback with an BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getRootFolderAsync(userId: String, success: @escaping (BaseItemDto) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!userId.isEmpty, "Illegal Argument: userId")
        
        let url = getApiUrl(handler: "/Users/\(userId)/Items/Root")
        
        getItemFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Retrieves the intros
     
     - Parameter userId: The User Id
     - Parameter success: Success callback with an BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getIntrosAsync(itemId: String, userId: String, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!itemId.isEmpty, "Illegal Argument: itemId")
        precondition(!userId.isEmpty, "Illegal Argument: userId")
        
        let url = getApiUrl(handler: "/Users/\(userId)/Items/\(itemId)/Intros")
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    /**

     Retrieves client sessions
     
     - Parameter query: The Session Query
     - Parameter success: Success callback with an SessionInfoDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getClientSessionsAsync(query: SessionQuery, success: @escaping ([SessionInfoDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let dict = QueryStringDictionary()
        
        dict.Add("ControllableByUserId", value: query.controllableByUserId)
        
        let urlString = getApiUrl(handler: "Sessions", queryString: dict)
        let request = HttpRequest(url: urlString, method: .get)
        
        sendCollectionRequest(request: request, success: success, failure: failure)
    }
    
    /**
     
     Retrieves registartion information
     
     - Parameter query: The feature
     - Parameter success: Success callback with an RegistrationInfo
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getRegistrationInfo(feature: String, success: @escaping (RegistrationInfo) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!feature.isEmpty, "Illegal Argument: feature")
        
        let url = getApiUrl(handler: "/Registrations/\(feature)")
        let urlWithFormat = addDataFormat(url: url)
        
        getItemFromUrl(url: urlWithFormat, success: success, failure: failure)
    }
    
    public func enableAutomaticNetworking(info: ServerInfo, initialMode: ConnectionMode, networkConnection: INetworkConnection) {
        self.networkConnection = networkConnection
        self.connectionMode = initialMode
        self.serverInfo = info
        
        self.setServerAddress(value: info.getAddress(mode: initialMode)!)
        
    }
    
//    
//    public void OpenWebSocket(){
//        
//        if (apiWebSocket == null){
//            
//            Logger.Debug("Creating ApiWebSocket");
//            apiWebSocket = new ApiWebSocket(getJsonSerializer(), Logger, apiEventListener, this);
//        }
//        
//        apiWebSocket.EnsureWebSocket();
//    }
//    
//    void OnRemoteLoggedOut(HttpException httpError) {
//        
//        RemoteLogoutReason reason = RemoteLogoutReason.GeneralAccesError;
//        
//        if (httpError.getHeaders() != null  ){
//            
//            String errorCode = httpError.getHeaders().get("X-Application-Error-Code");
//            
//            if (StringHelper.EqualsIgnoreCase(errorCode, "ParentalControl")) {
//                reason = RemoteLogoutReason.ParentalControlRestriction;
//            }
//        }
//        
//        apiEventListener.onRemoteLoggedOut(this, reason);
//    }
//    
//    private void SendRequest(HttpRequest request, final boolean fireGlobalEvents, final Response<String> response)
//    {
//        httpClient.Send(request, new ApiClientRequestListener(this, fireGlobalEvents, response));
//    }
//    
//    private void Send(String url, String method, final Response<String> response)
//    {
//        HttpRequest request = new HttpRequest();
//        request.setUrl(url);
//        request.setMethod(method);
//        request.setRequestHeaders(this.HttpHeaders);
//        SendRequest(request, true, response);
//    }
//    
//    private void Send(String url, String method, String requestContent, String requestContentType, final Response<String> response)
//    {
//        HttpRequest request = new HttpRequest();
//        request.setUrl(url);
//        request.setMethod(method);
//        request.setRequestHeaders(this.HttpHeaders);
//        request.setRequestContent(requestContent);
//        request.setRequestContentType(requestContentType);
//        SendRequest(request, true, response);
//    }
//    
//    private void Send(String url,
//    String method,
//    QueryStringDictionary postData,
//    boolean fireGlobalEvents,
//    final Response<String> response)
//    {
//        HttpRequest request = new HttpRequest();
//        request.setUrl(url);
//        request.setMethod(method);
//        request.setRequestHeaders(this.HttpHeaders);
//        request.setPostData(postData);
//        SendRequest(request, fireGlobalEvents, response);
//    }
//    
//    public void getResponseStream(String address, Response<InputStream> response){
//        
//        getResponseStreamInternal(address, response);
//    }
//    
//    protected void getResponseStreamInternal(String address, Response<InputStream> response){
//        
//        Logger.Debug("Getting response stream from " + address);
//        
//        HttpURLConnection conn = null;
//        
//        try
//            {
//                URL url = new URL(address);
//                
//                conn = (HttpURLConnection) url.openConnection();
//                conn.setDoInput(true); // Allow Inputs
//                conn.setUseCaches(false); // Don't use a Cached Copy
//                conn.setRequestMethod("GET");
//                conn.setRequestProperty("Connection", "Keep-Alive");
//                
//                for (String key: this.HttpHeaders.keySet()){
//                    conn.setRequestProperty(key, this.HttpHeaders.get(key));
//                }
//                
//                InputStream inputStream = conn.getInputStream();
//                
//                response.onResponse(inputStream);
//                
//        }
//        catch (Exception ex)
//        {
//            response.onError(ex);
//        }
//    }
//
//
//    

//
//    

    
    private func getItemFromUrl<T: JSONSerializable>(url: String, success: @escaping (T) -> Void, failure: @escaping (EmbyError) -> Void) {
        let urlWithFormat = addDataFormat(url: url)
        
        let request = HttpRequest(url: urlWithFormat, method: .get)
        
        sendRequest(request: request, success: success, failure: failure)
    }
    
    private func getItemsFromUrl<Value: JSONSerializable>(url: String, success: @escaping ([Value]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let urlWithFormat = addDataFormat(url: url)
        
        let request = HttpRequest(url: urlWithFormat, method: .get)
        
        sendCollectionRequest(request: request, success: success, failure: failure)
    }
    
    /**

    Gets the next up async

    - Parameter query: The query
    - Parameter success: Success callback with an array of BaseItemDto
    - Parameter failure: Failure callback with an EmbyError

     */
    public func getNextUpEpisodesAsync(query: NextUpQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let url = getNextUpUrl(query: query)
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    public func getUpcomingEpisodesAsync(query: UpcomingEpisodesQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let dict = QueryStringDictionary()
        
        dict.add("Fields", value: query.fields?.map({$0.rawValue}))
        dict.addIfNotNil("Limit", value: query.limit)
        dict.addIfNotNil("StartIndex", value: query.startIndex)
        dict.addIfNotNil("UserId", value: query.userId)
        dict.addIfNotNil("EnableImages", value: query.enableImages)
        dict.addIfNotNil("ImageTypeLimit", value: query.imageTypeLimit)
        dict.add("EnableImageTypes", value: query.enableImageTypes?.map({$0.rawValue}))
        
        let url = getApiUrl(handler: "Shows/Upcoming", queryString: dict)
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Gets the similar movies async
     
     - Parameter query: The query
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getSimilarItems(query: SimilarItemsQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let url = getSimilarItemListUrl(query: query, type: "Items")
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    public func getEpisodesAsync(query: EpisodeQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let dict = QueryStringDictionary()
        
        dict.addIfNotNil("Season", value: query.seasonNumber)
        dict.addIfNotNilOrEmpty("UserId", value: query.userId)
        dict.addIfNotNilOrEmpty("SeasonId", value: query.seasonId)
        dict.add("Fields", value: query.fields?.map({$0.rawValue}))
        dict.addIfNotNilOrEmpty("AdjacentTo", value: query.adjacentTo)
        dict.addIfNotNil("IsMissing", value: query.isMissing)
        dict.addIfNotNil("IsVirtualUnaired", value: query.isVirtualUnaired)
        
        let url = getApiUrl(handler: "Shows/\(String(describing: query.seriesId))/Episodes", queryString: dict)
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    public func getSeasonsAsync(query: SeasonQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let dict = QueryStringDictionary()
        
        dict.addIfNotNilOrEmpty("UserId", value: query.userId)
        dict.add("Fields", value: query.fields?.map({$0.rawValue}))
        dict.addIfNotNil("IsMissing", value: query.isMissing)
        dict.addIfNotNil("IsVirtualUnaired", value: query.isVirtualUnaired)
        dict.addIfNotNil("IsSpecialSeason", value: query.isSpecialSeason)
        
        let url = getApiUrl(handler: "Shows/\(String(describing: query.seriesId))/Seasons", queryString: dict)
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }

    /**
     
     Gets the instant mix from album async
     
     - Parameter query: The query
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getInstantMixFromItem(query: SimilarItemsQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let url = getInstantMixUrl(query: query, type: "Items");
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Gets the genres async
     
     - Parameter query: The query
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getGenresAsync(query: ItemsByNameQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let url = getItemByNameListUrl(query: query, type: "Genres")
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Gets the studios async
     
     - Parameter query: The query
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getStudiosAsync(query: ItemsByNameQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let url = getItemByNameListUrl(query: query, type: "Studios")
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Gets the artists async
     
     - Parameter query: The query
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getArtistsAsync(query: ItemsByNameQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let url = getItemByNameListUrl(query: query, type: "Artists")
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Gets the album artists async
     
     - Parameter query: The query
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getAlbumArtistsAsync(query: ItemsByNameQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        let url = getItemByNameListUrl(query: query, type: "Artists/AlbumArtists")
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
    
    Gets the people async
    
    - Parameter query: The query
    - Parameter success: Success callback with an array of BaseItemDto
    - Parameter failure: Failure callback with an EmbyError
    
     */
    public func getPeopleAsync(query: PersonsQuery, success: @escaping ([BaseItemDto]) -> Void, failure: @escaping (EmbyError) -> Void) {
        var url = getItemByNameListUrl(query: query, type: "Persons")
        
        if let personTypes = query.personTypes {
            url += "&PersonTypes=\(personTypes.joined(separator: ","))"
        }
        
        getItemsFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
    
    Gets a studio async
    
    - Parameter name: The studio name
    - Parameter userId: The User ID
    - Parameter success: Success callback with an array of BaseItemDto
    - Parameter failure: Failure callback with an EmbyError
    
     */
    public func getStudioAsync(name: String, userId: String, success: @escaping (BaseItemDto) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!name.isEmpty, "Illegal Argument: name")
        precondition(!userId.isEmpty, "Illegal Argument: userId")
        
        let dict = QueryStringDictionary()
        
        dict.Add("userId", value: userId)
        
        let url = getApiUrl(handler: "Studios/\(getSlugName(name: name))", queryString: dict)
        
        getItemFromUrl(url: url, success: success, failure: failure)
    }

    /**
     
     Gets a genre async
     
     - Parameter name: The genre name
     - Parameter userId: The User ID
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getGenreAsync(name: String, userId: String, success: @escaping (BaseItemDto) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!name.isEmpty, "Illegal Argument: name")
        precondition(!userId.isEmpty, "Illegal Argument: userId")
        
        let dict = QueryStringDictionary()
        
        dict.Add("userId", value: userId)
        
        let url = getApiUrl(handler: "Genres/\(getSlugName(name: name))", queryString: dict)
        
        getItemFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Gets a music genre async
     
     - Parameter name: The music genre name
     - Parameter userId: The User ID
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getMusicGenreAsync(name: String, userId: String, success: @escaping (BaseItemDto) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!name.isEmpty, "Illegal Argument: name")
        precondition(!userId.isEmpty, "Illegal Argument: userId")
        
        let dict = QueryStringDictionary()
        
        dict.Add("userId", value: userId)
        
        let url = getApiUrl(handler: "MusicGenres/\(getSlugName(name: name))", queryString: dict)
        
        getItemFromUrl(url: url, success: success, failure: failure)
    }

    /**
     
     Gets a music genre async
     
     - Parameter name: The music genre name
     - Parameter userId: The User ID
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getMusicGenreAsync(name: String, success: @escaping (BaseItemDto) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!name.isEmpty, "Illegal Argument: name")
        
        let url = getApiUrl(handler: "MusicGenres/\(getSlugName(name: name))")
        
        getItemFromUrl(url: url, success: success, failure: failure)
    }
    
    /**
     
     Gets a game genre async
     
     - Parameter name: The game genre name
     - Parameter userId: The User ID
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getGameGenreAsync(name: String, userId: String, success: @escaping (BaseItemDto) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!name.isEmpty, "Illegal Argument: name")
        precondition(!userId.isEmpty, "Illegal Argument: userId")
        
        let dict = QueryStringDictionary()
        
        dict.Add("userId", value: userId)
        
        let url = getApiUrl(handler: "GameGenres/\(getSlugName(name: name))", queryString: dict)
        
        getItemFromUrl(url: url, success: success, failure: failure)
    }

    /**
     
     Gets an artist async
     
     - Parameter name: The artist name
     - Parameter userId: The User ID
     - Parameter success: Success callback with an array of BaseItemDto
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getArtistAsync(name: String, userId: String, success: @escaping (BaseItemDto) -> Void, failure: @escaping (EmbyError) -> Void) {
        precondition(!name.isEmpty, "Illegal Argument: name")
        precondition(!userId.isEmpty, "Illegal Argument: userId")
        
        let dict = QueryStringDictionary()
        
        dict.Add("userId", value: userId)
        
        let url = getApiUrl(handler: "Artists/\(getSlugName(name: name))", queryString: dict)
        
        getItemFromUrl(url: url, success: success, failure: failure)
    }

//    
//    /// <summary>
//    /// Restarts the server async.
//    /// </summary>
//    /// <returns>Task.</returns>
//    public void RestartServerAsync(final EmptyResponse response)
//    {
//        String url = GetApiUrl("System/Restart");
//        
//        PostAsync(url, response);
//    }
//
    /**
    
    Gets the system status async
    
    - Parameter success: Success callback with an SystemInfo
    - Parameter failure: Failure callback with an EmbyError
    
     */
    public func getSystemInfoAsync(success: @escaping (SystemInfo) -> Void, failure: @escaping (EmbyError) -> Void) {
        var url = getApiUrl(handler: "System/Info")
        
        url = addDataFormat(url: url)
        
        let request = HttpRequest(url: url, method: .get)
        sendRequest(request: request, success: success, failure: failure)
    }
    
    /**
     
     Gets public system information async
     
     - Parameter success: Success callback with an PublicSystemInfo
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getPublicSystemInfoAsync(success: @escaping (PublicSystemInfo) -> Void, failure: @escaping (EmbyError) -> Void) {
        var url = getApiUrl(handler: "System/Info/Public")
        
        url = addDataFormat(url: url)
        
        let request = HttpRequest(url: url, method: .get)
        sendRequest(request: request, success: success, failure: failure)
    }
    
    /**
     
     Gets a list of plugins installed on the server async
     
     - Parameter success: Success callback with an SystemInfo
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getInstalledPluginsAsync(success: @escaping ([PluginInfo]) -> Void, failure: @escaping (EmbyError) -> Void) {
        var url = getApiUrl(handler: "System/Info/Public")
        
        url = addDataFormat(url: url)
        
        let request = HttpRequest(url: url, method: .get)
        sendCollectionRequest(request: request, success: success, failure: failure)
    }
    
    /**
     
     Gets the current server configuration async
     
     - Parameter success: Success callback with an ServerConfigureation
     - Parameter failure: Failure callback with an EmbyError
     
     */
    public func getServerConfigurationAsync(success: @escaping (ServerConfiguration) -> Void, failure: @escaping (EmbyError) -> Void) {
        var url = getApiUrl(handler: "System/Configuration")
        
        url = addDataFormat(url: url)
        
        let request = HttpRequest(url: url, method: .get)
        sendRequest(request: request, success: success, failure: failure)
    }
//    
//    /// <summary>
//    /// Gets the scheduled tasks.
//    /// </summary>
//    /// <returns>Task{TaskInfo[]}.</returns>
//    public void GetScheduledTasksAsync(final Response<TaskInfo[]> response)
//    {
//        String url = GetApiUrl("ScheduledTasks");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<TaskInfo[]>(response, jsonSerializer, new TaskInfo[]{}.getClass()));
//    }
//    
//    /// <summary>
//    /// Gets the scheduled task async.
//    /// </summary>
//    /// <param name="id">The id.</param>
//    /// <returns>Task{TaskInfo}.</returns>
//    /// <exception cref="System.IllegalArgumentException">id</exception>
//    public void GetScheduledTaskAsync(String id, final Response<TaskInfo> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        String url = GetApiUrl("ScheduledTasks/" + id);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<TaskInfo>(response, jsonSerializer, TaskInfo.class));
//    }
//    
//    /// <summary>
//    /// Gets a user by id
//    /// </summary>
//    /// <param name="id">The id.</param>
//    /// <returns>Task{UserDto}.</returns>
//    /// <exception cref="System.IllegalArgumentException">id</exception>
//    public void GetUserAsync(String id, final Response<UserDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        String url = GetApiUrl("Users/" + id);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<UserDto>(response, jsonSerializer, UserDto.class));
//    }
//    
//    /// <summary>
//    /// Gets the parental ratings async.
//    /// </summary>
//    /// <returns>Task{List{ParentalRating}}.</returns>
//    public void GetParentalRatingsAsync(final Response<ParentalRating[]> response)
//    {
//        String url = GetApiUrl("Localization/ParentalRatings");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ParentalRating[]>(response, jsonSerializer, new ParentalRating[]{}.getClass()));
//    }
//    
//    /// <summary>
//    /// Gets local trailers for an item
//    /// </summary>
//    /// <param name="userId">The user id.</param>
//    /// <param name="itemId">The item id.</param>
//    /// <returns>Task{ItemsResult}.</returns>
//    /// <exception cref="System.IllegalArgumentException">query</exception>
//    public void GetLocalTrailersAsync(String userId, String itemId, final Response<BaseItemDto[]> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(userId))
//        {
//            throw new IllegalArgumentException("userId");
//        }
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId))
//        {
//            throw new IllegalArgumentException("itemId");
//        }
//        
//        String url = GetApiUrl("Users/" + userId + "/Items/" + itemId + "/LocalTrailers");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<BaseItemDto[]>(response, jsonSerializer, new BaseItemDto[]{}.getClass()));
//    }
//    
//    /// <summary>
//    /// Gets special features for an item
//    /// </summary>
//    /// <param name="userId">The user id.</param>
//    /// <param name="itemId">The item id.</param>
//    /// <returns>Task{BaseItemDto[]}.</returns>
//    /// <exception cref="System.IllegalArgumentException">userId</exception>
//    public void GetSpecialFeaturesAsync(String userId, String itemId, final Response<BaseItemDto[]> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(userId))
//        {
//            throw new IllegalArgumentException("userId");
//        }
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId))
//        {
//            throw new IllegalArgumentException("itemId");
//        }
//        
//        String url = GetApiUrl("Users/" + userId + "/Items/" + itemId + "/SpecialFeatures");
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<BaseItemDto[]>(response, jsonSerializer, new BaseItemDto[]{}.getClass()));
//    }
//    
//    /// <summary>
//    /// Gets the cultures async.
//    /// </summary>
//    /// <returns>Task{CultureDto[]}.</returns>
//    public void GetCulturesAsync(final Response<CultureDto[]> response)
//    {
//        String url = GetApiUrl("Localization/Cultures");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<CultureDto[]>(response, jsonSerializer, new CultureDto[]{}.getClass()));
//    }
//    
//    /// <summary>
//    /// Gets the countries async.
//    /// </summary>
//    /// <returns>Task{CountryInfo[]}.</returns>
//    public void GetCountriesAsync(final Response<CountryInfo[]> response)
//    {
//        String url = GetApiUrl("Localization/Countries");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<CountryInfo[]>(response, jsonSerializer, new CountryInfo[]{}.getClass()));
//    }
//    
//    /// <summary>
//    /// Gets the game system summaries async.
//    /// </summary>
//    /// <returns>Task{List{GameSystemSummary}}.</returns>
//    public void GetGameSystemSummariesAsync(final Response<GameSystemSummary[]> response)
//    {
//        String url = GetApiUrl("Games/SystemSummaries");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<GameSystemSummary[]>(response, jsonSerializer, new GameSystemSummary[]{}.getClass()));
//    }
//    
//    public void MarkPlayedAsync(String itemId, String userId, Date datePlayed, final Response<UserItemDataDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId)) {
//            throw new IllegalArgumentException("itemId");
//        }
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(userId)) {
//            throw new IllegalArgumentException("userId");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        if (datePlayed != null)
//        {
//            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
//            dict.Add("DatePlayed", formatter.format(datePlayed));
//        }
//        
//        String url = GetApiUrl("Users/" + userId + "/PlayedItems/" + itemId, dict);
//        url = AddDataFormat(url);
//        
//        Send(url, "POST", dict, true, new SerializedResponse<UserItemDataDto>(response, jsonSerializer, UserItemDataDto.class));
//    }
//    
//    /// <summary>
//    /// Marks the unplayed async.
//    /// </summary>
//    /// <param name="itemId">The item id.</param>
//    /// <param name="userId">The user id.</param>
//    /// <returns>Task{UserItemDataDto}.</returns>
//    /// <exception cref="System.IllegalArgumentException">
//    /// itemId
//    /// or
//    /// userId
//    /// </exception>
//    public void MarkUnplayedAsync(String itemId, String userId, final Response<UserItemDataDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId)) {
//            throw new IllegalArgumentException("itemId");
//        }
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(userId)) {
//            throw new IllegalArgumentException("userId");
//        }
//        
//        String url = GetApiUrl("Users/" + userId + "/PlayedItems/" + itemId);
//        url = AddDataFormat(url);
//        
//        Send(url, "DELETE", new SerializedResponse<UserItemDataDto>(response, jsonSerializer, new UserItemDataDto().getClass()));
//    }
//    
//    /// <summary>
//    /// Updates the favorite status async.
//    /// </summary>
//    /// <param name="itemId">The item id.</param>
//    /// <param name="userId">The user id.</param>
//    /// <param name="isFavorite">if set to <c>true</c> [is favorite].</param>
//    /// <returns>Task.</returns>
//    /// <exception cref="System.IllegalArgumentException">itemId</exception>
//    public void UpdateFavoriteStatusAsync(String itemId, String userId, Boolean isFavorite, final Response<UserItemDataDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId)) {
//            throw new IllegalArgumentException("itemId");
//        }
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(userId)) {
//            throw new IllegalArgumentException("userId");
//        }
//        
//        String url = GetApiUrl("Users/" + userId + "/FavoriteItems/" + itemId);
//        url = AddDataFormat(url);
//        
//        Send(url, isFavorite ? "POST" : "DELETE", new SerializedResponse<UserItemDataDto>(response, jsonSerializer, new UserItemDataDto().getClass()));
//    }
//    
//    /// <summary>
//    /// Reports to the server that the user has begun playing an item
//    /// </summary>
//    /// <param name="info">The information.</param>
//    /// <returns>Task{UserItemDataDto}.</returns>
//    /// <exception cref="System.IllegalArgumentException">itemId</exception>
//    public void ReportPlaybackStartAsync(PlaybackStartInfo info, final EmptyResponse response)
//    {
//        if (info == null)
//        {
//            throw new IllegalArgumentException("info");
//        }
//        
//        Logger.Debug("ReportPlaybackStart: Item %s", info.getItem());
//        
//        String url = GetApiUrl("Sessions/Playing");
//        
//        PostAsync(url, info, response);
//    }
//    
//    /// <summary>
//    /// Reports playback progress to the server
//    /// </summary>
//    /// <param name="info">The information.</param>
//    /// <returns>Task{UserItemDataDto}.</returns>
//    /// <exception cref="System.IllegalArgumentException">itemId</exception>
//    public void ReportPlaybackProgressAsync(PlaybackProgressInfo info, final EmptyResponse response)
//    {
//        if (info == null)
//        {
//            throw new IllegalArgumentException("info");
//        }
//        
//        if (apiWebSocket != null && apiWebSocket.IsWebSocketOpen()){
//            //apiWebSocket.SendWebSocketMessage("ReportPlaybackProgress", info, response);
//            //return;
//        }
//        
//        String url = GetApiUrl("Sessions/Playing/Progress");
//        PostAsync(url, info, response);
//    }
//    
//    /// <summary>
//    /// Reports to the server that the user has stopped playing an item
//    /// </summary>
//    /// <param name="info">The information.</param>
//    /// <returns>Task{UserItemDataDto}.</returns>
//    /// <exception cref="System.IllegalArgumentException">itemId</exception>
//    public void ReportPlaybackStoppedAsync(PlaybackStopInfo info, final EmptyResponse response)
//    {
//        if (info == null)
//        {
//            throw new IllegalArgumentException("info");
//        }
//        
//        String url = GetApiUrl("Sessions/Playing/Stopped");
//        
//        PostAsync(url, info, response);
//    }
//    
//    /// <summary>
//    /// Instructs another client to browse to a library item.
//    /// </summary>
//    /// <param name="sessionId">The session id.</param>
//    /// <param name="itemId">The id of the item to browse to.</param>
//    /// <param name="itemName">The name of the item to browse to.</param>
//    /// <param name="itemType">The type of the item to browse to.</param>
//    /// <returns>Task.</returns>
//    /// <exception cref="System.IllegalArgumentException">sessionId
//    /// or
//    /// itemId
//    /// or
//    /// itemName
//    /// or
//    /// itemType</exception>
//    public void SendBrowseCommandAsync(String sessionId, String itemId, String itemName, String itemType, final EmptyResponse response)
//    {
//        GeneralCommand cmd = new GeneralCommand();
//        
//        cmd.setName("DisplayContent");
//        
//        cmd.getArguments().put("ItemType", itemType);
//        cmd.getArguments().put("ItemId", itemId);
//        cmd.getArguments().put("ItemName", itemName);
//        
//        SendCommandAsync(sessionId, cmd, response);
//    }
//    
//    /// <summary>
//    /// Sends the play command async.
//    /// </summary>
//    /// <param name="sessionId">The session id.</param>
//    /// <param name="request">The request.</param>
//    /// <returns>Task.</returns>
//    /// <exception cref="System.IllegalArgumentException">sessionId
//    /// or
//    /// request</exception>
//    public void SendPlayCommandAsync(String sessionId, PlayRequest request, final EmptyResponse response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(sessionId))
//        {
//            throw new IllegalArgumentException("sessionId");
//        }
//        if (request == null)
//        {
//            throw new IllegalArgumentException("request");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        dict.Add("ItemIds", request.getItemIds());
//        dict.AddIfNotNull("StartPositionTicks", request.getStartPositionTicks());
//        dict.Add("PlayCommand", request.getPlayCommand());
//        
//        String url = GetApiUrl("Sessions/" + sessionId + "/Playing", dict);
//        
//        PostAsync(url, response);
//    }
//    
//    public void SendMessageCommandAsync(String sessionId, MessageCommand command, final EmptyResponse response)
//    {
//        GeneralCommand cmd = new GeneralCommand();
//        
//        cmd.setName("DisplayMessage");
//        
//        cmd.getArguments().put("Header", command.getHeader());
//        cmd.getArguments().put("Text", command.getText());
//        
//        if (command.getTimeoutMs() != null)
//        {
//            cmd.getArguments().put("Timeout", StringHelper.ToStringCultureInvariant(command.getTimeoutMs()));
//        }
//        
//        SendCommandAsync(sessionId, cmd, response);
//    }
//    
//    /// <summary>
//    /// Sends the system command async.
//    /// </summary>
//    /// <param name="sessionId">The session id.</param>
//    /// <param name="command">The command.</param>
//    /// <returns>Task.</returns>
//    /// <exception cref="System.IllegalArgumentException">sessionId</exception>
//    public void SendCommandAsync(String sessionId, GeneralCommand command, final EmptyResponse response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(sessionId))
//        {
//            throw new IllegalArgumentException("sessionId");
//        }
//        
//        String url = GetApiUrl("Sessions/" + sessionId + "/Command");
//        
//        PostAsync(url, command, response);
//    }
//    
//    private void DeleteAsync(String url, final EmptyResponse response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(url))
//        {
//            throw new IllegalArgumentException("url");
//        }
//        
//        Response<String> stringResponse = new Response<String>(response);
//        
//        Send(url, "DELETE", stringResponse);
//    }
//    
//    private void PostAsync(String url, final EmptyResponse response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(url))
//        {
//            throw new IllegalArgumentException("url");
//        }
//        
//        PostAsync(url, new QueryStringDictionary(), response);
//    }
//    
//    private void PostAsync(String url,
//    QueryStringDictionary postBody,
//    boolean fireGlobalEvents,
//    final Response<String> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(url))
//        {
//            throw new IllegalArgumentException("url");
//        }
//        
//        Send(url, "POST", postBody, fireGlobalEvents, response);
//    }
//    
//    private void PostAsync(String url, Object obj, final EmptyResponse response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(url))
//        {
//            throw new IllegalArgumentException("url");
//        }
//        
//        Response<String> jsonResponse = new Response<String>(response);
//        
//        String json = getJsonSerializer().SerializeToString(obj);
//        
//        Send(url, "POST", json, "application/json", jsonResponse);
//    }
//    
//    /// <summary>
//    /// Sends the playstate command async.
//    /// </summary>
//    /// <param name="sessionId">The session id.</param>
//    /// <param name="request">The request.</param>
//    /// <returns>Task.</returns>
//    public void SendPlaystateCommandAsync(String sessionId, PlaystateRequest request, final EmptyResponse response)
//    {
//        QueryStringDictionary dict = new QueryStringDictionary();
//        dict.AddIfNotNull("SeekPositionTicks", request.getSeekPositionTicks());
//        
//        String url = GetApiUrl("Sessions/" + sessionId + "/Playing/" + request.getCommand(), dict);
//        
//        PostAsync(url, response);
//    }
//    
//    /// <summary>
//    /// Clears a user's rating for an item
//    /// </summary>
//    /// <param name="itemId">The item id.</param>
//    /// <param name="userId">The user id.</param>
//    /// <returns>Task{UserItemDataDto}.</returns>
//    /// <exception cref="System.IllegalArgumentException">itemId</exception>
//    public void ClearUserItemRatingAsync(String itemId, String userId, final Response<UserItemDataDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId))
//        {
//            throw new IllegalArgumentException("itemId");
//        }
//        
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(userId))
//        {
//            throw new IllegalArgumentException("userId");
//        }
//        
//        String url = GetApiUrl("Users/" + userId + "/Items/" + itemId + "/Rating");
//        url = AddDataFormat(url);
//        Send(url, "DELETE", new SerializedResponse<UserItemDataDto>(response, jsonSerializer, new UserItemDataDto().getClass()));
//    }
//    
//    /// <summary>
//    /// Updates a user's rating for an item, based on likes or dislikes
//    /// </summary>
//    /// <param name="itemId">The item id.</param>
//    /// <param name="userId">The user id.</param>
//    /// <param name="likes">if set to <c>true</c> [likes].</param>
//    /// <returns>Task.</returns>
//    /// <exception cref="System.IllegalArgumentException">itemId</exception>
//    public void UpdateUserItemRatingAsync(String itemId, String userId, Boolean likes, final Response<UserItemDataDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId))
//        {
//            throw new IllegalArgumentException("itemId");
//        }
//        
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(userId))
//        {
//            throw new IllegalArgumentException("userId");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.Add("likes", likes);
//        
//        String url = GetApiUrl("Users/" + userId + "/Items/" + itemId + "/Rating", dict);
//        url = AddDataFormat(url);
//        Send(url, "POST", new SerializedResponse<UserItemDataDto>(response, jsonSerializer, new UserItemDataDto().getClass()));
//    }
//    
//    /// <summary>
//    /// Authenticates a user and returns the result
//    /// </summary>
//    /// <param name="username">The username.</param>
//    /// <param name="sha1Hash">The sha1 hash.</param>
//    /// <returns>Task.</returns>
//    /// <exception cref="System.IllegalArgumentException">userId</exception>
//    public void AuthenticateUserAsync(String username, String password, final Response<AuthenticationResult> response)
//    throws NoSuchAlgorithmException, UnsupportedEncodingException
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(username))
//        {
//            throw new IllegalArgumentException("username");
//        }
//        
//        String url = GetApiUrl("Users/AuthenticateByName");
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.Add("username", username);
//        dict.Add("password", Sha1.getHash(password));
//        dict.Add("passwordMd5", Md5.getHash(ConnectPassword.PerformPreHashFilter(password)));
//        
//        url = AddDataFormat(url);
//        Response<String> jsonResponse = new Response<String>(response){
//            
//            @Override
//            public void onResponse(String jsonResponse) {
//                
//                AuthenticationResult obj = DeserializeFromString(jsonResponse, AuthenticationResult.class);
//                
//                SetAuthenticationInfo(obj.getAccessToken(), obj.getUser().getId());
//                
//                getAuthenticatedObservable().notifyObservers(obj);
//                
//                response.onResponse(obj);
//            }
//        };
//        
//        PostAsync(url, dict, false, jsonResponse);
//    }
//    
//    /// <summary>
//    /// Updates the server configuration async.
//    /// </summary>
//    /// <param name="configuration">The configuration.</param>
//    /// <returns>Task.</returns>
//    /// <exception cref="System.IllegalArgumentException">configuration</exception>
//    public void UpdateServerConfigurationAsync(ServerConfiguration configuration, final EmptyResponse response)
//    {
//        if (configuration == null)
//        {
//            throw new IllegalArgumentException("configuration");
//        }
//        
//        String url = GetApiUrl("System/Configuration");
//        
//        PostAsync(url, configuration, response);
//    }
//    
//    /// <summary>
//    /// Updates the scheduled task triggers.
//    /// </summary>
//    /// <param name="id">The id.</param>
//    /// <param name="triggers">The triggers.</param>
//    /// <returns>Task{RequestResult}.</returns>
//    /// <exception cref="System.IllegalArgumentException">id</exception>
//    public void UpdateScheduledTaskTriggersAsync(String id, TaskTriggerInfo[] triggers, final EmptyResponse response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        if (triggers == null)
//        {
//            throw new IllegalArgumentException("triggers");
//        }
//        
//        String url = GetApiUrl("ScheduledTasks/" + id + "/Triggers");
//        
//        PostAsync(url, triggers, response);
//    }
//    
//    /// <summary>
//    /// Gets the display preferences.
//    /// </summary>
//    /// <param name="id">The id.</param>
//    /// <param name="userId">The user id.</param>
//    /// <param name="client">The client.</param>
//    /// <returns>Task{BaseItemDto}.</returns>
//    public void GetDisplayPreferencesAsync(String id, String userId, String client, final Response<DisplayPreferences> response)
//    {
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.Add("userId", userId);
//        dict.Add("client", client);
//        
//        String url = GetApiUrl("DisplayPreferences/" + id, dict);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<DisplayPreferences>(response, jsonSerializer, DisplayPreferences.class));
//    }
//    
//    /// <summary>
//    /// Updates display preferences for a user
//    /// </summary>
//    /// <param name="displayPreferences">The display preferences.</param>
//    /// <returns>Task{DisplayPreferences}.</returns>
//    /// <exception cref="System.IllegalArgumentException">userId</exception>
//    public void UpdateDisplayPreferencesAsync(DisplayPreferences displayPreferences, String userId, String client, final EmptyResponse response)
//    {
//        if (displayPreferences == null)
//        {
//            throw new IllegalArgumentException("displayPreferences");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.Add("userId", userId);
//        dict.Add("client", client);
//        
//        String url = GetApiUrl("DisplayPreferences/" + displayPreferences.getId(), dict);
//        
//        PostAsync(url, displayPreferences, response);
//    }
//    
//    public void GetNotificationsSummary(String userId, final Response<NotificationsSummary> response)
//    {
//        String url = GetApiUrl("Notifications/" + userId + "/Summary");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<NotificationsSummary>(response, jsonSerializer, NotificationsSummary.class));
//    }
//    
//    public void MarkNotificationsRead(String userId, String[] notificationIdList, Boolean isRead, final EmptyResponse response)
//    {
//        String url = "Notifications/" + userId;
//        
//        url += isRead ? "/Read" : "/Unread";
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.Add("Ids", notificationIdList);
//        
//        url = GetApiUrl(url, dict);
//        
//        PostAsync(url, response);
//    }
//    
//    public void GetNotificationsAsync(NotificationQuery query, final Response<NotificationResult> response)
//    {
//        String url = "Notifications/" + query.getUserId();
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        dict.AddIfNotNull("ItemIds", query.getIsRead());
//        dict.AddIfNotNull("StartIndex", query.getStartIndex());
//        dict.AddIfNotNull("Limit", query.getLimit());
//        
//        url = GetApiUrl(url, dict);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<NotificationResult>(response, jsonSerializer, NotificationResult.class));
//    }
//    
//    public void GetAllThemeMediaAsync(String userId, String itemId, Boolean inheritFromParent, final Response<AllThemeMediaResult> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.Add("InheritFromParent", inheritFromParent);
//        queryString.AddIfNotNullOrEmpty("UserId", userId);
//        
//        String url = GetApiUrl("Items/" + itemId + "/ThemeMedia", queryString);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<AllThemeMediaResult>(response, jsonSerializer, AllThemeMediaResult.class));
//    }
//    
//    public void GetSearchHintsAsync(SearchQuery query, final Response<SearchHintResult> response)
//    {
//        if (query == null || tangible.DotNetToJavaStringHelper.isNullOrEmpty(query.getSearchTerm()))
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.AddIfNotNullOrEmpty("SearchTerm", query.getSearchTerm());
//        queryString.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        queryString.AddIfNotNull("StartIndex", query.getStartIndex());
//        queryString.AddIfNotNull("Limit", query.getLimit());
//        
//        queryString.Add("IncludeArtists", query.getIncludeArtists());
//        queryString.Add("IncludeGenres", query.getIncludeGenres());
//        queryString.Add("IncludeMedia", query.getIncludeMedia());
//        queryString.Add("IncludePeople", query.getIncludePeople());
//        queryString.Add("IncludeStudios", query.getIncludeStudios());
//        queryString.Add("IncludeItemTypes", query.getIncludeItemTypes());
//        
//        String url = GetApiUrl("Search/Hints", queryString);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<SearchHintResult>(response, jsonSerializer, SearchHintResult.class));
//    }
//    
//    public void GetThemeSongsAsync(String userId, String itemId, Boolean inheritFromParent, final Response<ThemeMediaResult> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.Add("InheritFromParent", inheritFromParent);
//        queryString.AddIfNotNullOrEmpty("UserId", userId);
//        
//        String url = GetApiUrl("Items/" + itemId + "/ThemeSongs", queryString);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<ThemeMediaResult>(response, jsonSerializer, ThemeMediaResult.class));
//    }
//    
//    public void GetThemeVideosAsync(String userId, String itemId, Boolean inheritFromParent, final Response<ThemeMediaResult> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.Add("InheritFromParent", inheritFromParent);
//        queryString.AddIfNotNullOrEmpty("UserId", userId);
//        
//        String url = GetApiUrl("Items/" + itemId + "/ThemeVideos", queryString);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<ThemeMediaResult>(response, jsonSerializer, ThemeMediaResult.class));
//    }
//    
//    /// <summary>
//    /// Gets the critic reviews.
//    /// </summary>
//    /// <param name="itemId">The item id.</param>
//    /// <param name="startIndex">The start index.</param>
//    /// <param name="limit">The limit.</param>
//    /// <returns>Task{ItemReviewsResult}.</returns>
//    /// <exception cref="System.IllegalArgumentException">
//    /// id
//    /// or
//    /// userId
//    /// </exception>
//    public void GetCriticReviews(String itemId, Integer startIndex, Integer limit, final Response<ItemReviewsResult> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(itemId))
//        {
//            throw new IllegalArgumentException("itemId");
//        }
//        
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.AddIfNotNull("startIndex", startIndex);
//        queryString.AddIfNotNull("limit", limit);
//        
//        String url = GetApiUrl("Items/" + itemId + "/CriticReviews", queryString);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<ItemReviewsResult>(response, jsonSerializer, ItemReviewsResult.class));
//    }
//    
//    /// <summary>
//    /// Gets the index of the game player.
//    /// </summary>
//    /// <param name="userId">The user id.</param>
//    /// <param name="cancellationToken">The cancellation token.</param>
//    /// <returns>Task{List{ItemIndex}}.</returns>
//    public void GetGamePlayerIndex(String userId, final Response<ItemIndex[]> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.AddIfNotNullOrEmpty("UserId", userId);
//        
//        String url = GetApiUrl("Games/PlayerIndex", queryString);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ItemIndex[]>(response, jsonSerializer, new ItemIndex[]{}.getClass()));
//    }
//    
//    /// <summary>
//    /// Gets the index of the year.
//    /// </summary>
//    /// <param name="userId">The user id.</param>
//    /// <param name="includeItemTypes">The include item types.</param>
//    /// <param name="cancellationToken">The cancellation token.</param>
//    /// <returns>Task{List{ItemIndex}}.</returns>
//    public void GetYearIndex(String userId, String[] includeItemTypes, final Response<ItemIndex[]> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.AddIfNotNullOrEmpty("UserId", userId);
//        queryString.AddIfNotNull("IncludeItemTypes", includeItemTypes);
//        
//        String url = GetApiUrl("Items/YearIndex", queryString);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ItemIndex[]>(response, jsonSerializer, new ItemIndex[]{}.getClass()));
//    }
//    
//    public void ReportCapabilities(ClientCapabilities capabilities, final EmptyResponse response)
//    {
//        if (capabilities == null)
//        {
//            throw new IllegalArgumentException("capabilities");
//        }
//        
//        String url = GetApiUrl("Sessions/Capabilities/Full");
//        
//        PostAsync(url, capabilities, response);
//    }
//    
//    public void GetLiveTvInfoAsync(final Response<LiveTvInfo> response)
//    {
//        String url = GetApiUrl("LiveTv/Info");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<LiveTvInfo>(response, jsonSerializer, LiveTvInfo.class));
//    }
//    
//    public void GetLiveTvRecordingGroupsAsync(RecordingGroupQuery query, final Response<ItemsResult> response)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        
//        String url = GetApiUrl("LiveTv/Recordings/Groups", dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ItemsResult>(response, jsonSerializer, ItemsResult.class));
//    }
//    
//    public void GetLiveTvRecordingsAsync(RecordingQuery query, final Response<ItemsResult> response)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        dict.AddIfNotNullOrEmpty("ChannelId", query.getChannelId());
//        dict.AddIfNotNullOrEmpty("GroupId", query.getGroupId());
//        dict.AddIfNotNullOrEmpty("Id", query.getUserId());
//        dict.AddIfNotNullOrEmpty("SeriesTimerId", query.getSeriesTimerId());
//        dict.AddIfNotNull("IsInProgress", query.getIsInProgress());
//        dict.AddIfNotNull("StartIndex", query.getStartIndex());
//        dict.AddIfNotNull("Limit", query.getLimit());
//        
//        dict.AddIfNotNull("EnableImages", query.getEnableImages());
//        dict.AddIfNotNull("ImageTypeLimit", query.getImageTypeLimit());
//        dict.AddIfNotNull("EnableImageTypes", query.getEnableImageTypes());
//        dict.AddIfNotNull("Fields", query.getFields());
//        
//        String url = GetApiUrl("LiveTv/Recordings", dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ItemsResult>(response, jsonSerializer, ItemsResult.class));
//    }
//    
//    public void GetLiveTvChannelsAsync(LiveTvChannelQuery query, final Response<ChannelInfoDtoResult> response)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        dict.AddIfNotNull("StartIndex", query.getStartIndex());
//        dict.AddIfNotNull("Limit", query.getLimit());
//        dict.AddIfNotNull("IsFavorite", query.getIsFavorite());
//        dict.AddIfNotNull("IsLiked", query.getIsLiked());
//        dict.AddIfNotNull("IsDisliked", query.getIsDisliked());
//        dict.AddIfNotNull("EnableFavoriteSorting", query.getEnableFavoriteSorting());
//        
//        if (query.getChannelType() != null)
//        {
//            dict.Add("ChannelType", query.getChannelType());
//        }
//        
//        String url = GetApiUrl("LiveTv/Channels", dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ChannelInfoDtoResult>(response, jsonSerializer, ChannelInfoDtoResult.class));
//    }
//    
//    public void CancelLiveTvSeriesTimerAsync(String id, final EmptyResponse response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        String url = GetApiUrl("LiveTv/SeriesTimers/" + id, dict);
//        
//        DeleteAsync(url, response);
//    }
//    
//    public void CancelLiveTvTimerAsync(String id, final EmptyResponse response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        String url = GetApiUrl("LiveTv/Timers/" + id, dict);
//        
//        DeleteAsync(url, response);
//    }
//    
//    public void GetLiveTvChannelAsync(String id, String userId, final Response<ChannelInfoDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        dict.AddIfNotNullOrEmpty("userId", userId);
//        
//        String url = GetApiUrl("LiveTv/Channels/" + id, dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ChannelInfoDto>(response, jsonSerializer, ChannelInfoDto.class));
//    }
//    
//    public void GetLiveTvRecordingAsync(String id, String userId, final Response<BaseItemDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        dict.AddIfNotNullOrEmpty("userId", userId);
//        
//        String url = GetApiUrl("LiveTv/Recordings/" + id, dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<BaseItemDto>(response, jsonSerializer, BaseItemDto.class));
//    }
//    
//    public void GetLiveTvRecordingGroupAsync(String id, String userId, final Response<BaseItemDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        dict.AddIfNotNullOrEmpty("userId", userId);
//        
//        String url = GetApiUrl("LiveTv/Recordings/Groups/" + id, dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<BaseItemDto>(response, jsonSerializer, BaseItemDto.class));
//    }
//    
//    public void GetLiveTvSeriesTimerAsync(String id, final Response<SeriesTimerInfoDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        String url = GetApiUrl("LiveTv/SeriesTimers/" + id, dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<SeriesTimerInfoDto>(response, jsonSerializer, SeriesTimerInfoDto.class));
//    }
//    
//    public void GetLiveTvSeriesTimersAsync(SeriesTimerQuery query, final Response<SeriesTimerInfoDtoResult> response)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNullOrEmpty("SortBy", query.getSortBy());
//        dict.Add("SortOrder", query.getSortOrder());
//        
//        String url = GetApiUrl("LiveTv/SeriesTimers", dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<SeriesTimerInfoDtoResult>(response, jsonSerializer, SeriesTimerInfoDtoResult.class));
//    }
//    
//    public void GetLiveTvTimerAsync(String id, final Response<TimerInfoDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        String url = GetApiUrl("LiveTv/Timers/" + id, dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<TimerInfoDto>(response, jsonSerializer, TimerInfoDto.class));
//    }
//    
//    public void GetLiveTvTimersAsync(TimerQuery query, final Response<TimerInfoDtoResult> response)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNullOrEmpty("ChannelId", query.getChannelId());
//        dict.AddIfNotNullOrEmpty("SeriesTimerId", query.getSeriesTimerId());
//        
//        String url = GetApiUrl("LiveTv/Timers", dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<TimerInfoDtoResult>(response, jsonSerializer, new TimerInfoDtoResult().getClass()));
//    }
//    
//    public void GetLiveTvProgramsAsync(ProgramQuery query, final Response<ItemsResult> response)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        String isoDateFormat = "o";
//        
//        if (query.getMaxEndDate() != null)
//        {
//            dict.Add("MaxEndDate", getIsoString(query.getMaxEndDate()));
//        }
//        if (query.getMaxStartDate() != null)
//        {
//            dict.Add("MaxStartDate", getIsoString(query.getMaxStartDate()));
//        }
//        if (query.getMinEndDate() != null)
//        {
//            dict.Add("MinEndDate", getIsoString(query.getMinEndDate()));
//        }
//        if (query.getMinStartDate() != null)
//        {
//            dict.Add("MinStartDate", getIsoString(query.getMinStartDate()));
//        }
//        
//        dict.AddIfNotNull("EnableImages", query.getEnableImages());
//        dict.AddIfNotNull("ImageTypeLimit", query.getImageTypeLimit());
//        dict.AddIfNotNull("EnableImageTypes", query.getEnableImageTypes());
//        dict.AddIfNotNull("Fields", query.getFields());
//        dict.AddIfNotNull("SortBy", query.getSortBy());
//        
//        dict.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        
//        if (query.getChannelIds() != null)
//        {
//            dict.Add("ChannelIds", tangible.DotNetToJavaStringHelper.join(",", query.getChannelIds()));
//        }
//        
//        // TODO: This endpoint supports POST if the query String is too long
//        String url = GetApiUrl("LiveTv/Programs", dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ItemsResult>(response, jsonSerializer, ItemsResult.class));
//    }
//    
//    public void GetRecommendedLiveTvProgramsAsync(RecommendedProgramQuery query, final Response<ItemsResult> response)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNull("EnableImages", query.getEnableImages());
//        dict.AddIfNotNull("ImageTypeLimit", query.getImageTypeLimit());
//        dict.AddIfNotNull("EnableImageTypes", query.getEnableImageTypes());
//        dict.AddIfNotNull("Fields", query.getFields());
//        
//        dict.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        dict.AddIfNotNull("Limit", query.getLimit());
//        dict.AddIfNotNull("HasAired", query.getHasAired());
//        dict.AddIfNotNull("IsAiring", query.getIsAiring());
//        
//        String url = GetApiUrl("LiveTv/Programs/Recommended", dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ItemsResult>(response, jsonSerializer, ItemsResult.class));
//    }
//    
//    public void CreateLiveTvSeriesTimerAsync(SeriesTimerInfoDto timer, final EmptyResponse response)
//    {
//        if (timer == null)
//        {
//            throw new IllegalArgumentException("timer");
//        }
//        
//        String url = GetApiUrl("LiveTv/SeriesTimers");
//        
//        PostAsync(url, timer, response);
//    }
//    
//    public void CreateLiveTvTimerAsync(BaseTimerInfoDto timer, final EmptyResponse response)
//    {
//        if (timer == null)
//        {
//            throw new IllegalArgumentException("timer");
//        }
//        
//        String url = GetApiUrl("LiveTv/Timers");
//        
//        PostAsync(url, timer, response);
//    }
//    
//    public void GetDefaultLiveTvTimerInfo(String programId, final Response<SeriesTimerInfoDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(programId))
//        {
//            throw new IllegalArgumentException("programId");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        
//        dict.AddIfNotNullOrEmpty("programId", programId);
//        
//        String url = GetApiUrl("LiveTv/Timers/Defaults", dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<SeriesTimerInfoDto>(response, jsonSerializer, SeriesTimerInfoDto.class));
//    }
//    
//    public void GetDefaultLiveTvTimerInfo(final Response<SeriesTimerInfoDto> response)
//    {
//        String url = GetApiUrl("LiveTv/Timers/Defaults");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<SeriesTimerInfoDto>(response, jsonSerializer, SeriesTimerInfoDto.class));
//    }
//    
//    public void GetLiveTvGuideInfo(final Response<GuideInfo> response)
//    {
//        String url = GetApiUrl("LiveTv/GuideInfo");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<GuideInfo>(response, jsonSerializer, GuideInfo.class));
//    }
//    
//    public void GetLiveTvProgramAsync(String id, String userId, final Response<BaseItemDto> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary ();
//        dict.AddIfNotNullOrEmpty("userId", userId);
//        
//        String url = GetApiUrl("LiveTv/Programs/" + id, dict);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<BaseItemDto>(response, jsonSerializer, BaseItemDto.class));
//    }
//    
//    public void UpdateLiveTvSeriesTimerAsync(SeriesTimerInfoDto timer, final EmptyResponse response)
//    {
//        if (timer == null)
//        {
//            throw new IllegalArgumentException("timer");
//        }
//        
//        String url = GetApiUrl("LiveTv/SeriesTimers/" + timer.getId());
//        
//        PostAsync(url, timer, response);
//    }
//    
//    public void UpdateLiveTvTimerAsync(TimerInfoDto timer, final EmptyResponse response)
//    {
//        if (timer == null)
//        {
//            throw new IllegalArgumentException("timer");
//        }
//        
//        String url = GetApiUrl("LiveTv/Timers/" + timer.getId());
//        
//        PostAsync(url, timer, response);
//    }
//    
//    public void SendString(String sessionId, String text, final EmptyResponse response)
//    {
//        GeneralCommand cmd = new GeneralCommand();
//        
//        cmd.setName("SendString");
//        
//        cmd.getArguments().put("String", text);
//        
//        SendCommandAsync(sessionId, cmd, response);
//    }
//    
//    public void SetAudioStreamIndex(String sessionId, int index, final EmptyResponse response)
//    {
//        GeneralCommand cmd = new GeneralCommand();
//        
//        cmd.setName("SetAudioStreamIndex");
//        
//        cmd.getArguments().put("Index", StringHelper.ToStringCultureInvariant(index));
//        
//        SendCommandAsync(sessionId, cmd, response);
//    }
//    
//    public void SetSubtitleStreamIndex(String sessionId, Integer index, final EmptyResponse response)
//    {
//        GeneralCommand cmd = new GeneralCommand();
//        
//        cmd.setName("SetSubtitleStreamIndex");
//        
//        int indexValue = index == null ? -1 : index.intValue();
//        
//        cmd.getArguments().put("Index", StringHelper.ToStringCultureInvariant(indexValue));
//        
//        SendCommandAsync(sessionId, cmd, response);
//    }
//    
//    public void SetVolume(String sessionId, int volume, final EmptyResponse response)
//    {
//        GeneralCommand cmd = new GeneralCommand();
//        
//        cmd.setName("SetVolume");
//        
//        cmd.getArguments().put("Volume", StringHelper.ToStringCultureInvariant(volume));
//        
//        SendCommandAsync(sessionId, cmd, response);
//    }
//    
//    public void GetAdditionalParts(String itemId, String userId, final Response<ItemsResult> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.AddIfNotNullOrEmpty("UserId", userId);
//        
//        String url = GetApiUrl("Videos/" + itemId + "/AdditionalParts", queryString);
//        
//        GetItemsFromUrl(url, response);
//    }
//    
//    public void GetChannelFeatures(String channelId, final Response<ChannelFeatures> response)
//    {
//        String url = GetApiUrl("Channels/" + channelId + "/Features");
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<ChannelFeatures>(response, jsonSerializer, ChannelFeatures.class));
//    }
//    
//    public void GetChannelItems(ChannelItemQuery query, final Response<ItemsResult> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        queryString.AddIfNotNull("StartIndex", query.getStartIndex());
//        queryString.AddIfNotNull("Limit", query.getLimit());
//        queryString.AddIfNotNullOrEmpty("FolderId", query.getFolderId());
//        
//        queryString.AddIfNotNull("Fields", query.getFields());
//        queryString.AddIfNotNull("Limit", query.getLimit());
//        
//        queryString.AddIfNotNull("Filters", query.getFilters());
//        queryString.AddIfNotNull("SortBy", query.getSortBy());
//        queryString.Add("SortOrder", query.getSortOrder());
//        
//        String url = GetApiUrl("Channels/" + query.getChannelId() + "/Items", queryString);
//        
//        GetItemsFromUrl(url, response);
//    }
//    
//    public void GetChannels(ChannelQuery query, final Response<ItemsResult> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.AddIfNotNullOrEmpty("UserId", query.getUserId());
//        queryString.AddIfNotNull("SupportsLatestItems", query.getSupportsLatestItems());
//        queryString.AddIfNotNull("StartIndex", query.getStartIndex());
//        queryString.AddIfNotNull("Limit", query.getLimit());
//        queryString.AddIfNotNull("IsFavorite", query.getIsFavorite());
//        
//        String url = GetApiUrl("Channels", queryString);
//        
//        GetItemsFromUrl(url, response);
//    }
//    
//    public void GetCurrentSessionAsync(final Response<SessionInfoDto> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.Add("DeviceId", getDeviceId());
//        String url = GetApiUrl("Sessions", queryString);
//        
//        url = AddDataFormat(url);
//        Send(url, "GET", new SerializedResponse<SessionInfoDto>(response, jsonSerializer, SessionInfoDto.class));
//    }
//    
//    public void StopTranscodingProcesses(String deviceId, String playSessionId, final EmptyResponse response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.Add("DeviceId", getDeviceId());
//        queryString.AddIfNotNullOrEmpty("PlaySessionId", playSessionId);
//        String url = GetApiUrl("Videos/ActiveEncodings", queryString);
//        
//        DeleteAsync(url, response);
//    }
//    
//    public void GetLatestChannelItems(AllChannelMediaQuery query, final Response<ItemsResult> response)
//    {
//        throw new UnsupportedOperationException();
//    }
//    
//    public void DeleteItem(String id, final EmptyResponse response)
//    {
//        String url = GetApiUrl("Items/" + id);
//        
//        DeleteAsync(url, response);
//    }
//    
//    public void Logout(final EmptyResponse response)
//    {
//        String url = GetApiUrl("Sessions/Logout");
//        
//        PostAsync(url, new EmptyResponse() {
//            
//            @Override
//            public void onResponse() {
//                
//                ClearAuthenticationInfo();
//                response.onResponse();
//            }
//            
//            @Override
//            public void onError(Exception ex) {
//                
//                Logger.ErrorException("Error logging out", ex);
//                ClearAuthenticationInfo();
//                response.onResponse();
//            }
//            });
//        
//        if (apiWebSocket != null && apiWebSocket.IsWebSocketOpenOrConnecting()){
//            apiWebSocket.Close();
//            apiWebSocket = null;
//        }
//    }
//    
//    public void GetUserViews(String userId, final Response<ItemsResult> response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(userId))
//        {
//            throw new IllegalArgumentException("userId");
//        }
//        
//        String url = GetApiUrl("Users/" + userId + "/Views");
//        
//        GetItemsFromUrl(url, response);
//    }
//    
//    public void GetLatestItems(LatestItemsQuery query, final Response<BaseItemDto[]> response)
//    {
//        if (query == null)
//        {
//            throw new IllegalArgumentException("query");
//        }
//        
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        queryString.AddIfNotNull("GroupItems", query.getGroupItems());
//        queryString.AddIfNotNull("IncludeItemTypes", query.getIncludeItemTypes());
//        queryString.AddIfNotNullOrEmpty("ParentId", query.getParentId());
//        queryString.AddIfNotNull("IsPlayed", query.getIsPlayed());
//        queryString.AddIfNotNull("StartIndex", query.getStartIndex());
//        queryString.AddIfNotNull("Limit", query.getLimit());
//        queryString.AddIfNotNull("Fields", query.getFields());
//        
//        String url = GetApiUrl("Users/" + query.getUserId() + "/Items/Latest", queryString);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<BaseItemDto[]>(response, jsonSerializer, new BaseItemDto[]{}.getClass()));
//    }
//    
//    public void AddToPlaylist(String playlistId, String[] itemIds, String userId, final EmptyResponse response)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(playlistId))
//        {
//            throw new IllegalArgumentException("playlistId");
//        }
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.AddIfNotNull("Ids", itemIds);
//        String url = GetApiUrl("Playlists/"+playlistId+"/Items", dict);
//        
//        PostAsync(url, response);
//    }
//    
//    public void CreatePlaylist(PlaylistCreationRequest request, final Response<PlaylistCreationResult> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.Add("UserId", request.getUserId());
//        queryString.Add("Name", request.getName());
//        
//        queryString.AddIfNotNullOrEmpty("MediaType", request.getMediaType());
//        
//        queryString.AddIfNotNull("Ids", request.getItemIdList());
//        
//        String url = GetApiUrl("Playlists/", queryString);
//        url = AddDataFormat(url);
//        
//        Send(url, "POST", new SerializedResponse<PlaylistCreationResult>(response, jsonSerializer, PlaylistCreationResult.class));
//    }
//    
//    public void GetPlaylistItems(PlaylistItemQuery query, final Response<ItemsResult> response)
//    {
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        
//        queryString.AddIfNotNull("StartIndex", query.getStartIndex());
//        
//        queryString.AddIfNotNull("Limit", query.getLimit());
//        queryString.Add("UserId", query.getUserId());
//        
//        queryString.AddIfNotNull("fields", query.getFields());
//        
//        String url = GetApiUrl("Playlists/" + query.getId() + "/Items", queryString);
//        
//        GetItemsFromUrl(url, response);
//    }
//    
//    public void RemoveFromPlaylist(String playlistId, String[] entryIds, final EmptyResponse response)
//    {
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.AddIfNotNull("EntryIds", entryIds);
//        String url = GetApiUrl("Playlists/"+playlistId+"/Items", dict);
//        
//        DeleteAsync(url, response);
//    }
//    
//    public void GetFilters(String userId,
//    String parentId,
//    String[] mediaTypes,
//    String[] itemTypes,
//    Response<QueryFilters> response) {
//        
//        QueryStringDictionary queryString = new QueryStringDictionary();
//        queryString.AddIfNotNullOrEmpty("UserId", userId);
//        queryString.AddIfNotNullOrEmpty("ParentId", parentId);
//        queryString.AddIfNotNull("IncludeItemTypes", itemTypes);
//        queryString.AddIfNotNull("MediaTypes", mediaTypes);
//        
//        String url = GetApiUrl("Items/Filters", queryString);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<QueryFilters>(response, jsonSerializer, QueryFilters.class));
//    }
//    
//    public void GetPlaybackInfo(PlaybackInfoRequest request, final Response<PlaybackInfoResponse> response)
//    {
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.Add("UserId", request.getUserId());
//        
//        String url = GetApiUrl("Items/" + request.getId() + "/PlaybackInfo", dict);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<PlaybackInfoResponse>(response, jsonSerializer, PlaybackInfoResponse.class));
//    }
//    
//    public void GetPlaybackInfoWithPost(PlaybackInfoRequest request, final Response<PlaybackInfoResponse> response)
//    {
//        String url = GetApiUrl("Items/" + request.getId() + "/PlaybackInfo");
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "POST", jsonSerializer.SerializeToString(request), "application/json", new SerializedResponse<PlaybackInfoResponse>(response, jsonSerializer, PlaybackInfoResponse.class));
//    }
//    
//    public void OpenLiveStream(LiveStreamRequest request, final Response<LiveStreamResponse> response)
//    {
//        String url = GetApiUrl("LiveStreams/Open");
//        
//        url = AddDataFormat(url);
//        
//        String json = getJsonSerializer().SerializeToString(request);
//        Send(url, "POST", json, "application/json", new SerializedResponse<LiveStreamResponse>(response, jsonSerializer, LiveStreamResponse.class));
//    }
//    
//    public void GetDevicesOptions(final Response<DevicesOptions> response)
//    {
//        String url = GetApiUrl("System/Configuration/devices");
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<DevicesOptions>(response, jsonSerializer, DevicesOptions.class));
//    }
//    
//    public void GetContentUploadHistory(final Response<ContentUploadHistory> response)
//    {
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.Add("DeviceId", getDeviceId());
//        
//        String url = GetApiUrl("Devices/CameraUploads", dict);
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<ContentUploadHistory>(response, jsonSerializer, ContentUploadHistory.class));
//    }
//    
//    public void UploadFile(FileInputStream fileInputStream,
//    LocalFileInfo file,
//    IProgress<Double> progress,
//    CancellationToken cancellationToken) throws IOException, IllegalArgumentException {
//        
//        UploadFileInternal(fileInputStream, file, progress, cancellationToken);
//    }
//    
//    protected void UploadFileInternal(FileInputStream fileInputStream,
//        LocalFileInfo file,
//        IProgress<Double> progress,
//        CancellationToken cancellationToken) throws IOException ,IllegalArgumentException {
//            
//            if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(getDeviceId()))
//            {
//                throw new IllegalArgumentException("ApiClient.deviceId cannot be null or empty");
//            }
//            
//            if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(file.getId()))
//            {
//                throw new IllegalArgumentException("file.getId() cannot be null or empty");
//            }
//            
//            if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(file.getName()))
//            {
//                throw new IllegalArgumentException("file.getName() cannot be null or empty");
//            }
//            
//            QueryStringDictionary dict = new QueryStringDictionary();
//            
//            dict.Add("DeviceId", getDeviceId());
//            dict.Add("Name", file.getName());
//            dict.Add("Id", file.getId());
//            dict.AddIfNotNullOrEmpty("Album", file.getAlbum());
//            
//            HttpURLConnection conn = null;
//            DataOutputStream dos = null;
//            URL url = new URL(GetApiUrl("Devices/CameraUploads", dict));
//            
//            int maxBufferSize = 1 * 1024 * 1024;
//            
//            try {
//                
//                // Open a HTTP  connection to  the URL
//                conn = (HttpURLConnection) url.openConnection();
//                conn.setDoInput(true); // Allow Inputs
//                conn.setDoOutput(true); // Allow Outputs
//                conn.setUseCaches(false); // Don't use a Cached Copy
//                conn.setRequestMethod("POST");
//                conn.setRequestProperty("Connection", "Keep-Alive");
//                conn.setRequestProperty("Content-Type", file.getMimeType());
//                
//                for (String key: this.HttpHeaders.keySet()){
//                    conn.setRequestProperty(key, this.HttpHeaders.get(key));
//                }
//                
//                String parameter = this.HttpHeaders.getAuthorizationParameter();
//                if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(parameter))
//                {
//                    String value = this.HttpHeaders.getAuthorizationScheme() + " " + parameter;
//                    conn.setRequestProperty("Authorization", value);
//                }
//                
//                dos = new DataOutputStream(conn.getOutputStream());
//                
//                // createUserAction a buffer of  maximum size
//                int bytesAvailable = fileInputStream.available();
//                
//                int bufferSize = Math.min(bytesAvailable, maxBufferSize);
//                byte[] buffer = new byte[bufferSize];
//                
//                // read file and write it into form...
//                long bytesRead = fileInputStream.read(buffer, 0, bufferSize);
//                
//                while (bytesRead > 0) {
//                    
//                    dos.write(buffer, 0, bufferSize);
//                    bytesAvailable = fileInputStream.available();
//                    bufferSize = Math.min(bytesAvailable, maxBufferSize);
//                    bytesRead = fileInputStream.read(buffer, 0, bufferSize);
//                }
//                
//                String serverResponseMessage = conn.getResponseMessage();
//                
//                int responseCode = conn.getResponseCode();
//                
//                if(responseCode == 200 || responseCode == 204){
//                    
//                    progress.reportComplete();
//                }
//                else{
//                    
//                    HttpException ex = new HttpException(serverResponseMessage);
//                    ex.setStatusCode(responseCode);
//                    
//                    progress.reportError(ex);
//                }
//                
//            }
//            catch (Exception ex) {
//                
//                Logger.ErrorException("Error uploading file", ex);
//                progress.reportError(new HttpException(ex.getMessage()));
//            }
//            finally {
//                
//                //close the streams //
//                fileInputStream.close();
//                
//                if (dos != null){
//                    dos.flush();
//                    dos.close();
//                }
//            }
//    }
//    
//    public void GetNewsItems(final Response<NewsItemsResult> response) {
//        
//        String url = GetApiUrl("News/Product");
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<NewsItemsResult>(response, jsonSerializer, NewsItemsResult.class));
//    }
//    
//    public void UpdateUserConfiguration(String userId, UserConfiguration configuration, EmptyResponse response) {
//        
//        response.onError(new UnsupportedOperationException());
//    }
//    
//    public void CreateSyncJob(SyncJobRequest request, Response<SyncJobCreationResult> response){
//        
//        if (request == null)
//        {
//            throw new IllegalArgumentException("request");
//        }
//        
//        String url = GetApiUrl("Sync/Jobs");
//        url = AddDataFormat(url);
//        
//        Send(url, "POST", jsonSerializer.SerializeToString(request), "application/json", new SerializedResponse<SyncJobCreationResult>(response, jsonSerializer, SyncJobCreationResult.class));
//    }
//    
//    public void CancelSyncJob(SyncJob job, EmptyResponse response) {
//        
//        if (job == null)
//        {
//            throw new IllegalArgumentException("job");
//        }
//        
//        String url = GetApiUrl("Sync/Jobs/" + job.getId());
//        
//        DeleteAsync(url, response);
//    }
//    
//    public void UpdateSyncJob(SyncJob job, EmptyResponse response){
//        
//        if (job == null)
//        {
//            throw new IllegalArgumentException("job");
//        }
//        
//        String url = GetApiUrl("Sync/Jobs/" + job.getId());
//        
//        PostAsync(url, job, response);
//    }
//    
//    public void GetSyncJobItemFile(String id, Response<InputStream> response){
//        
//        getResponseStream(getSyncJobItemFileUrl(id), response);
//    }
//    
//    public String getSyncJobItemFileUrl(String id)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        return GetApiUrl("Sync/JobItems/" + id + "/File");
//    }
//    
//    public void GetSyncJobs(SyncJobQuery query, Response<SyncJobQueryResult> response) {
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.AddIfNotNull("Limit", query.getLimit());
//        dict.AddIfNotNull("StartIndex", query.getStartIndex());
//        dict.AddIfNotNull("SyncNewContent", query.getSyncNewContent());
//        dict.AddIfNotNullOrEmpty("TargetId", query.getTargetId());
//        
//        dict.AddIfNotNull("Statuses", query.getStatuses(), ",");
//        
//        String url = GetApiUrl("Sync/Jobs", dict);
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<SyncJobQueryResult>(response, jsonSerializer, SyncJobQueryResult.class));
//    }
//    
//    public void GetSyncJobItems(SyncJobItemQuery query, Response<SyncJobItemQueryResult> response) {
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.AddIfNotNullOrEmpty("JobId", query.getJobId());
//        dict.AddIfNotNull("Limit", query.getLimit());
//        dict.AddIfNotNull("StartIndex", query.getStartIndex());
//        dict.AddIfNotNullOrEmpty("TargetId", query.getTargetId());
//        
//        dict.AddIfNotNull("Statuses", query.getStatuses(), ",");
//        
//        String url = GetApiUrl("Sync/JobItems", dict);
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<SyncJobItemQueryResult>(response, jsonSerializer, SyncJobItemQueryResult.class));
//    }
//    
//    public void reportSyncJobItemTransferred(String id, EmptyResponse response) {
//        
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        String url = GetApiUrl("Sync/JobItems/" + id + "/Transferred");
//        
//        PostAsync(url, response);
//    }
//    
//    public void GetOfflineUser(String id, Response<UserDto> response) {
//        
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(id))
//        {
//            throw new IllegalArgumentException("id");
//        }
//        
//        String url = GetApiUrl("Users/" + id + "/Offline");
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<UserDto>(response, jsonSerializer, UserDto.class));
//    }
//    
//    public void ReportOfflineActions(ArrayList<UserAction> actions, EmptyResponse response) {
//        
//        if (actions == null || actions.size() == 0)
//        {
//            throw new IllegalArgumentException("actions");
//        }
//        
//        String url = GetApiUrl("Sync/OfflineActions");
//        
//        PostAsync(url, actions, response);
//    }
//    
//    public void SyncData(SyncDataRequest request, final Response<SyncDataResponse> response) {
//        
//        if (request == null)
//        {
//            throw new IllegalArgumentException("request");
//        }
//        
//        String url = GetApiUrl("Sync/Data");
//        url = AddDataFormat(url);
//        
//        String json = getJsonSerializer().SerializeToString(request);
//        Send(url, "POST", json, "application/json", new SerializedResponse<SyncDataResponse>(response, jsonSerializer, SyncDataResponse.class));
//    }
//    
//    public void getSyncJobItemAdditionalFile(String syncJobItemId, String filename, final Response<InputStream> response){
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.AddIfNotNullOrEmpty("Name", filename);
//        
//        String url = GetApiUrl("Sync/JobItems/" + syncJobItemId + "/AdditionalFiles", dict);
//        
//        getResponseStream(url, response);
//    }
//    
//    public void getReadySyncItems(String targetId, final Response<ReadySyncItemsResult> response) {
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.AddIfNotNullOrEmpty("TargetId", targetId);
//        
//        String url = GetApiUrl("Sync/Items/Ready", dict);
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<ReadySyncItemsResult>(response, jsonSerializer, url, Logger, new ReadySyncItemsResult().getClass()));
//    }
//    
//    public void detectBitrate(final Response<Long> response) {
//        
//        // First try a small amount so that we don't hang up their mobile connection
//        detectBitrate(1000000, new Response<Long>(response) {
//            
//            @Override
//            public void onResponse(Long bitrate) {
//                
//                if (bitrate < 3000000) {
//                    response.onResponse(Math.round(bitrate * .8));
//                    return;
//                }
//                
//                // If that produced a fairly high speed, try again with a larger size to get a more accurate result
//                detectBitrate(3000000, new Response<Long>(response) {
//                    
//                    @Override
//                    public void onResponse(Long bitrate) {
//                        
//                        response.onResponse(Math.round(bitrate * .8));
//                    }
//                    
//                    });
//            }
//            });
//    }
//    
//    protected void detectBitrate(final long downloadBytes, final Response<Long> response) {
//        
//        detectBitrateInternal(downloadBytes, response);
//    }
//    
//    protected void detectBitrateInternal(final long downloadBytes, final Response<Long> response) {
//        
//        QueryStringDictionary dict = new QueryStringDictionary();
//        
//        dict.Add("Size", downloadBytes);
//        
//        String address = GetApiUrl("Playback/BitrateTest", dict);
//        
//        HttpURLConnection conn = null;
//        
//        try
//            {
//                URL url = new URL(address);
//                
//                conn = (HttpURLConnection) url.openConnection();
//                conn.setDoInput(true); // Allow Inputs
//                conn.setUseCaches(false); // Don't use a Cached Copy
//                conn.setRequestMethod("GET");
//                conn.setRequestProperty("Connection", "Keep-Alive");
//                
//                for (String key: this.HttpHeaders.keySet()){
//                    conn.setRequestProperty(key, this.HttpHeaders.get(key));
//                }
//                
//                final long startTime = System.currentTimeMillis();
//                
//                try (InputStream inputStream = conn.getInputStream()){
//                    
//                    byte[] byteChunk = new byte[4096]; // Or whatever size you want to read in at a time.
//                    int n;
//                    
//                    while ( (n = inputStream.read(byteChunk)) > 0 ) {
//                        
//                    }
//                    
//                    double time = System.currentTimeMillis() - startTime;
//                    double bitrate = downloadBytes * 8;
//                    bitrate /= time;
//                    bitrate *= 1000;
//                    
//                    response.onResponse(Math.round(bitrate));
//                }
//                catch (IOException ioException){
//                    response.onError(ioException);
//                    return;
//                }
//        }
//        catch (Exception ex)
//        {
//            response.onError(ex);
//        }
//    }
//    
//    public void getSubtitles(String url, Response<SubtitleTrackInfo> response) {
//        
//        url = AddDataFormat(url);
//        
//        Send(url, "GET", new SerializedResponse<SubtitleTrackInfo>(response, jsonSerializer, url, Logger, new SubtitleTrackInfo().getClass()));
//    }
}
