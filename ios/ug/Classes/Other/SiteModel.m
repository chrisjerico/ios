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
        SiteModel *(^site)(NSString *, NSString *, NSString *, NSString *, NSString *, NSString *, NSString *) = ^SiteModel *(NSString *siteId, NSString *uploadNum, NSString *uploadId, NSString *appId, NSString *host, NSString *type, NSString *appName) {
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
            site(@"a002",        @"a002hy",     @"129",     @"com.UGGame.cp",           @"https://5049uuu.com",                         @"超级签名",    @"49彩票集团"),          // https://dev.app2.xin/index | 13265529007 | qaz123
            site(@"a002a",       @"",           @"",        @"io.fhpt.H52A8B80A",       @"",                                            @"超级签名",    @"49彩票集团"),          // https://dev.app2.xin/index | 13265529007 | qaz123
            site(@"a002b",       @"",           @"",        @"io.fhpt.H53D2C0A9",       @"",                                            @"超级签名",    @"49彩票集团"),          // https://dev.app2.xin/index | 13265529007 | qaz123
            site(@"a002c",       @"",           @"",        @"io.fhpt.H5069C7C0",       @"",                                            @"超级签名",    @"49彩票集团"),          // https://dev.app2.xin/index | 13265529007 | qaz123
            site(@"a002d",       @"",           @"",        @"io.fhpt.H5E99F6BB",       @"",                                            @"超级签名",    @"49彩票集团"),          // https://dev.app2.xin/index | 13265529007 | qaz123
            site(@"a002e",       @"",           @"",        @"io.fhpt.H5B2F70A9",       @"",                                            @"超级签名",    @"49彩票集团"),          // https://dev.app2.xin/index | 13265529007 | qaz123
            site(@"c001",        @"c001hy",     @"130",     @"io.fhpt.H5BAECCD9",       @"https://47c47webappqp.org",                   @"超级签名",    @"彩47"),          // https://dev.app2.xin/index | 15697023521 | aa135246
            site(@"c005",        @"c005hy",     @"180",     @"io.fhpt.H5AD6EE3E",       @"",                                            @"超级签名",    @"乐盈彩票"),          // https://dev.app2.xin/index | 13545990831 | dz990990
            site(@"c105",        @"",           @"",        @"",                        @"",                                            @"超级签名",    @"澳⻔彩票"),          // https://dev.app2.xin/index | 15542484889 | aa168168
            site(@"c114",        @"c114hy",     @"157",     @"",                        @"",                                            @"超级签名",    @"彩43"),          // https://dev.app2.xin/index | 19859553001 | wenxiang123123
            site(@"c190",        @"c190hy",     @"167",     @"io.fhpt.H5F40948F",       @"http://fhylofc190nyvqo.playslot8.com",        @"超级签名",    @"22333彩世界"),          // https://dev.app2.xin/index 账号：15559931943   密码：qwert12345
            site(@"c201",        @"c201hy",     @"213",     @"io.fhpt.YSFC201",         @"https://dkcp520.com",                         @"超级签名",    @"大咖彩票"),          //https://dev.app2.xin/index | 18675958156 | dk789789
            site(@"c048",        @"c048hy",     @"133",     @"io.fhpt.H5F00A9FA",       @"https://dsjf43-43-f14-345-36-g54t-gfh54.com", @"超级签名",    @"凤凰国际"),//用户15687374617  密码   qaz123123  超级苹果签
            site(@"l001",        @"l001hy",     @"218",     @"io.fhpt.YSFL001",         @"https://4988wap.com",                         @"超级签名",    @"六合宝典"),//激光账号，qazttcp@gmail.com 密码 ttcp2075ZXCs  ISO 超级签 18759487805    ZXC4988tianji
            
            site(@"l002",        @"l002hy",     @"239",     @"io.fhpt.YSAL002",         @"http://70333.me",                             @"企业包",     @" 王中王"),//
            site(@"h002",        @"",           @"",        @"",                        @"",                                            @"企业包",     @"⾹港赛⻢会"),          // https://dev.app2.xin/index | 15827947817 | dz990990
            site(@"h005",        @"h005hy",     @"236",     @"io.fhpt.YSAH005",         @"https://534023.com",                          @"企业包",     @"开心红包"),
            site(@"c018",        @"c018hy",     @"174",     @"io.fhpt.H51E9BFB6",       @"https://www.2044234.com",                     @"企业包",     @"2044彩票"),
            site(@"c021",        @"",           @"",        @"io.fhpt.H5A730C2F",       @"",                                            @"企业包",     @"幸运彩票"),
            site(@"c028",        @"",           @"",        @"io.fhpt.H5DBF1426",       @"",                                            @"企业包",     @"鳳凰彩票"),
            site(@"c053",        @"c053ys",     @"152",     @"io.fhpt.H563009C8",       @"https://988c53.com",                          @"企业包",     @"彩53"),  // 极光 账号：xuduoduo2018402@gmail.com 密码：Xusiling2018402.| 封装是超级签名 https://dev.app2.xin/index  账号：14779887196  密码：Xusiling2018402
            site(@"c062",        @"c062hy",     @"153",     @"io.fhpt.H5AF9FDA4",       @"",                                            @"企业包",     @"六合彩票"),
            site(@"c067",        @"",           @"",        @"io.fhpt.H59B0EF77",       @"",                                            @"企业包",     @"乐盈彩票"),
            site(@"c068",        @"",           @"",        @"io.fhpt.H5E98EDD5",       @"",                                            @"企业包",     @"⾦牌⼿游"),
            site(@"c069",        @"",           @"",        @"io.fhpt.H5CC54076",       @"",                                            @"企业包",     @"360⼿游"),
            site(@"c074",        @"c074hy",     @"154",     @"io.fhpt.H5016B05F",       @"",                                            @"企业包",     @"5360彩票"),
            site(@"c076",        @"",           @"",        @"io.fhpt.H59A95B9B",       @"",                                            @"企业包",     @"彩98"),
            site(@"c080",        @"",           @"",        @"io.fhpt.H5C82F72A",       @"",                                            @"企业包",     @"007彩票"),
            site(@"c085",        @"c085",       @"114",     @"io.fhpt.H53F348DC",       @"https://c10000ll.com",                        @"企业包",     @"彩壹万"),//已上架    https://c10000ll.com  https://xn--10app-308h91u.com
            site(@"c085a",       @"",           @"",        @"",                        @"https://c10000ll.com",                        @"企业包",     @"彩壹万"),
            site(@"c117",        @"",           @"",        @"io.fhpt.H5AAB211E",       @"",                                            @"企业包",     @"50.CC彩票⽹"),
            site(@"c125",        @"",           @"",        @"io.fhpt.H52CD2820",       @"",                                            @"企业包",     @"财神彩票"),
            site(@"c131",        @"",           @"",        @"io.fhpt.H51B87207",       @"",                                            @"企业包",     @"5000万娱乐城"),
            site(@"c134",        @"c134hy",     @"142",     @"io.fhpt.H5B711E9A",       @"https://19972030.com",                        @"企业包",     @"1997⾹港彩票"),
            site(@"c137",        @"c137hy",     @"158",     @"io.fhpt.H5B75458D",       @"https://7033005.com",                         @"企业包",     @"7033彩票"),
            site(@"c141",        @"c141hy",     @"143",     @"io.fhpt.H57BED93A",       @"https://xhcp123.cc",                          @"企业包",     @"新华彩票"),
            site(@"c142",        @"",           @"",        @"io.fhpt.H56F6EA3C",       @"",                                            @"企业包",     @"2058开元棋牌"),
            site(@"c150",        @"c150hy",     @"179",     @"io.fhpt.H5CDDC97E",       @"https://0187488.com",                         @"企业包",     @"0187彩票⽹"),
            site(@"c151",        @"c151hy",     @"144",     @"io.fhpt.H5ADDD837",       @"https://xpj501501401401.vip",                 @"企业包",     @"澳⻔新葡京"),//极光账号 账号：  yunanfu11@163.com   密码 ：  Aa556688
            site(@"c153",        @"c153hy",     @"145",     @"io.fhpt.H504175BD",       @"https://yb247.cn",                            @"企业包",     @"亚博彩票"),
            site(@"c154",        @"",           @"",        @"io.fhpt.H5DFB9358",       @"",                                            @"企业包",     @"吉祥彩"),
            site(@"c155",        @"",           @"",        @"io.fhpt.H5B45C43F",       @"",                                            @"企业包",     @"405彩票"),
            site(@"c156",        @"",           @"",        @"io.fhpt.H5BEC1764",       @"",                                            @"企业包",     @"速8彩票"),
            site(@"c157",        @"",           @"",        @"io.fhpt.H5988B005",       @"",                                            @"企业包",     @"中国福彩⽹"),
            site(@"c158",        @"c158hy",     @"159",     @"io.fhpt.H5E995A19",       @"https://9055188.com",                         @"企业包",     @"9055彩票"),
            site(@"c161",        @"",           @"",        @"io.fhpt.H59B7B2EB",       @"",                                            @"企业包",     @"⾦沙彩票"),
            site(@"c162",        @"",           @"",        @"io.fhpt.H5BE95010",       @"",                                            @"企业包",     @"畅玩彩票"),
            site(@"c163",        @"c163hy",     @"160",     @"io.fhpt.H59BF8829",       @"https://c91398.com",                          @"企业包",     @"彩91"),
            site(@"c164",        @"",           @"",        @"io.fhpt.H57955107",       @"",                                            @"企业包",     @"⼴州彩票"),
            site(@"c165",        @"c165hy",     @"146",     @"io.fhpt.H57D82AEF",       @"https://1875006.com",                         @"企业包",     @"天天彩票"),
            site(@"c166",        @"c166hy",     @"161",     @"io.fhpt.H5B345FC4",       @"",                                            @"企业包",     @"88彩票"),
            site(@"c169",        @"c169hy",     @"162",     @"io.fhpt.H529081C9",       @"http://heixxqic169cqhmszw.playzone88.com",    @"企业包",     @"太阳城集团"),
            site(@"c172",        @"",           @"",        @"io.fhpt.H5534F908",       @"",                                            @"企业包",     @"凤凰彩票"),
            site(@"c173",        @"c173hy",     @"147",     @"io.fhpt.H50900911",       @"https://www.dfjt1.com",                       @"企业包",     @"东⽅集团"),
            site(@"c175",        @"c175",       @"38",      @"io.fhpt.H57F31D1D",       @"https://7053i.com",                           @"企业包",     @"太阳城集团"), // 已上架
            site(@"c177",        @"c177hy",     @"163",     @"io.fhpt.H5B410AF8",       @"https://lzcp11.com",                          @"企业包",     @"联众彩票"),
            site(@"c178",        @"",           @"",        @"io.fhpt.H54810967",       @"",                                            @"企业包",     @"百度彩票"),
            site(@"c182",        @"",           @"",        @"io.fhpt.H55A3FE0A",       @"",                                            @"企业包",     @"澳⻔⼤世界"),
            site(@"c183",        @"",           @"",        @"io.fhpt.H5C20B434",       @"",                                            @"企业包",     @"五洲国际"),
            site(@"c185",        @"",           @"",        @"io.fhpt.H50BFF911",       @"",                                            @"企业包",     @"太阳城集团"),
            site(@"c189",        @"",           @"",        @"io.fhpt.H53C0C63D",       @"",                                            @"企业包",     @"地球⼈"),
            site(@"c225",        @"",           @"",        @"io.fhpt.H50A96411",       @"",                                            @"企业包",     @"51彩票"),
            site(@"c002",        @"c002hy",     @"173",     @"io.fhpt.YSAC002",         @"https://154977.com",                          @"企业包",     @"永利彩世界"),
            site(@"c091",        @"c091hy",     @"137",     @"io.fhpt.H5691A751",       @"https://83f9.com",                            @"企业包",     @"凤凰彩票"),
            site(@"c084",        @"c084hy",     @"136",     @"io.fhpt.H599DB7B9",       @"https://papghawshugposwaughwsoohu.com",       @"企业包",     @"新2彩票"),//极光 jiguangx2c@gmail.com Qwe741123
            site(@"c049",        @"c049hy",     @"190",     @"com.xinshiji2.yuansheng1",@"https://93922app.com",                        @"企业包",     @"新世纪Ⅱ"),
            site(@"c011",        @"c011hy",     @"184",     @"io.fhpt.H599FF71F",       @"https://www.hx627.com",                       @"企业包",     @"华夏彩票"), // 已上架
            site(@"c012",        @"c012hy",     @"170",     @"io.fhpt.H5F0B8A01",       @"https://20180849.com",                        @"企业包",     @"8号彩票"),
            site(@"c022",        @"",           @"",        @"io.fhpt.H53EC1170",       @"",                                            @"企业包",     @"68彩票"),
            site(@"c039",        @"c039hy",     @"150",     @"io.fhpt.H5C117128",       @"",                                            @"企业包",     @"汇丰彩票"),
            site(@"c041",        @"c041hy",     @"131",     @"io.fhpt.H5AB7911E",       @"",                                            @"企业包",     @"福彩⽹"),
            site(@"c073",        @"c073hy",     @"135",     @"io.fhpt.H5AECD773",       @"https://c73hbs.com",                          @"企业包",     @"彩73"),
            site(@"c077",        @"",           @"",        @"io.fhpt.H5167664E",       @"",                                            @"企业包",     @"彩95"),
            site(@"c078",        @"",           @"",        @"io.fhpt.H5E99DB2C",       @"",                                            @"企业包",     @"彩333"),
            site(@"c087",        @"c087hy",     @"155",     @"io.fhpt.H59A5D767",       @"",                                            @"企业包",     @"易购"),
            site(@"c090",        @"c090hy",     @"176",     @"io.fhpt.H5D6E1F0A",       @"",                                            @"企业包",     @"⾦沙彩票"),
            site(@"c092",        @"c092hy",     @"156",     @"io.fhpt.H57B34489",       @"https://4681kkk.com",                         @"企业包",     @"2013彩票"),
            site(@"c115",        @"",           @"",        @"io.fhpt.H59BD7AE3",       @"",                                            @"企业包",     @"中彩⽹"),
            site(@"c116",        @"c116hy",     @"139",     @"io.fhpt.H50A85511",       @"https://13531995.com",       @"企业包",     @"1353彩世界"),
            site(@"c126",        @"",           @"",        @"io.fhpt.H5FD4D963",       @"",                                            @"企业包",     @"758彩票"),
            site(@"c129",        @"c129hy",     @"141",     @"io.fhpt.H58AE4F87",       @"https://7803000.com",                         @"企业包",     @"万豪彩票"),
            site(@"c601",        @"",           @"",        @"io.fhpt.H5D5F880F",       @"",                                            @"企业包",     @"六合宝典"),
            site(@"h003",        @"",           @"",        @"io.fhpt.H591E28D0",       @"",                                            @"企业包",     @"华为彩票"),
            site(@"c139",        @"",           @"",        @"io.fhpt.H536040A9",       @"",                                            @"企业包",     @"68中彩⽹"),
            site(@"c186",        @"",           @"",        @"io.fhpt.H5B2B56F7",       @"",                                            @"企业包",     @"好彩⽹"),
            site(@"c192",        @"c192hy",     @"166",     @"io.fhpt.H56438C9F",       @"https://103079.com",                          @"企业包",     @"凤凰彩票"),
            site(@"c194",        @"194hy",      @"177",     @"io.dcloud.UNI42C6822",    @"https://hc16324app95712gj5168168app.com",     @"企业包",     @"好彩国际"),
            site(@"c184",        @"c184hy",     @"149",     @"io.fhpt.H5A6D1720",       @"https://0fhcp.cn",                            @"企业包",     @"凤凰娱乐"),
            site(@"c015",        @"",           @"",        @"io.fhpt.H52FC720A",       @"",                                            @"企业包",     @"奖多多"),
            site(@"c035",        @"c035hy",     @"169",     @"io.fhpt.H5D70A94D",       @"https://5504707.com",                         @"企业包",     @"凤凰彩票"),
            site(@"c047",        @"c047hy",     @"132",     @"io.fhpt.H539296B3",       @"https://x22xxx.com",                          @"企业包",     @"新2彩票"),
            site(@"c052",        @"",           @"",        @"io.fhpt.H5ED6D043",       @"",                                            @"企业包",     @"天天彩票"),
            site(@"c054",        @"c054hy",     @"134",     @"io.fhpt.H5CBD9DE0",       @"https://666mv.cc",                            @"企业包",     @"⾹港国际"),
            site(@"c108",        @"c108hy",     @"138",     @"io.fhpt.H53779C0A",       @"https://823653.com",                          @"企业包",     @"葡京娱乐场"),
            site(@"c132",        @"",           @"",        @"io.fhpt.H504F0A93",       @"",                                            @"企业包",     @"彩霸王"),
            site(@"c193",        @"c193hy",     @"204",     @"io.fhpt.H54C32CA8",       @"https://4906app.app",                         @"企业包",     @"新葡京彩票"),
            site(@"c200",        @"c200hy",     @"183",     @"io.fhpt.H5830E440",       @"https://20191995.com",                        @"企业包",     @"1995澳门彩票"),
            site(@"c202",        @"c202hy",     @"215",     @"io.fhpt.YSAC202",         @"https://827966.com/",                         @"企业包",     @"大发彩票"),
            site(@"c120",        @"c120hy",     @"140",     @"io.fhpt.H591E28D0",       @"https://asafew435yrtgre.net",                 @"企业包",     @"新葡京彩票"),
            site(@"c018a",       @"",           @"",        @"io.fhpt.H53DDB5F6",       @"",                                            @"企业包",     @"今⽇彩票"),
            site(@"c018b",       @"",           @"",        @"io.fhpt.H504390D9",       @"",                                            @"企业包",     @"彩聊"),
            site(@"b001",        @"",           @"",        @"io.fhpt.H5BC63A97",       @"",                                            @"企业包",     @"优选彩票"),
            site(@"c006",        @"c006hy",     @"151",     @"io.fhpt.H560B7EC1",       @"https://xn--app-v85fh28j.com",                @"企业包",     @"⾦沙娱乐场"),
            site(@"c036",        @"",           @"",        @"io.fhpt.H5570A960",       @"",                                            @"企业包",     @"幸运彩票"),
            site(@"c070",        @"",           @"",        @"io.fhpt.H55ED7A0B",       @"",                                            @"企业包",     @"K8娱乐城"),
            site(@"c106",        @"",           @"",        @"io.fhpt.H5580AADE",       @"",                                            @"企业包",     @"58彩票"),
            site(@"c112",        @"",           @"",        @"io.fhpt.H5E0A94E1",       @"",                                            @"企业包",     @"太阳城集团"),
            site(@"c089",        @"",           @"",        @"",                        @"",                                            @"企业包",     @"彩89"),
            site(@"c171",        @"",           @"",        @"",                        @"",                                            @"企业包",     @"CC彩票-默认"),
            site(@"c171",        @"",           @"",        @"",                        @"",                                            @"企业包",     @"CC彩票"),
            site(@"c171a",       @"",           @"",        @"",                        @"",                                            @"企业包",     @"CC彩票"),
            site(@"c171b",       @"",           @"",        @"",                        @"",                                            @"企业包",     @"CC彩票"),
            site(@"c171c",       @"",           @"",        @"",                        @"",                                            @"企业包",     @"CC彩票"),
            site(@"c171d",       @"",           @"",        @"",                        @"",                                            @"企业包",     @"CC彩票"),
            site(@"c171e",       @"",           @"",        @"",                        @"",                                            @"企业包",     @"CC彩票-默认包"),
            site(@"c197",        @"c197hy",     @"175",     @"io.fhpt.H52622B1F",       @"https://tycgw3.com",                          @"企业包",     @"太阳城官⽹"),
            site(@"c198",        @"c198hy",     @"185",     @"io.fhpt.H53E43223",       @"https://2909tycjt.com",                       @"企业包",     @"太阳城集团"),
            site(@"h003a",       @"",           @"",        @"io.fhpt.H554013D2",       @"",                                            @"企业包",     @"澳⻔威尼斯⼈"),
            site(@"c008",        @"c008hy",     @"217",     @"io.fhpt.YSFC008",         @"https://888123app.com",                       @"企业包",     @"888彩票"),//极光 bghguiyg@163.com qwe5794124A
            site(@"c130",        @"",           @"",        @"io.fhpt.H5A94011E",       @"",                                            @"企业包",     @"必发彩票"),
            site(@"c136",        @"",           @"",        @"io.fhpt.H5F60C8D2",       @"",                                            @"企业包",     @"⻓诚彩票"),
            site(@"c199",        @"c199hy",     @"220",     @"io.fhpt.YSAC199",         @"https://yhfhapp.com",                         @"企业包",     @"银河贵宾会"),//https://9587zz.com
            site(@"c203",        @"c203hy",     @"235",     @"io.fhpt.YSFC203",         @"https://xpjcpapp.com",                        @"企业包",     @"新葡京彩票"),// 第二条域名：https://455126.com
            
            
            site(@"test103",     @"test103",    @"222",     @"com.UGGame.cp",           @"http://103.9.230.243",                        @"内测包",     @"test103"),
            site(@"test10",      @"88",         @"125",     @"com.UGGame.cp",           @"http://test10.6yc.com",                       @"内测包",     @"test10"),
            site(@"c083",        @"c083",       @"226",     @"com.UGGame.cp",           @"http://t111f.fhptcdn.com",                    @"内测包",     @"c083测试"),
            site(@"test100",     @"",           @"",        @"com.UGGame.cp",           @"http://test100f.fhptcdn.com",                 @"内测包",     @"test100"),
            site(@"t032",        @"",           @"",        @"com.UGGame.cp",           @"http://t005f.fhptcdn.com",                    @"内测包",     @"t032"),     // (老虎)
            site(@"test03",      @"",           @"",        @"com.UGGame.chat",         @"http://test03.6yc.com",                       @"内测包",     @"test03"),    // (朗朗)
            site(@"test06",      @"",           @"",        @"com.UGGame.chat",         @"http://test06.6yc.com",                       @"内测包",     @"test06"),    // (army)
            site(@"test20",      @"",           @"",        @"com.UGGame.cp",           @"http://test20.6yc.com",                       @"内测包",     @"test20"),    // (朗朗)
            site(@"test29",      @"",           @"",        @"com.UGGame.cp",           @"http://test29f.fhptcdn.com",                  @"内测包",     @"test29"),// (小东)
            site(@"test19",      @"test19",     @"214",     @"com.UGGame.cp",           @"http://test19.6yc.com",                       @"内测包",     @"test19"),
            site(@"test31",      @"",           @"",        @"com.UGGame.cp",           @"http://test31.6yc.com",                       @"内测包",     @"test31"),
            site(@"t005",        @"t005",       @"241",     @"com.UGGame.cp",           @"http://t500f.fhptcdn.com",                    @"内测包",     @"t500"),
            site(@"t500",        @"t500",       @"240",     @"com.UGGame.cp",           @"http://t500f.fhptcdn.com",                    @"内测包",     @"t500"),
            site(@"t501",        @"t501",       @"242",     @"com.UGGame.cp",           @"http://t501f.fhptcdn.com",                    @"内测包",     @"t501"),
            site(@"t502",        @"t502",       @"243",     @"com.UGGame.cp",           @"http://t502f.fhptcdn.com",                    @"内测包",     @"t502"),
            
            // 站点编号 / 上传编号 / 上传ID / 签名方式 / APP名 / bundleID / 接口域名
//            NSString *siteId, NSString *uploadNum, NSString *uploadId, NSString *appId, NSString *host, NSString *type, NSString *appName
        ];
    });
    return __dataArray;
}

@end
