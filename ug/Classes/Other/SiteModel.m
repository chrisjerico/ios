//
//  SiteModel.m
//  iOS App Signer
//
//  Created by fish on 2019/11/24.
//  Copyright © 2019 Daniel Radtke. All rights reserved.
//

#import "SiteModel.h"

@implementation SiteModel

+ (NSArray *)sites:(NSString *)siteIds {
    NSMutableArray *temp = @[].mutableCopy;
    for (NSString *siteId in [siteIds componentsSeparatedByString:@","]) {
        [temp addObject:[self modelWithId:siteId]];
    }
    return temp.copy;
}

+ (instancetype)modelWithId:(NSString *)siteId {
    for (SiteModel *sm in [SiteModel allSites]) {
        if ([sm.siteId isEqualToString:siteId])
            return sm;
    }
    return nil;
}

+ (NSArray *)allSites {
    static NSArray *__dataArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SiteModel *(^site)(NSString *, NSString *, NSString *, NSString *, NSString *, NSString *, NSString *) = ^SiteModel *(NSString *siteId, NSString *uploadNum, NSString *uploadId, NSString *appId, NSString *type, NSString *appName, NSString *host) {
            SiteModel *sm = [SiteModel new];
            sm.siteId = siteId;
            sm.type = type;
            sm.appName = appName;
            sm.appId = appId;
            sm.host = host;
            sm.uploadId = uploadId;
            sm.uploadNum = uploadNum;
            return sm;
        };
        // 站点编号 / 上传编号 / 上传ID / 签名方式 / APP名 / bundleID / 接口域名
        __dataArray = @[
                    site(@"a002",        @"无",          @"无",        @"com.UGGame.cp",         @"超级签名",     @"49彩票集团",    @"https://5049uuu.com"),          // https://dev.app2.xin/index | 13265529007 | qaz123
                    site(@"a002a",       @"无",          @"无",       @"io.fhpt.H52A8B80A",      @"超级签名",     @"49彩票集团",       @""),          // https://dev.app2.xin/index | 13265529007 | qaz123
                    site(@"a002b",       @"无",          @"无",       @"io.fhpt.H53D2C0A9",      @"超级签名",     @"49彩票集团",       @""),          // https://dev.app2.xin/index | 13265529007 | qaz123
                    site(@"a002c",       @"无",          @"无",       @"io.fhpt.H5069C7C0",      @"超级签名",     @"49彩票集团",       @""),          // https://dev.app2.xin/index | 13265529007 | qaz123
                    site(@"a002d",       @"无",          @"无",       @"io.fhpt.H5E99F6BB",      @"超级签名",     @"49彩票集团",       @""),          // https://dev.app2.xin/index | 13265529007 | qaz123
                    site(@"a002e",       @"无",          @"无",       @"io.fhpt.H5B2F70A9",      @"超级签名",     @"49彩票集团",       @""),          // https://dev.app2.xin/index | 13265529007 | qaz123
                    site(@"c001",        @"无",          @"无",          @"io.fhpt.H5BAECCD9",   @"超级签名",     @"彩47",             @"https://47c47webappqp.org"),          // https://dev.app2.xin/index | 15697023521 | aa135246
                    site(@"c005",        @"无",          @"无",        @"io.fhpt.H5AD6EE3E",     @"超级签名",     @"乐盈彩票",          @""),          // https://dev.app2.xin/index | 13545990831 | dz990990
                    site(@"c105",        @"无",          @"无",        @"",                      @"超级签名",     @"澳⻔彩票",              @""),          // https://dev.app2.xin/index | 15542484889 | aa168168
                    site(@"c114",        @"无",          @"无",          @"",                    @"超级签名",     @"彩43",               @""),          // https://dev.app2.xin/index | 19859553001 | wenxiang123123
                    site(@"c190",        @"无",          @"无",         @"",                     @"超级签名",     @"22333彩世界",           @""),          // https://dev.app2.xin/index |  |
                    site(@"h002",        @"无",          @"无",       @"",                      @"超级签名",     @"⾹港赛⻢会",              @""),          // https://dev.app2.xin/index | 15827947817 | dz990990
                    site(@"c201",        @"无",          @"无",        @"io.fhpt.YSFC201",       @"超级签名",     @"大咖彩票",        @"https://dkcp520.com"),          //https://dev.app2.xin/index | 18675958156 | dk789789
                    site(@"c048",        @"无",          @"无",        @"io.fhpt.H5F00A9FA",     @"超级签名",     @"凤凰国际",          @"https://dsjf43-43-f14-345-36-g54t-gfh54.com"),

                    
                    site(@"c018",        @"",        @"",        @"io.fhpt.H51E9BFB6",         @"企业包",     @"2044彩票",    @"https://204421.com"),
                    site(@"c021",        @"",        @"",      @"io.fhpt.H5A730C2F",            @"企业包",     @"幸运彩票",      @""),
                    site(@"c028",        @"",        @"",      @"io.fhpt.H5DBF1426",            @"企业包",     @"鳳凰彩票",      @""),
                    site(@"c053",        @"",        @"",        @"io.fhpt.H563009C8",          @"企业包",     @"彩53",        @"https://988c53.com"),  // 已上架
                    site(@"c062",        @"",        @"",      @"io.fhpt.H5AF9FDA4",            @"企业包",     @"六合彩票",       @""),
                    site(@"c067",        @"",        @"",      @"io.fhpt.H59B0EF77",            @"企业包",     @"乐盈彩票",      @""),
                    site(@"c068",        @"",        @"",      @"io.fhpt.H5E98EDD5",            @"企业包",     @"⾦牌⼿游",      @""),
                    site(@"c069",        @"",        @"",       @"io.fhpt.H5CC54076",          @"企业包",     @"360⼿游",      @""),
                    site(@"c074",        @"",        @"",        @"io.fhpt.H5016B05F",         @"企业包",     @"5360彩票",    @""),
                    site(@"c076",        @"",        @"",        @"io.fhpt.H59A95B9B",          @"企业包",     @"彩98",       @""),
                    site(@"c080",        @"",        @"",       @"io.fhpt.H5C82F72A",          @"企业包",     @"007彩票",      @""),
                    site(@"c085",        @"",        @"",       @"io.fhpt.H53F348DC",          @"企业包",     @"彩壹万",        @"https://xn--10app-308h91u.com"),//已上架
                    site(@"c085a",       @"",       @"",       @"",                           @"企业包",     @"彩壹万",            @"https://c10000ll.com"),
                    site(@"c117",        @"",        @"",          @"io.fhpt.H5AAB211E",       @"企业包",     @"50.CC彩票⽹",    @""),
                    site(@"c125",        @"",        @"",       @"io.fhpt.H52CD2820",           @"企业包",     @"财神彩票",      @""),
                    site(@"c131",        @"",        @"",          @"io.fhpt.H51B87207",        @"企业包",     @"5000万娱乐城",   @""),
                    site(@"c134",        @"",        @"",          @"io.fhpt.H5B711E9A",        @"企业包",     @"1997⾹港彩票",   @"https://19972030.com"),
                    site(@"c137",        @"",        @"",           @"io.fhpt.H5B75458D",      @"企业包",     @"7033彩票",       @"https://7033005.com"),
                    site(@"c141",        @"",        @"",       @"io.fhpt.H57BED93A",           @"企业包",     @"新华彩票",      @"https://xhcp123.cc"),
                    site(@"c142",        @"",        @"",          @"io.fhpt.H56F6EA3C",        @"企业包",     @"2058开元棋牌",   @""),
                    site(@"c150",        @"",        @"",         @"io.fhpt.H5CDDC97E",        @"企业包",     @"0187彩票⽹",    @"https://0187677.com"),
                    site(@"c151",        @"",        @"",       @"io.fhpt.H5ADDD837",          @"企业包",     @"澳⻔新葡京",      @"https://xpj501501401401.vip"),
                    site(@"c153",        @"",        @"",      @"io.fhpt.H504175BD",            @"企业包",     @"亚博彩票",      @"https://yb247.cn"),
                    site(@"c154",        @"",        @"",        @"io.fhpt.H5DFB9358",         @"企业包",     @"吉祥彩",       @""),
                    site(@"c155",        @"",        @"",        @"io.fhpt.H5B45C43F",         @"企业包",     @"405彩票",      @""),
                    site(@"c156",        @"",        @"",         @"io.fhpt.H5BEC1764",        @"企业包",     @"速8彩票",       @""),
                    site(@"c157",        @"",        @"",       @"io.fhpt.H5988B005",          @"企业包",     @"中国福彩⽹",    @""),
                    site(@"c158",        @"",        @"",        @"io.fhpt.H5E995A19",         @"企业包",     @"9055彩票",      @"https://9055188.com"),
                    site(@"c161",        @"",        @"",      @"io.fhpt.H59B7B2EB",            @"企业包",     @"⾦沙彩票",      @""),
                    site(@"c162",        @"",        @"",      @"io.fhpt.H5BE95010",            @"企业包",     @"畅玩彩票",       @""),
                    site(@"c163",        @"",        @"",       @"io.fhpt.H59BF8829",           @"企业包",     @"彩91",        @"https://c91398.com"),
                    site(@"c164",        @"",        @"",      @"io.fhpt.H57955107",            @"企业包",     @"⼴州彩票",       @""),
                    site(@"c165",        @"",        @"",      @"io.fhpt.H57D82AEF",            @"企业包",     @"天天彩票",      @"https://1875006.com"),
                    site(@"c166",        @"",        @"",       @"io.fhpt.H5B345FC4",          @"企业包",     @"88彩票",         @""),
                    site(@"c169",        @"",        @"",       @"io.fhpt.H529081C9",          @"企业包",     @"太阳城集团",       @""),
                    site(@"c172",        @"",        @"",        @"io.fhpt.H5534F908",          @"企业包",     @"凤凰彩票",       @""),
                    site(@"c173",        @"",        @"",      @"io.fhpt.H50900911",            @"企业包",     @"东⽅集团",       @"https://www.dfjt1.com"),
                    site(@"c175",        @"",        @"",       @"io.fhpt.H57F31D1D",          @"企业包",     @"太阳城集团",      @"https://7053i.com"), // 已上架
                    site(@"c177",        @"",        @"",      @"io.fhpt.H5B410AF8",            @"企业包",     @"联众彩票",       @"https://lzcp11.com"),
                    site(@"c178",        @"",        @"",      @"io.fhpt.H54810967",            @"企业包",     @"百度彩票",       @""),
                    site(@"c182",        @"",        @"",       @"io.fhpt.H55A3FE0A",          @"企业包",     @"澳⻔⼤世界",      @""),
                    site(@"c183",        @"",        @"",      @"io.fhpt.H5C20B434",            @"企业包",     @"五洲国际",        @""),
                    site(@"c185",        @"",        @"",       @"io.fhpt.H50BFF911",          @"企业包",     @"太阳城集团",        @""),
                    site(@"c189",        @"",        @"",       @"io.fhpt.H53C0C63D",          @"企业包",     @"地球⼈",         @""),
                    site(@"c225",        @"",        @"",        @"io.fhpt.H50A96411",         @"企业包",     @"51彩票",           @""),
                    site(@"c002",        @"",        @"",       @"io.fhpt.YSAC002",            @"企业包",     @"永利彩世界",      @"https://154977.com"), // io.dcloud.UNIE955DDC（新增的第三方改签由于频繁掉签已弃用）
                    site(@"c091",        @"",        @"",      @"io.fhpt.H5691A751",            @"企业包",     @"凤凰彩票",          @"https://83f9.com"),
                    site(@"c084",        @"",        @"",      @"io.fhpt.H599DB7B9",           @"企业包",     @"新2彩票",           @"https://papghawshugposwaughwsoohu.com"),
                    site(@"c049",        @"",        @"",      @"com.xinshiji2.yuansheng",      @"企业包",     @"新世纪Ⅱ",         @"https://93922app.com"),
                    site(@"c011",        @"",        @"",      @"io.fhpt.H599FF71F",            @"企业包",     @"华夏彩票",           @"https://www.hx627.com"), // 已上架
                    site(@"c012",        @"",        @"",        @"io.fhpt.H5F0B8A01",        @"企业包",     @"8号彩票",     @"https://20180849.com"),
                    site(@"c022",        @"",        @"",        @"io.fhpt.H53EC1170",        @"企业包",     @"68彩票",     @""),
                    site(@"c039",        @"",        @"",        @"io.fhpt.H5C117128",        @"企业包",     @"汇丰彩票",     @""),
                    site(@"c041",        @"",        @"",       @"io.fhpt.H5AB7911E",         @"企业包",     @"福彩⽹",     @""),
                    site(@"c073",        @"",        @"",         @"io.fhpt.H5AECD773",       @"企业包",     @"彩73",       @"https://c73hbs.com"),
                    site(@"c077",        @"",        @"",         @"io.fhpt.H5167664E",       @"企业包",     @"彩95",       @""),
                    site(@"c078",        @"",        @"",        @"io.fhpt.H5E99DB2C",        @"企业包",     @"彩333",     @""),
                    site(@"c087",        @"",        @"",         @"io.fhpt.H59A5D767",       @"企业包",     @"易购",        @""),
                    site(@"c090",        @"",        @"",        @"io.fhpt.H5D6E1F0A",        @"企业包",     @"⾦沙彩票",     @""),
                    site(@"c092",        @"",        @"",          @"io.fhpt.H57B34489",      @"企业包",     @"2013彩票",     @"https://4681kkk.com"),
                    site(@"c115",        @"",        @"",       @"io.fhpt.H59BD7AE3",         @"企业包",     @"中彩⽹",         @""),
                    site(@"c116",        @"",        @"",           @"io.fhpt.H50A85511",     @"企业包",     @"1353彩世界",     @"https://13532007.com/https://88677.cc"),
                    site(@"c126",        @"",        @"",         @"io.fhpt.H5FD4D963",       @"企业包",     @"758彩票",     @""),
                    site(@"c129",        @"",        @"",        @"io.fhpt.H58AE4F87",        @"企业包",     @"万豪彩票",     @"https://7803000.com"),
                    site(@"c601",        @"",        @"",        @"io.fhpt.H5D5F880F",        @"企业包",     @"六合宝典",     @""),
                    site(@"h003",        @"",        @"",        @"io.fhpt.H591E28D0",        @"企业包",     @"华为彩票",     @""),
                    site(@"c139",        @"",        @"",         @"io.fhpt.H536040A9",       @"企业包",     @"68中彩⽹",     @""),
                    site(@"c186",        @"",        @"",       @"io.fhpt.H5B2B56F7",         @"企业包",     @"好彩⽹",         @""),
                    site(@"c192",        @"",        @"",        @"io.fhpt.H56438C9F",        @"企业包",     @"凤凰彩票",     @"https://103079.com"),
                    site(@"c194",        @"",        @"",        @"io.dcloud.UNI42C6822",     @"企业包",     @"好彩国际",        @"https://hc16324app95712gj5168168app.com"),
                    site(@"c184",        @"",        @"",        @"io.fhpt.H5A6D1720",        @"企业包",     @"凤凰彩票",     @"https://0fhcp.cn"),
                    site(@"c015",        @"",        @"",          @"io.fhpt.H52FC720A",     @"企业包",     @"奖多多",         @""),
                    site(@"c035",        @"",        @"",        @"io.fhpt.H5D70A94D",        @"企业包",     @"凤凰彩票",     @"https://5504707.com"),
                    site(@"c047",        @"",        @"",        @"io.fhpt.H539296B3",       @"企业包",     @"新2彩票",      @"https://x22xxx.com"),
                    site(@"c052",        @"",        @"",        @"io.fhpt.H5ED6D043",        @"企业包",     @"天天彩票",     @""),
                    site(@"c054",        @"",        @"",        @"io.fhpt.H5CBD9DE0",        @"企业包",     @"⾹港国际",     @"https://666mv.cc"),
                    site(@"c108",        @"",        @"",         @"io.fhpt.H53779C0A",      @"企业包",     @"葡京娱乐场",      @"https://823653.com"),
                    site(@"c132",        @"",        @"",         @"io.fhpt.H504F0A93",      @"企业包",     @"彩霸王",        @""),
                    site(@"c193",        @"",        @"",         @"io.fhpt.H54C32CA8",      @"企业包",     @"新葡京彩票",      @"https://4906app.app"),
                    site(@"c200",        @"",        @"",            @"io.fhpt.H5830E440",    @"企业包",     @"1995澳门彩票",     @"https://20191995.com"),
                    site(@"c202",        @"",        @"",         @"io.fhpt.YSAC202",         @"企业包",     @"大发彩票",        @"https://895911.com"),
                    site(@"c120",        @"",        @"",         @"io.fhpt.H591E28D0",      @"企业包",     @"新葡京彩票",      @"https://asafew435yrtgre.net"),
                    site(@"c018a",       @"",       @"",        @"io.fhpt.H53DDB5F6",        @"企业包",     @"今⽇彩票",        @""),
                    site(@"c018b",       @"",       @"",        @"io.fhpt.H504390D9",        @"企业包",     @"彩聊",          @""),
                    site(@"b001",        @"",        @"",      @"io.fhpt.H5BC63A97",          @"企业包",     @"优选彩票",      @""),
                    site(@"c006",        @"",        @"",      @"io.fhpt.H560B7EC1",          @"企业包",     @"⾦沙娱乐场",     @"https://xn--app-v85fh28j.com"),
                    site(@"c036",        @"",        @"",      @"io.fhpt.H5570A960",          @"企业包",     @"幸运彩票",      @""),
                    site(@"c070",        @"",        @"",       @"io.fhpt.H55ED7A0B",         @"企业包",     @"K8娱乐城",      @""),
                    site(@"c106",        @"",        @"",          @"io.fhpt.H5580AADE",      @"企业包",     @"58彩票",          @""),
                    site(@"c112",        @"",        @"",      @"io.fhpt.H5E0A94E1",          @"企业包",     @"太阳城集团",     @""),
                    site(@"c089",        @"",        @"",          @"",                       @"企业包",     @"彩89",                @""),
                    site(@"c171",        @"",        @"",        @"",                         @"企业包",     @"CC彩票-默认",        @""),
                    site(@"c171",        @"",        @"",          @"",                       @"企业包",     @"CC彩票",                @""),
                    site(@"c171a",       @"",       @"",          @"",                       @"企业包",     @"CC彩票",                @""),
                    site(@"c171b",       @"",       @"",          @"",                       @"企业包",     @"CC彩票",                @""),
                    site(@"c171c",       @"",       @"",          @"",                       @"企业包",     @"CC彩票",                @""),
                    site(@"c171d",       @"",       @"",          @"",                       @"企业包",     @"CC彩票",                @""),
                    site(@"c171e",       @"",       @"",         @"",                        @"企业包",     @"CC彩票-默认包",         @""),
                    site(@"c197",        @"",        @"",          @"io.fhpt.H52622B1F",      @"企业包",     @"太阳城官⽹",            @"https://tycgw3.com"),
                    site(@"c198",        @"",        @"",          @"io.fhpt.H53E43223",      @"企业包",     @"太阳城集团",           @"https://2909tycjt.com"),
                    site(@"h003a",       @"",       @"",       @"io.fhpt.H554013D2",          @"企业包",     @"澳⻔威尼斯⼈",       @""),
                    site(@"c008",        @"",        @"",           @"",                      @"企业包",     @"",                      @"https://888123app.com"),
                    site(@"c130",        @"",        @"",       @"io.fhpt.H5A94011E",         @"企业包",     @"必发彩票",           @""),
                    site(@"c136",        @"",        @"",       @"io.fhpt.H5F60C8D2",         @"企业包",     @"⻓诚彩票",              @""),
                    
                    
                    site(@"test10",      @"88",            @"125",        @"com.UGGame.cp",      @"内测包",     @"test10",        @"http://test10.6yc.com"),
                    site(@"c083",        @"",        @"",        @"com.UGGame.cp",       @"内测包",     @"c083测试",       @"http://t111f.fhptcdn.com"),
                    site(@"test100",     @"",     @"",         @"com.UGGame.cp",     @"内测包",     @"test100",        @"http://test100f.fhptcdn.com"),
                    site(@"t032",        @"",        @"",         @"com.UGGame.cp",     @"内测包",     @"t032",           @"http://t005f.fhptcdn.com"),     // (老虎)
                    site(@"test20",      @"",      @"",        @"com.UGGame.cp",      @"内测包",     @"test20",        @"http://test20.6yc.com"),    // (朗朗)
                    site(@"test29",      @"",      @"",        @"com.UGGame.cp",      @"内测包",     @"test29",        @"http://test29f.fhptcdn.com"),// (小东)
                    site(@"test19",      @"",      @"",        @"com.UGGame.cp",      @"内测包",     @"test19",        @"http://test19.6yc.com"),
                    site(@"test31",      @"",      @"",        @"com.UGGame.cp",      @"内测包",     @"test31",        @"http://test31.6yc.com"),
                ];
    });
    return __dataArray;
}

@end
