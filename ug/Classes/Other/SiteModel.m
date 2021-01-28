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
        // 站点编号 /              上传编号      / 上传ID    / 签名方式                 / APP名                     / bundleID                  / 接口域名
        __dataArray = @[
            site(@"a002",        @"a002hy",     @"129",     @"com.UGGame.cp",           @"https://5049uuu.com",                         @"超级签名",    @"49彩票集团"),          // https://dev.app2.xin/index | 13265529007 | lihongwei599   超级签名
            site(@"c001",        @"c001hy",     @"130",     @"io.fhpt.H5BAECCD9",       @"https://c47app1.com",                        @"超级签名",    @"彩47"),          // https://dev.app2.xin/index | 15697023521 | aa135246  | 123456   该网站域名根本没用，该客户应么有用原生
            site(@"c105b",       @"c105bhy",    @"268",     @"io.fhpt.YSAC105B",       @"https://390qp8.com",                           @"超级签名",    @"390棋牌"),          // https://dev.app2.xin/index | 15542484889 | aa168168
            site(@"c114",        @"c114hy",     @"157",     @"io.fhpt.YSAC114",                        @"https://c432019.com",                                            @"超级签名",    @"彩43"),          // https://dev.app2.xin/index | 19859553001 | wenxiang123123   昨天才看到的arc 给的链接
            site(@"c190",        @"c190hy",     @"167",     @"io.fhpt.H5F40948F",       @"https://306565.com",                          @"超级签名",    @"22333彩世界"),          // https://dev.app2.xin/index 账号：15559931943   密码：xiaokeai190  
            site(@"c190hyls",    @"c190hyls",   @"299",     @"io.fhpt.YSAC190hyls",     @"https://306565.com",                          @"企业包",    @"22333彩世界"),          //超级签名出问题，客户要求临时上一个
            site(@"c048",        @"c048hy",     @"133",     @"io.fhpt.H5F00A9FA",       @"https://dsjf43-43-f14-345-36-g54t-gfh54.com", @"企业包",      @"凤凰彩票"),//用户15687374617  密码   qaz123123  超级苹果签
            
            
            site(@"l002",        @"l002hy",     @"239",     @"io.fhpt.YSAL002",         @"https://70333e.com",                         @"企业包",     @"威尼斯人"),//wang70333@gmail.com   WANGzhongwang70333   极光账号跟密码
            site(@"c053",        @"c053ys",     @"152",     @"io.fhpt.YSAC053",       @"https://988c53.com",                          @"企业包",     @"0069彩票"),  // 极光 账号：xuduoduo2018402@gmail.com 密码：Xusiling2018402.| 封装是超级签名 https://dev.app2.xin/index  账号：14779887196  密码：Xusiling2018402  // 友盟 c53555com c53qwe..
            site(@"c085",        @"c085hy",     @"165",     @"io.fhpt.H53F348DC",       @"https://x558.cc",                             @"企业包",     @"彩壹万"),//已上架    https://c10000ll.com   极光推送hu178178 密码aA178178178  https://xn--10app-308h91u.com
            site(@"c085yw",        @"c085ywhy",     @"316", @"io.fhpt.YSAC085YW",       @"https://x558.cc",                             @"企业包",     @"10000.AG"),//已上架    https://c10000ll.com   极光推送hu178178 密码aA178178178  https://xn--10app-308h91u.com
          
            site(@"c134",        @"c134hy",     @"142",     @"io.fhpt.H5B711E9A",       @"https://19972030.com",                        @"企业包",     @"1997⾹港彩票"),//极光推送 账号xgcp1997@163.com 密码Qaz369369
            site(@"c137",        @"c137hy",     @"158",     @"io.fhpt.H5B75458D",       @"https://7033005.com",                         @"企业包",     @"7033彩票"),
            site(@"c150",        @"c150hy",     @"179",     @"io.fhpt.H5CDDC97E",       @"https://0187488.com",                         @"企业包",     @"0187彩票⽹"),
            site(@"c158",        @"c158hy",     @"159",     @"io.fhpt.H5E995A19",       @"https://9055188.com",                         @"企业包",     @"9055彩票"),
            site(@"c163",        @"c163hy",     @"160",     @"io.fhpt.H59BF8829",       @"https://c91398.com",                          @"企业包",     @"彩91"),
            site(@"c165",        @"c165hy",     @"146",     @"io.fhpt.H57D82AEF",       @"https://1875006.com",                         @"企业包",     @"天天彩票"),
            site(@"c169",        @"c169hy",     @"162",     @"io.fhpt.H529081C9",       @"http://heixxqic169cqhmszw.playzone88.com",    @"企业包",     @"太阳城集团"),
            site(@"c175",        @"c175hy",     @"148",     @"io.fhpt.H57F31D1D",       @"http://7053fndsjfkn.com",                    @"企业包",     @"7053"), // 已上架  极光 lijinju6@gmail.com 密码Wo258258..

            site(@"c186",        @"c186hy",     @"322",     @"io.fhpt.YSAC186",         @"https://200300b.com",                         @"企业包",     @"好彩网"),
            site(@"c225",        @"c225hy",     @"342",     @"io.fhpt.H50A96411",       @"https://8393483.com",                                            @"企业包",     @"51彩票"),
            site(@"c002",        @"c002hy",     @"173",     @"io.fhpt.YSAC002",         @"https://154977.com",                          @"企业包",     @"永利彩世界"),//极光推送 caishijie05022@163.com 密码Aa362400
            site(@"c084",        @"c084hy",     @"136",     @"io.fhpt.H599DB7B9",       @"https://papghawshugposwaughwsoohu.com",       @"企业包",     @"新2彩票"),//极光 jiguangx2c@gmail.com Qwe741123
            site(@"c012",        @"c012hy",     @"170",     @"io.fhpt.H5F0B8A01",       @"https://08492039.com",                        @"企业包",     @"8号彩票"),//极光账号：bahao   密码Qaz123123
            site(@"c073",        @"c073hy",     @"135",     @"io.fhpt.H5AECD773",       @"https://c732.vip",                          @"企业包",     @"彩73"),
            site(@"c092",        @"c092hy",     @"156",     @"io.fhpt.H57B34489",       @"https://2013ddd.com",                         @"企业包",     @"2013彩票"),//极光账号：4366762@qq.com 密码：hdghFGDFGbdfbgf234
            site(@"c115",        @"c115hy",     @"356",    @"io.fhpt.H59BD7AE3",      @"https://6615322.com",                           @"企业包",     @"6615中彩网"),//极光账号：780821350@qq.com  密码：OKM88okm
            site(@"c116",        @"c116hy",     @"139",     @"io.fhpt.H50A85511",       @"https://13532037.com",                        @"企业包",     @"1353彩世界"),//极光推送，账号：wcai87089@gmail.com密码Csj13530 rn :https://13532037.com
            site(@"c126b",       @"c126bhy",    @"323",     @"io.fhpt.YSAC126B",         @"https://og878.vip",                        @"企业包",     @"新葡京娱乐场"),
            site(@"c126",        @"c126hy",     @"277",     @"io.fhpt.H5FD4D963",       @"https://jzcp055.com",                        @"企业包",     @"环球彩票网"),
            site(@"h003b",       @"h003bhy",    @"295",     @"io.fhpt.H591E28D0",       @"https://betv5.com",                          @"企业包",     @"威尼斯人"),//账号：395348255@qq.com     密码： Lyj678678
            site(@"c035",        @"c035hy",     @"169",     @"io.fhpt.H5D70A94D",       @"https://5504707.com",                         @"企业包",     @"凤凰彩票"),
            site(@"c035b",       @"c035b",      @"264",     @"io.fhpt.YSAC035B",        @"https://5504596.com",                         @"企业包",     @"凤凰彩票"),
            site(@"c035c",       @"c035c",      @"265",     @"io.fhpt.YSAC035C",        @"https://5504597.com",                         @"企业包",     @"凤凰彩票"),
            site(@"c052",        @"c052hy",     @"290",     @"io.fhpt.YSAC052",         @"https://4924920.com",                        @"企业包",     @"天天彩票"),
            site(@"c108",        @"c108hy",     @"138",     @"io.fhpt.H53779C0A",       @"https://823653.com",                          @"企业包",     @"葡京娱乐场"),
            site(@"c193",        @"c193hy",     @"204",     @"io.fhpt.H54C32CA8",       @"https://4906app.com",                         @"企业包",     @"新葡京彩票"),//shjiu 密码Facai4906
            site(@"c200",        @"c200hy",     @"183",     @"io.fhpt.H5830E440",       @"https://20181995.com",                        @"企业包",     @"澳门彩票"),
            site(@"c120",        @"c120hy",     @"140",     @"io.fhpt.H591E28D0",       @"https://asafew435yrtgre.net",                 @"企业包",     @"新葡京彩票"),

            site(@"c117",       @"c117hy",     @"352",      @"io.fhpt.YSAC117",         @"https://822323.com",                          @"企业包",     @"50.cc彩票网"),//
            site(@"c198",        @"c198hy",     @"185",     @"io.fhpt.H53E43223",       @"https://2909tycjt.com",                       @"企业包",     @"太阳城集团"),
            site(@"c205",        @"c205hy",     @"308",     @"io.fhpt.YSFC205",         @"https://494.cyou",                            @"企业包",     @"494集团"),//
            site(@"c208",        @"c208hy",     @"246",     @"io.fhpt.YSAC208",         @"https://771appappapp.com",                        @"企业包",     @"威尼斯人"),//友盟 账号：hjj888 密码：huoji888..
            site(@"c213",        @"c213hy",     @"248",     @"io.fhpt.YSAC213",         @"https://450vip15.com",                           @"企业包",     @"450集团"),//
            site(@"c217",        @"c217hy",     @"255",     @"io.fhpt.YSFC217",         @"https://9999app-sa5g6erty9r8ujtk5oi9rtg2k6e55uer9999-app.com",   @"企业包",     @"贵宾厅集团"),//xingxin6888@gmail.com  密码QAZzxc12,.
            site(@"c211",        @"c211hy",     @"259",     @"io.fhpt.YSFC211",         @"https://310310app.com",                       @"企业包",     @"4484娱乐城"),
            site(@"c235",       @"c235hy",     @"300",      @"io.fhpt.YSAC235",         @"https://www.hilliot.com",                         @"企业包",     @"新葡京"),
            site(@"c237",       @"c237hy",     @"313",      @"io.fhpt.YSAC237",         @"http://app13478.com",                         @"企业包",     @"太阳城集团"),
            site(@"c246",       @"c246hy",     @"329",      @"io.fhpt.YSAC246",         @"https://647758.com",                         @"企业包",     @"澳门新葡京"),
            site(@"c242",       @"c242hy",     @"332",      @"io.fhpt.YSAC242",         @"https://460889.com",                         @"企业包",     @"新葡京娱乐场"),
            site(@"c243",       @"c243hy",     @"368",      @"io.fhpt.YSAC243",         @"https://55979711.vip",                       @"企业包",     @"开元棋牌"),
			site(@"c245",       @"c245hy",     @"343",      @"io.fhpt.YSAC245",         @"https://4823app.com",                         @"企业包",     @"4823威尼斯人"),//极光账号 vn4823sym@gmail.com 密码 Aa362600.jg
            site(@"c251",       @"c251hy",     @"348",      @"io.fhpt.YSAC251",         @"https://2420app.app",                         @"企业包",     @"新葡京娱乐城"),//
            site(@"c252",       @"c252hy",     @"355",      @"io.fhpt.YSAC252",         @"https://xggjapp8.com",                          @"企业包",     @"香港国际"),//
            site(@"c254",       @"c254hy",     @"357",      @"io.fhpt.YSFC254",         @"https://677888.org",                          @"企业包",     @"澳门皇冠"),//
            site(@"c257",       @"c257hy",     @"363",      @"io.fhpt.YSAC257",         @"https://hg88991.com",                          @"企业包",     @"皇冠现金网"),//
            site(@"c259",       @"c259hy",     @"365",      @"io.fhpt.YSAC259",         @"https://663638.com",                          @"企业包",     @"万发彩票"),//

            site(@" t05-fish",      @"",          @"",        @"com.UGGame.cp",           @"http://t134f.fhptcdn.com",                    @"内测包",     @"test05"),
            site(@" t30-andrew",    @"",          @"",        @"com.UGGame.cp",           @"http://test30.6yc.com",                       @"内测包",     @"test30"),
            site(@" t126-arc",      @"",          @"",        @"com.UGGame.cp",           @"http://t126f.fhptcdn.com",                    @"内测包",     @"test126"),
            site(@" t127-shiyu",    @"",          @"",        @"com.UGGame.cp",           @"http://t127f.fhptcdn.com",                    @"内测包",     @"test127"),
            site(@" t76-ezer",      @"",          @"",        @"com.UGGame.cp",           @"http://t076f.fhptcdn.com",                    @"内测包",     @"test76"),
            site(@" t77-richard",   @"",          @"",        @"com.UGGame.cp",           @"http://t077f.fhptcdn.com",                    @"内测包",     @"test77"),
            site(@" t130-mikis",    @"",          @"",        @"com.UGGame.cp",           @"http://test130.fhptcdn.com",                  @"内测包",     @"test130"),
            site(@" t132-tars",     @"",          @"",        @"com.UGGame.cp",           @"http://t132f.fhptcdn.com",                    @"内测包",     @"test132"),
            site(@" t133-smith",    @"",          @"",        @"com.UGGame.cp",           @"http://t133f.fhptcdn.com",                    @"内测包",     @"test133"),
            site(@" t128-pryo",     @"",          @"",        @"com.UGGame.cp",           @"http://t128f.fhptcdn.com",                    @"内测包",     @"test128"),
            site(@" t131-ian",      @"",          @"",        @"com.UGGame.cp",           @"http://test131.fhptcdn.com",                  @"内测包",     @"test131"),
            site(@"hotUpdate",      @"hotUpdate", @"260",     @"com.abcc4",               @"http://test10.6yc.com",                       @"内测包",     @"热更新测试包"),
            
            site(@"test103",     @"test103",    @"222",     @"com.UGGame.cp",           @"http://103.9.230.243",                        @"内测包",     @"test103"),
            site(@"test10",      @"88",         @"125",     @"com.UGGame.cp1",          @"http://test10.6yc.com",                       @"内测包",     @"test10"),
            site(@"test11",      @"test11",     @"257",     @"com.ugGame.chat2",        @"http://test11.6yc.com",                       @"内测包",     @"test11"),
            site(@"c083",        @"c083",       @"226",     @"com.UGGame.chat",         @"http://t111f.fhptcdn.com",                    @"内测包",     @"c083测试"),
            site(@"test100",     @"",           @"",        @"com.UGGame.cp",           @"http://test100f.fhptcdn.com",                 @"内测包",     @"test100"),
            site(@"test03",      @"",           @"",        @"com.UGGame.cp",         @"http://test03.6yc.com",                       @"内测包",     @"test03"),    // (朗朗)
            site(@"test06",      @"",           @"",        @"com.UGGame.cp",         @"http://test06.6yc.com",                       @"内测包",     @"test06"),    // (army)
            site(@"test07",      @"test07",     @"279",     @"com.ug.ChatTest",         @"http://test07.6yc.com",                       @"内测包",     @"test07"),    // (army)
            site(@"test20",      @"test20",     @"263",     @"com.uggame.qp.x",         @"http://test20.6yc.com",                       @"内测包",     @"test20"),    // (朗朗)
            site(@"test21",      @"test21",     @"263",     @"com.jdr.rsaobjc1",        @"http://test21.6yc.com",                       @"内测包",     @"test21"),    // ()
            site(@"test26",      @"test26",     @"326",     @"com.UGGame.cp",           @"http://test26.6yc.com",                       @"内测包",     @"test26"),    // ()
            site(@"test29",      @"test29",     @"245",     @"com.qing.ceshi1",         @"http://test29f.fhptcdn.com",                  @"内测包",     @"test29"),// (小东, ada)
            site(@"test29b",     @"test29b",    @"291",     @"com.guoxiandong.xunliao.x",@"http://t029bz.fhptcdn.com",                  @"内测包",     @"test29b"),// (fly)
            site(@"test30f",     @"",           @"",        @"com.UGGame.cp",           @"http://test30f.fhptcdn.com",                  @"内测包",     @"test30"),
            site(@"test19",      @"test19",     @"214",     @"com.ug.test",             @"http://test19.6yc.com",                       @"内测包",     @"test19"),
            site(@"test31",      @"",           @"",        @"com.UGGame.cp",           @"http://test31.6yc.com",                       @"内测包",     @"test31"),
            site(@"t005",        @"t005",       @"241",     @"com.asiapoker.happy.sswc", @"http://t005f.fhptcdn.com",                    @"内测包",     @"t005"),
            site(@"t500",        @"t500",       @"240",     @"com.UGGame.cp",           @"http://t500f.fhptcdn.com",                    @"内测包",     @"t500"),
            site(@"t501",        @"t501",       @"242",     @"com.UGGame.cp",           @"http://t501f.fhptcdn.com",                    @"内测包",     @"t501"),
            site(@"t502",        @"t502",       @"243",     @"com.UGGame.cp",           @"http://t502f.fhptcdn.com",                    @"内测包",     @"t502"),
            site(@"test36",      @"test36",     @"",        @"com.UGGame.cp",           @"http://test36.6yc.com",                       @"内测包",     @"test36"),//Michael
            site(@"test36a",     @"test36a",     @"",       @"com.UGGame.cp",           @"http://test36a.6yc.com",                      @"内测包",     @"test36a"),//Michael
            site(@"test60f",     @"test60f",    @"275",     @"com.uggame.qp",           @"http://test60f.fhptcdn.com",                  @"内测包",     @"test60f"),//
            site(@"test61f",     @"test61f",    @"276",     @"com.cccaa1",           @"http://test61f.fhptcdn.com",                  @"内测包",     @"test61f"),//
            site(@"test58f",     @"test58f",    @"282",     @"com.UGGame.cp",           @"http://test58f.ccpt.site",                    @"内测包",     @"test58f"),//
            site(@"test5801",     @"test5801",    @"",      @"com.UGGame.cp",           @"http://test5801.ccpt.site",                    @"内测包",     @"test5801"),//
            site(@"test5802",     @"test5802",    @"",      @"com.UGGame.cp",           @"http://test5802.ccpt.site",                    @"内测包",     @"test5802"),//
            site(@"test5804",     @"test5804",   @"286",     @"com.UGGame.cp",           @"http://test5804.ccpt.site",                   @"内测包",     @"test5804"),
            site(@"tess6001",     @"tess6001",   @"",        @"com.UGGame.cp",           @"http://tess6001.fhptcdn.com",                 @"内测包",     @"tess6001"),//
            site(@"tess6002",     @"tess6002",   @"",        @"com.UGGame.cp",           @"http://tess6002.fhptcdn.com",                 @"内测包",     @"tess6002"),//
            site(@"tess6003",     @"tess6003",   @"",        @"com.UGGame.cp",           @"http://tess6003.fhptcdn.com",                 @"内测包",     @"tess6003"),//
            site(@"t600f",        @"t600f",      @"",        @"com.UGGame.cp",           @"http://www.t600f.fhptcdn.com",                @"内测包",     @"t600f"),//
            site(@"wt600f",       @"wt600f",     @"",        @"com.UGGame.cp",           @"http://wwwt600f.fhptcdn.com",                 @"内测包",     @"wt600f"),//
            site(@"test28f",      @"",           @"",        @"com.UGGame.cp",           @"http://test28f.fhptcdn.com",                  @"内测包",     @"test28f"),
            site(@"testadaf",     @"testadaf",   @"285",     @"com.asiapoker.happy.hd",  @"http://testadaf.fhptcdn.com",                @"内测包",     @"testadaf"),    // (ada)t059
            site(@"test62",       @"test62",     @"289",     @"com.asiapoker.happy.qp650",@"http://test62f.ccpt.site",                   @"内测包",     @"test62"),
            site(@"test09",       @"test09",     @"",        @"com.UGGame.cp",            @"http://test09.6yc.com",                      @"内测包",     @"test09"),
            site(@"test61b",      @"test61bhy",  @"302",     @"com.UGGame.cp",            @"http://test61a.fhptcdn.com",                 @"内测包",     @"test61b"),
            site(@"test61c",      @"test61chy",  @"304",     @"com.UGGame.cp",            @"http://test61c.fhptcdn.com",                 @"内测包",     @"test61c"),
            site(@"test61d",      @"test61Dhy",  @"303",     @"com.UGGame.cp",            @"http://test61d.fhptcdn.com",                 @"内测包",     @"test61d"),
            site(@"test61e",      @"test61Ehy",  @"305",     @"com.UGGame.cp",            @"http://test61e.fhptcdn.com",                 @"内测包",     @"test61e"),
            site(@"test12",       @"test12hy",   @"",        @"com.UGGame.cp",            @"http://test12.6yc.com",                      @"内测包",     @"ttest12"),
            site(@"t039",         @"",           @"",        @"com.UGGame.cp",            @"http://test101f.fhptcdn.com",                @"内测包",     @"t039"),
			
            site(@"test08",       @"test08",     @"",        @"com.UGGame.cp",           @"http://test08.6yc.com",                   @"内测包",     @"test08"),
			site(@"shiyu",  	  @"shiyu",     @"",        @"com.UGGame.cp",           @"http://t127f.fhptcdn.com",                   @"内测包",     @"shiyu"),
            site(@"mj",           @"mj",         @"",        @"com.UGGame.cp",           @"http://test30f.fhptcdn.com",               @"内测包",       @"mj"),
            site(@"t501f",       @"t501f",     @"",        @"com.UGGame.cp",           @"http://t501f.fhptcdn.com/",                   @"内测包",     @"t501f"),


            // 站点编号 / 上传编号 / 上传ID / 签名方式 / APP名 / bundleID / 接口域名
            //siteId, /uploadNum,/uploadId/appId, /host, /type, /appName
        ];
    });
    return __dataArray;
}

@end
