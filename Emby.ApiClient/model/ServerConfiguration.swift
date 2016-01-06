//
//  ServerConfiguration.swift
//  EmbyApiClient
//

import Foundation

public struct ServerConfiguration: JSONSerializable {
    var enableUPnP: Bool?
    var publicPort: Int?
    var publicHttpsPort: Int?
    var httpServerPortNumber: Int?
    var httpsPortNumber: Int?
    var enableHttps: Bool?
    var certificatePath: String?
    var enableInternetProviders: Bool?
    var isPortAuthorized: Bool?
    var itemsByNamePath: String?
    var metadataPath: String?
    var seasonZeroDisplayName: String?
    var saveLocalMeta: Bool?
    var disableStartupScan: Bool?
    var enableUserViews: Bool?
    var enableLibraryMetadataSubFolder: Bool?
    var preferredMetadataLanguage: String?
    var metadataCountryCode: String?
    var sortReplaceCharacters: [String]?
    var sortRemoveCharacters: [String]?
    var sortRemoveWords: [String]?
    var minResumePct: Int?
    var maxResumePct: Int?
    var minResumeDurationSeconds: Int?
    var realtimeLibraryMonitorDelay: Int?
    var enableDashboardResponseCaching: Bool?
    var enableDashboardResourceMinification: Bool?
    var dashboardSourcePath: String?
    var mergeMetadataAndImagesByName: Bool?
    var enableStandaloneMetadata: Bool?
    var metadataOptions: [AnyObject]?
    var enableAutomaticRestart: Bool?
    var pathSubstitution: [AnyObject]?
    var serverName: String?
    var wanDdns: String?
    var UICulture: String?
    var peopleMetadataOptions: [AnyObject]?
    var findInternetTrailers: Bool?
    var insecureApps9: [String]?
    var saveMetadataHidden: Bool?
    var enableAudioArchiveFiles: Bool?
    var enableVideoArchiveFiles: Bool?
    var remoteClientBitrateLimit: Int?
    var denyIFrameEmbedding: Bool?
    var sharingExpirationDays: Int?
    var disableXmlSavers: Bool?
    var enableWindowsShortcuts: Bool?
    var enableVideoFrameByFrameAnalysis: Bool?
    var enableDateLastRefresh: Bool?
    var migrations: [String]?

//
//    /**
//    Gets or sets the image saving convention.
//    
//    <value>The image saving convention.</value>
//    */
//    private ImageSavingConvention ImageSavingConvention = getImageSavingConvention().values()[0];
//    public final ImageSavingConvention getImageSavingConvention()
//    {
//    return ImageSavingConvention;
//    }
//    public final void setImageSavingConvention(ImageSavingConvention value)
//    {
//    ImageSavingConvention = value;
//    }
//    
//    private NameValuePair[] ContentTypes;
//    public final NameValuePair[] getContentTypes()
//    {
//    return ContentTypes;
//    }
//    public final void setContentTypes(NameValuePair[] value)
//    {
//    ContentTypes = value;
//    }
    
//    private AutoOnOff EnableLibraryMonitor = AutoOnOff.values()[0];
//    public final AutoOnOff getEnableLibraryMonitor()
//    {
//    return EnableLibraryMonitor;
//    }
//    public final void setEnableLibraryMonitor(AutoOnOff value)
//    {
//    EnableLibraryMonitor = value;
//    }
//    
//
    
    public init?(jSON: JSON_Object) {
        fatalError("init(jSON:) has not been implemented: \(jSON)")
        
        //    setMigrations(new String[] {});
        //
        //    setImageSavingConvention(ImageSavingConvention.Compatible);
        //    setPublicPort(8096);
        //    setPublicHttpsPort(8920);
        //    setHttpServerPortNumber(8096);
        //    setHttpsPortNumber(8920);
        //    setEnableHttps(false);
        //    setEnableDashboardResponseCaching(true);
        //    setEnableDashboardResourceMinification(true);
        //
        //    setEnableAutomaticRestart(true);
        //    setDenyIFrameEmbedding(true);
        //
        //    setEnableUPnP(true);
        //
        //    setSharingExpirationDays(30);
        //    setMinResumePct(5);
        //    setMaxResumePct(90);
        //
        //    // 5 minutes
        //    setMinResumeDurationSeconds(300);
        //
        //    setEnableLibraryMonitor(AutoOnOff.Auto);
        //    setRealtimeLibraryMonitorDelay(40);
        //
        //    setEnableInternetProviders(true);
        //    setFindInternetTrailers(true);
        //
        //    setPathSubstitutions(new PathSubstitution[] { });
        //    setContentTypes(new NameValuePair[] { });
        //
        //    setPreferredMetadataLanguage("en");
        //    setMetadataCountryCode("US");
        //
        //    setSortReplaceCharacters(new String[] {".", "+", "%"});
        //    setSortRemoveCharacters(new String[] {",", "&", "-", "{", "}", "'"});
        //    setSortRemoveWords(new String[] {"the", "a", "an"});
        //
        //    setSeasonZeroDisplayName("Specials");
        //
        //    setUICulture("en-us");
        //
        //    setPeopleMetadataOptions(new PeopleMetadataOptions());
        //
        //    setInsecureApps9(new String[] {"Windows Phone"});
        //
        //    MetadataOptions tempVar = new MetadataOptions(1, 1280);
        //    tempVar.setItemType("Book");
        //    MetadataOptions tempVar2 = new MetadataOptions(1, 1280);
        //    tempVar2.setItemType("Movie");
        //    ImageOption tempVar3 = new ImageOption();
        //    tempVar3.setLimit(1);
        //    tempVar3.setMinWidth(1280);
        //    tempVar3.setType(ImageType.Backdrop);
        //    ImageOption tempVar4 = new ImageOption();
        //    tempVar4.setLimit(0);
        //    tempVar4.setType(ImageType.Art);
        //    ImageOption tempVar5 = new ImageOption();
        //    tempVar5.setLimit(0);
        //    tempVar5.setType(ImageType.Disc);
        //    ImageOption tempVar6 = new ImageOption();
        //    tempVar6.setLimit(1);
        //    tempVar6.setType(ImageType.Primary);
        //    ImageOption tempVar7 = new ImageOption();
        //    tempVar7.setLimit(0);
        //    tempVar7.setType(ImageType.Banner);
        //    ImageOption tempVar8 = new ImageOption();
        //    tempVar8.setLimit(1);
        //    tempVar8.setType(ImageType.Thumb);
        //    ImageOption tempVar9 = new ImageOption();
        //    tempVar9.setLimit(1);
        //    tempVar9.setType(ImageType.Logo);
        //    tempVar2.setImageOptions(new ImageOption[] {tempVar3, tempVar4, tempVar5, tempVar6, tempVar7, tempVar8, tempVar9});
        //    MetadataOptions tempVar10 = new MetadataOptions(1, 1280);
        //    tempVar10.setItemType("MusicVideo");
        //    ImageOption tempVar11 = new ImageOption();
        //    tempVar11.setLimit(1);
        //    tempVar11.setMinWidth(1280);
        //    tempVar11.setType(ImageType.Backdrop);
        //    ImageOption tempVar12 = new ImageOption();
        //    tempVar12.setLimit(0);
        //    tempVar12.setType(ImageType.Art);
        //    ImageOption tempVar13 = new ImageOption();
        //    tempVar13.setLimit(0);
        //    tempVar13.setType(ImageType.Disc);
        //    ImageOption tempVar14 = new ImageOption();
        //    tempVar14.setLimit(1);
        //    tempVar14.setType(ImageType.Primary);
        //    ImageOption tempVar15 = new ImageOption();
        //    tempVar15.setLimit(0);
        //    tempVar15.setType(ImageType.Banner);
        //    ImageOption tempVar16 = new ImageOption();
        //    tempVar16.setLimit(1);
        //    tempVar16.setType(ImageType.Thumb);
        //    ImageOption tempVar17 = new ImageOption();
        //    tempVar17.setLimit(1);
        //    tempVar17.setType(ImageType.Logo);
        //    tempVar10.setImageOptions(new ImageOption[] {tempVar11, tempVar12, tempVar13, tempVar14, tempVar15, tempVar16, tempVar17});
        //    MetadataOptions tempVar18 = new MetadataOptions(1, 1280);
        //    tempVar18.setItemType("Series");
        //    ImageOption tempVar19 = new ImageOption();
        //    tempVar19.setLimit(1);
        //    tempVar19.setMinWidth(1280);
        //    tempVar19.setType(ImageType.Backdrop);
        //    ImageOption tempVar20 = new ImageOption();
        //    tempVar20.setLimit(0);
        //    tempVar20.setType(ImageType.Art);
        //    ImageOption tempVar21 = new ImageOption();
        //    tempVar21.setLimit(1);
        //    tempVar21.setType(ImageType.Primary);
        //    ImageOption tempVar22 = new ImageOption();
        //    tempVar22.setLimit(1);
        //    tempVar22.setType(ImageType.Banner);
        //    ImageOption tempVar23 = new ImageOption();
        //    tempVar23.setLimit(1);
        //    tempVar23.setType(ImageType.Thumb);
        //    ImageOption tempVar24 = new ImageOption();
        //    tempVar24.setLimit(1);
        //    tempVar24.setType(ImageType.Logo);
        //    tempVar18.setImageOptions(new ImageOption[] {tempVar19, tempVar20, tempVar21, tempVar22, tempVar23, tempVar24});
        //    MetadataOptions tempVar25 = new MetadataOptions(1, 1280);
        //    tempVar25.setItemType("MusicAlbum");
        //    ImageOption tempVar26 = new ImageOption();
        //    tempVar26.setLimit(0);
        //    tempVar26.setMinWidth(1280);
        //    tempVar26.setType(ImageType.Backdrop);
        //    ImageOption tempVar27 = new ImageOption();
        //    tempVar27.setLimit(0);
        //    tempVar27.setType(ImageType.Disc);
        //    tempVar25.setImageOptions(new ImageOption[] {tempVar26, tempVar27});
        //    MetadataOptions tempVar28 = new MetadataOptions(1, 1280);
        //    tempVar28.setItemType("MusicArtist");
        //    ImageOption tempVar29 = new ImageOption();
        //    tempVar29.setLimit(1);
        //    tempVar29.setMinWidth(1280);
        //    tempVar29.setType(ImageType.Backdrop);
        //    ImageOption tempVar30 = new ImageOption();
        //    tempVar30.setLimit(0);
        //    tempVar30.setType(ImageType.Banner);
        //    ImageOption tempVar31 = new ImageOption();
        //    tempVar31.setLimit(0);
        //    tempVar31.setType(ImageType.Art);
        //    ImageOption tempVar32 = new ImageOption();
        //    tempVar32.setLimit(0);
        //    tempVar32.setType(ImageType.Logo);
        //    tempVar28.setImageOptions(new ImageOption[] {tempVar29, tempVar30, tempVar31, tempVar32});
        //    MetadataOptions tempVar33 = new MetadataOptions(1, 1280);
        //    tempVar33.setItemType("BoxSet");
        //    ImageOption tempVar34 = new ImageOption();
        //    tempVar34.setLimit(1);
        //    tempVar34.setMinWidth(1280);
        //    tempVar34.setType(ImageType.Backdrop);
        //    ImageOption tempVar35 = new ImageOption();
        //    tempVar35.setLimit(1);
        //    tempVar35.setType(ImageType.Primary);
        //    ImageOption tempVar36 = new ImageOption();
        //    tempVar36.setLimit(1);
        //    tempVar36.setType(ImageType.Thumb);
        //    ImageOption tempVar37 = new ImageOption();
        //    tempVar37.setLimit(1);
        //    tempVar37.setType(ImageType.Logo);
        //    ImageOption tempVar38 = new ImageOption();
        //    tempVar38.setLimit(0);
        //    tempVar38.setType(ImageType.Art);
        //    ImageOption tempVar39 = new ImageOption();
        //    tempVar39.setLimit(0);
        //    tempVar39.setType(ImageType.Disc);
        //    ImageOption tempVar40 = new ImageOption();
        //    tempVar40.setLimit(0);
        //    tempVar40.setType(ImageType.Banner);
        //    tempVar33.setImageOptions(new ImageOption[] {tempVar34, tempVar35, tempVar36, tempVar37, tempVar38, tempVar39, tempVar40});
        //    MetadataOptions tempVar41 = new MetadataOptions(0, 1280);
        //    tempVar41.setItemType("Season");
        //    ImageOption tempVar42 = new ImageOption();
        //    tempVar42.setLimit(0);
        //    tempVar42.setMinWidth(1280);
        //    tempVar42.setType(ImageType.Backdrop);
        //    ImageOption tempVar43 = new ImageOption();
        //    tempVar43.setLimit(1);
        //    tempVar43.setType(ImageType.Primary);
        //    ImageOption tempVar44 = new ImageOption();
        //    tempVar44.setLimit(0);
        //    tempVar44.setType(ImageType.Banner);
        //    ImageOption tempVar45 = new ImageOption();
        //    tempVar45.setLimit(0);
        //    tempVar45.setType(ImageType.Thumb);
        //    tempVar41.setImageOptions(new ImageOption[] {tempVar42, tempVar43, tempVar44, tempVar45});
        //    setMetadataOptions(new MetadataOptions[] {tempVar, tempVar2, tempVar10, tempVar18, tempVar25, tempVar28, tempVar33, tempVar41});
    }
}