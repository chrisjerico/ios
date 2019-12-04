//
//  SiteModel.m
//  iOS App Signer
//
//  Created by fish on 2019/11/24.
//  Copyright © 2019 Daniel Radtke. All rights reserved.
//

#import "SiteModel.h"

@implementation SiteModel

+ (instancetype)site:(NSString *)siteId :(NSString *)type :(NSString *)name :(NSString *)appId :(NSString *)host {
    SiteModel *sm = [SiteModel new];
    sm.siteId = siteId;
    sm.type = type;
    sm.appName = name;
    sm.appId = appId;
    sm.host = host;
    return sm;
}

+ (NSArray *)sites:(NSString *)siteIds {
    NSMutableArray *temp = @[].mutableCopy;
    for (NSString *siteId in [siteIds componentsSeparatedByString:@","]) {
        [temp addObject:[self modelWithId:siteId]];
    }
    return temp.copy;
}

static NSMutableArray <SiteModel *> *__sites = nil;

+ (void)checkSiteInfo:(NSString *)siteIds :(NSString *)projectDir {
    [__sites removeAllObjects];
    
    NSMutableArray *errs = @[].mutableCopy;
    for (NSString *siteId in [siteIds componentsSeparatedByString:@","]) {
        SiteModel *sm = [SiteModel modelWithId:siteId];
        if (sm) {
            if (!sm.appName.length) {
                [errs addObject:[NSString stringWithFormat:@"app名称未配置, %@", sm.siteId]];
            }
            if (!sm.appId.length) {
                [errs addObject:[NSString stringWithFormat:@"bundleId未配置, %@", sm.siteId]];
            }
            if (!sm.host.length) {
                [errs addObject:[NSString stringWithFormat:@"接口域名未配置, %@", sm.siteId]];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/AutoPacking/打包文件/各站点AppIcon（拷贝出来使用）/%@", projectDir, sm.siteId]]) {
                [errs addObject:[NSString stringWithFormat:@"app图标未配置, %@", sm.siteId]];
            }
            [__sites addObject:sm];
        } else {
            [errs addObject:[NSString stringWithFormat:@"没有此站点，请检查是否拼写错误, %@", siteId]];
        }
    }
    
    NSLog(@"-——————————检查站点配置———————————");
    for (NSString *err in errs) {
        NSLog(@"%@", err);
    }
    if (errs.count) {
        [__sites removeAllObjects];
        @throw [NSException exceptionWithName:@"缺少已上配置，请配置完成后再打包" reason:@"" userInfo:nil];
        return ;
    }
    NSLog(@"-——————————配置ok-——————————");
}

+ (instancetype)nextSite {
    SiteModel *sm = __sites.firstObject;
    if (!sm) {
        NSLog(@"-——————————打包完成-——————————");
//        @throw [NSException exceptionWithName:@"打包完成" reason:@"" userInfo:nil];
    } else {
        [__sites removeObject:sm];
    }
    return sm;
}

+ (instancetype)modelWithId:(NSString *)siteId {
    for (SiteModel *sm in [SiteModel allSites]) {
        if ([sm.siteId isEqualToString:siteId]) {
            return sm;
        }
    }
    return nil;
}

+ (NSArray *)allSites {
    static NSArray *__dataArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sites = @[].mutableCopy;
        __dataArray = @[
            [SiteModel site    :@"a002"     :@"超级签名"     :@"49彩票集团"     :@"com.UGGame.cp"     :@"https://5049uuu.com"],          // https://dev.app2.xin/index | 13265529007 | qaz123
            [SiteModel site    :@"a002a"     :@"超级签名"     :@"49彩票集团"    :@"io.fhpt.H52A8B80A"     :@""],          // https://dev.app2.xin/index | 13265529007 | qaz123
            [SiteModel site    :@"a002b"     :@"超级签名"     :@"49彩票集团"    :@"io.fhpt.H53D2C0A9"     :@""],          // https://dev.app2.xin/index | 13265529007 | qaz123
            [SiteModel site    :@"a002c"     :@"超级签名"     :@"49彩票集团"    :@"io.fhpt.H5069C7C0"     :@""],          // https://dev.app2.xin/index | 13265529007 | qaz123
            [SiteModel site    :@"a002d"     :@"超级签名"     :@"49彩票集团"    :@"io.fhpt.H5E99F6BB"     :@""],          // https://dev.app2.xin/index | 13265529007 | qaz123
            [SiteModel site    :@"a002e"     :@"超级签名"     :@"49彩票集团"    :@"io.fhpt.H5B2F70A9"     :@""],          // https://dev.app2.xin/index | 13265529007 | qaz123
            [SiteModel site    :@"c001"     :@"超级签名"     :@"彩47"          :@"io.fhpt.H5BAECCD9"     :@"https://47c47webappqp.org"],          // https://dev.app2.xin/index | 15697023521 | aa135246
            [SiteModel site    :@"c005"     :@"超级签名"     :@"乐盈彩票"       :@"io.fhpt.H5AD6EE3E"     :@""],          // https://dev.app2.xin/index | 13545990831 | dz990990
            [SiteModel site    :@"c105"     :@"超级签名"     :@"澳⻔彩票"       :@""     :@""],          // https://dev.app2.xin/index | 15542484889 | aa168168
            [SiteModel site    :@"c114"     :@"超级签名"     :@"彩43"          :@""     :@""],          // https://dev.app2.xin/index | 19859553001 | wenxiang123123
            [SiteModel site    :@"c190"     :@"超级签名"     :@"22333彩世界"    :@""     :@""],          // https://dev.app2.xin/index |  |
            [SiteModel site    :@"h002"     :@"超级签名"     :@"⾹港赛⻢会"     :@""     :@""],          // https://dev.app2.xin/index | 15827947817 | dz990990
            [SiteModel site    :@"c201"     :@"超级签名"     :@"大咖彩票"       :@""     :@"https://dkcpapp.com"],          //https://dev.app2.xin/index | 18675958156 | dk789789


            [SiteModel site    :@"c018"     :@"企业包"     :@"2044彩票"     :@"io.fhpt.H51E9BFB6"     :@"https://031122.com"],
            [SiteModel site    :@"c021"     :@"企业包"     :@"幸运彩票"     :@"io.fhpt.H5A730C2F"     :@""],
            [SiteModel site    :@"c028"     :@"企业包"     :@"鳳凰彩票"     :@"io.fhpt.H5DBF1426"     :@""],
            [SiteModel site    :@"c053"     :@"企业包"     :@"彩53"     :@"io.fhpt.H563009C8"     :@"https://988c53.com"],
            [SiteModel site    :@"c062"     :@"企业包"     :@"六合彩票"     :@"io.fhpt.H5AF9FDA4"     :@""],
            [SiteModel site    :@"c067"     :@"企业包"     :@"乐盈彩票"     :@"io.fhpt.H59B0EF77"     :@""],
            [SiteModel site    :@"c068"     :@"企业包"     :@"⾦牌⼿游"     :@"io.fhpt.H5E98EDD5"     :@""],
            [SiteModel site    :@"c069"     :@"企业包"     :@"360⼿游"     :@"io.fhpt.H5CC54076"     :@""],
            [SiteModel site    :@"c074"     :@"企业包"     :@"5360彩票"     :@"io.fhpt.H5016B05F"     :@""],
            [SiteModel site    :@"c076"     :@"企业包"     :@"彩98"     :@"io.fhpt.H59A95B9B"     :@""],
            [SiteModel site    :@"c080"     :@"企业包"     :@"007彩票"     :@"io.fhpt.H5C82F72A"     :@""],
            [SiteModel site    :@"c085"     :@"企业包"     :@"彩壹万"     :@"io.fhpt.H53F348DC"     :@"https://xn--10app-308h91u.com"],
            [SiteModel site    :@"c085a"     :@"企业包"     :@"彩壹万"     :@""     :@"https://c10000ll.com"],
            [SiteModel site    :@"c117"     :@"企业包"     :@"50.CC彩票⽹"     :@"io.fhpt.H5AAB211E"     :@""],
            [SiteModel site    :@"c125"     :@"企业包"     :@"财神彩票"     :@"io.fhpt.H52CD2820"     :@""],
            [SiteModel site    :@"c131"     :@"企业包"     :@"5000万娱乐城"     :@"io.fhpt.H51B87207"     :@""],
            [SiteModel site    :@"c134"     :@"企业包"     :@"1997⾹港彩票"     :@"io.fhpt.H5B711E9A"     :@"https://19972030.com"],
            [SiteModel site    :@"c137"     :@"企业包"     :@"7033彩票"     :@"io.fhpt.H5B75458D"     :@"https://7033005.com"],
            [SiteModel site    :@"c141"     :@"企业包"     :@"新华彩票"     :@"io.fhpt.H57BED93A"     :@""],
            [SiteModel site    :@"c142"     :@"企业包"     :@"2058开元棋牌"     :@"io.fhpt.H56F6EA3C"     :@""],
            [SiteModel site    :@"c150"     :@"企业包"     :@"0187彩票⽹"     :@"io.fhpt.H5CDDC97E"     :@"https://0187677.com"],
            [SiteModel site    :@"c151"     :@"企业包"     :@"澳⻔新葡京"     :@"io.fhpt.H5ADDD837"     :@"https://xpj501501401401.vip"],
            [SiteModel site    :@"c153"     :@"企业包"     :@"亚博彩票"     :@"io.fhpt.H504175BD"     :@"https://yb247.cn"],
            [SiteModel site    :@"c154"     :@"企业包"     :@"吉祥彩"     :@"io.fhpt.H5DFB9358"     :@""],
            [SiteModel site    :@"c155"     :@"企业包"     :@"405彩票"     :@"io.fhpt.H5B45C43F"     :@""],
            [SiteModel site    :@"c156"     :@"企业包"     :@"速8彩票"     :@"io.fhpt.H5BEC1764"     :@""],
            [SiteModel site    :@"c157"     :@"企业包"     :@"中国福彩⽹"     :@"io.fhpt.H5988B005"     :@""],
            [SiteModel site    :@"c158"     :@"企业包"     :@"9055彩票"     :@"io.fhpt.H5E995A19"     :@"https://9055188.com"],
            [SiteModel site    :@"c161"     :@"企业包"     :@"⾦沙彩票"     :@"io.fhpt.H59B7B2EB"     :@""],
            [SiteModel site    :@"c162"     :@"企业包"     :@"畅玩彩票"     :@"io.fhpt.H5BE95010"     :@""],
            [SiteModel site    :@"c163"     :@"企业包"     :@"彩91"     :@"io.fhpt.H59BF8829"     :@"https://c91398.com"],
            [SiteModel site    :@"c164"     :@"企业包"     :@"⼴州彩票"     :@"io.fhpt.H57955107"     :@""],
            [SiteModel site    :@"c165"     :@"企业包"     :@"天天彩票"     :@"io.fhpt.H57D82AEF"     :@"https://1875006.com"],
            [SiteModel site    :@"c166"     :@"企业包"     :@"88彩票"     :@"io.fhpt.H5B345FC4"     :@""],
            [SiteModel site    :@"c169"     :@"企业包"     :@"太阳城集团"     :@"io.fhpt.H529081C9"     :@""],
            [SiteModel site    :@"c172"     :@"企业包"     :@"凤凰彩票"     :@"io.fhpt.H5534F908"     :@""],
            [SiteModel site    :@"c173"     :@"企业包"     :@"东⽅集团"     :@"io.fhpt.H50900911"     :@"https://www.dfjt1.com"],
            [SiteModel site    :@"c175"     :@"企业包"     :@"太阳城集团"     :@"io.fhpt.H57F31D1D"     :@"https://7053i.com"],
            [SiteModel site    :@"c177"     :@"企业包"     :@"联众彩票"     :@"io.fhpt.H5B410AF8"     :@"https://lzcp11.com"],
            [SiteModel site    :@"c178"     :@"企业包"     :@"百度彩票"     :@"io.fhpt.H54810967"     :@""],
            [SiteModel site    :@"c182"     :@"企业包"     :@"澳⻔⼤世界"     :@"io.fhpt.H55A3FE0A"     :@""],
            [SiteModel site    :@"c183"     :@"企业包"     :@"五洲国际"     :@"io.fhpt.H5C20B434"     :@""],
            [SiteModel site    :@"c185"     :@"企业包"     :@"太阳城集团"     :@"io.fhpt.H50BFF911"     :@""],
            [SiteModel site    :@"c189"     :@"企业包"     :@"地球⼈"     :@"io.fhpt.H53C0C63D"     :@""],
            [SiteModel site    :@"c225"     :@"企业包"     :@"51彩票"     :@"io.fhpt.H50A96411"     :@""],
            [SiteModel site    :@"c002"     :@"企业包"     :@"永利彩世界"     :@"io.fhpt.YSAC002"     :@"https://154977.com"], // io.dcloud.UNIE955DDC（新增的第三方改签由于频繁掉签已弃用）
            

            [SiteModel site    :@"c018a"    :@"越狱包"     :@"今⽇彩票"        :@"io.fhpt.H53DDB5F6"     :@""],
            [SiteModel site    :@"c018b"    :@"越狱包"     :@"彩聊"          :@"io.fhpt.H504390D9"     :@""],
            [SiteModel site    :@"b001"     :@"越狱包"     :@"优选彩票"     :@"io.fhpt.H5BC63A97"     :@""],
            [SiteModel site    :@"c006"     :@"越狱包"     :@"⾦沙娱乐场"     :@"io.fhpt.H560B7EC1"     :@"https://xn--app-v85fh28j.com"],
            [SiteModel site    :@"c011"     :@"越狱包"     :@"华夏彩票"     :@"io.fhpt.H599FF71F"     :@"https://www.hx627.com"],
            [SiteModel site    :@"c012"     :@"越狱包"     :@"8号彩票"     :@"io.fhpt.H5F0B8A01"     :@"https://20180849.com"],
            [SiteModel site    :@"c015"     :@"越狱包"     :@"奖多多"     :@"io.fhpt.H52FC720A"     :@""],
            [SiteModel site    :@"c022"     :@"越狱包"     :@"68彩票"     :@"io.fhpt.H53EC1170"     :@""],
            [SiteModel site    :@"c035"     :@"越狱包"     :@"凤凰彩票"     :@"io.fhpt.H5D70A94D"     :@"https://5504707.com"],
            [SiteModel site    :@"c036"     :@"越狱包"     :@"幸运彩票"     :@"io.fhpt.H5570A960"     :@""],
            [SiteModel site    :@"c039"     :@"越狱包"     :@"汇丰彩票"     :@"io.fhpt.H5C117128"     :@""],
            [SiteModel site    :@"c041"     :@"越狱包"     :@"福彩⽹"     :@"io.fhpt.H5AB7911E"     :@""],
            [SiteModel site    :@"c047"     :@"越狱包"     :@"新2彩票"     :@"io.fhpt.H539296B3"     :@"https://x22xxx.com"],
            [SiteModel site    :@"c048"     :@"越狱包"     :@"凤凰彩票"     :@"io.fhpt.H5F00A9FA"     :@"https://dsjf43-43-f14-345-36-g54t-gfh54.com"],
            [SiteModel site    :@"c049"     :@"越狱包"     :@"新世纪Ⅱ"     :@"io.dcloud.UNIFC049"     :@"https://93922app.com"],
            [SiteModel site    :@"c052"     :@"越狱包"     :@"天天彩票"     :@"io.fhpt.H5ED6D043"     :@""],
            [SiteModel site    :@"c054"     :@"越狱包"     :@"⾹港国际"     :@"io.fhpt.H5CBD9DE0"     :@"https://666mv.cc"],
            [SiteModel site    :@"c070"     :@"越狱包"     :@"K8娱乐城"     :@"io.fhpt.H55ED7A0B"     :@""],
            [SiteModel site    :@"c073"     :@"越狱包"     :@"彩73"     :@"io.fhpt.H5AECD773"     :@"https://c73hbs.com/"],
            [SiteModel site    :@"c077"     :@"越狱包"     :@"彩95"     :@"io.fhpt.H5167664E"     :@""],
            [SiteModel site    :@"c078"     :@"越狱包"     :@"彩333"     :@"io.fhpt.H5E99DB2C"     :@""],
            [SiteModel site    :@"c084"     :@"越狱包"     :@"新2彩票"     :@"io.fhpt.H599DB7B9"     :@"https://papghawshugposwaughwsoohu.com"],
            [SiteModel site    :@"c087"     :@"越狱包"     :@"易购"     :@"io.fhpt.H59A5D767"     :@""],
            [SiteModel site    :@"c090"     :@"越狱包"     :@"⾦沙彩票"     :@"io.fhpt.H5D6E1F0A"     :@""],
            [SiteModel site    :@"c091"     :@"越狱包"     :@"凤凰彩票"     :@"io.fhpt.H5691A751"     :@"https://83f9.com"],
            [SiteModel site    :@"c092"     :@"越狱包"     :@"2013彩票"     :@"io.fhpt.H57B34489"     :@"https://4681kkk.com"],
            [SiteModel site    :@"c106"     :@"越狱包"     :@"58彩票"     :@"io.fhpt.H5580AADE"     :@""],
            [SiteModel site    :@"c108"     :@"越狱包"     :@"葡京娱乐场"     :@"io.fhpt.H53779C0A"     :@"https://361865.com"],
            [SiteModel site    :@"c112"     :@"越狱包"     :@"太阳城集团"     :@"io.fhpt.H5E0A94E1"     :@""],
            [SiteModel site    :@"c115"     :@"越狱包"     :@"中彩⽹"     :@"io.fhpt.H59BD7AE3"     :@""],
            [SiteModel site    :@"c116"     :@"越狱包"     :@"1353彩世界"     :@"io.fhpt.H50A85511"     :@"https://13532007.com/https://88677.cc"],
            [SiteModel site    :@"c120"     :@"越狱包"     :@"新葡京彩票"     :@"io.fhpt.H591E28D0"     :@"https://asafew435yrtgre.net"],
            [SiteModel site    :@"c126"     :@"越狱包"     :@"758彩票"     :@"io.fhpt.H5FD4D963"     :@""],
            [SiteModel site    :@"c129"     :@"越狱包"     :@"万豪彩票"     :@"io.fhpt.H58AE4F87"     :@"https://7803000.com"],
            [SiteModel site    :@"c130"     :@"越狱包"     :@"必发彩票"     :@"io.fhpt.H5A94011E"     :@""],
            [SiteModel site    :@"c132"     :@"越狱包"     :@"彩霸王"     :@"io.fhpt.H504F0A93"     :@""],
            [SiteModel site    :@"c136"     :@"越狱包"     :@"⻓诚彩票"     :@"io.fhpt.H5F60C8D2"     :@""],
            [SiteModel site    :@"c139"     :@"越狱包"     :@"68中彩⽹"     :@"io.fhpt.H536040A9"     :@""],
            [SiteModel site    :@"c186"     :@"越狱包"     :@"好彩⽹"     :@"io.fhpt.H5B2B56F7"     :@""],
            [SiteModel site    :@"c192"     :@"越狱包"     :@"凤凰之家"     :@"io.fhpt.H56438C9F"     :@""],
            [SiteModel site    :@"c193"     :@"越狱包"     :@"新葡京彩票"     :@"io.fhpt.H54C32CA8"     :@"https://4906app.app"],
            [SiteModel site    :@"c200"     :@"越狱包"     :@"1995澳门彩票"     :@"io.fhpt.H5830E440"     :@"https://20191995.com"],
            [SiteModel site    :@"c601"     :@"越狱包"     :@"六合宝典"     :@"io.fhpt.H5D5F880F"     :@""],
            [SiteModel site    :@"h003"     :@"越狱包"     :@"华为彩票"     :@"io.fhpt.H591E28D0"     :@""],
            [SiteModel site    :@"c089"     :@"越狱包"     :@"彩89"     :@""     :@""],
            [SiteModel site    :@"c171"     :@"越狱包"     :@"CC彩票-默认"     :@""     :@""],
            [SiteModel site    :@"c171"     :@"越狱包"     :@"CC彩票"     :@""     :@""],
            [SiteModel site    :@"c171a"     :@"越狱包"     :@"CC彩票"     :@""     :@""],
            [SiteModel site    :@"c171b"     :@"越狱包"     :@"CC彩票"     :@""     :@""],
            [SiteModel site    :@"c171c"     :@"越狱包"     :@"CC彩票"     :@""     :@""],
            [SiteModel site    :@"c171d"     :@"越狱包"     :@"CC彩票"     :@""     :@""],
            [SiteModel site    :@"c171e"     :@"越狱包"     :@"CC彩票-默认包"     :@""     :@""],
            [SiteModel site    :@"c184"     :@"越狱包"     :@"凤凰彩票"     :@"io.fhpt.H5A6D1720"     :@"https://0fhcp.cn"],
            [SiteModel site    :@"c194"     :@"越狱包"     :@"好彩国际"     :@"io.dcloud.UNI42C6822"     :@"https://hc16324app95712gj5168168app.com"],
            [SiteModel site    :@"c197"     :@"越狱包"     :@"太阳城官⽹"     :@"io.fhpt.H52622B1F"     :@"https://tycgw3.com"],
            [SiteModel site    :@"c198"     :@"越狱包"     :@"太阳城集团"     :@"io.fhpt.H53E43223"     :@"https://2909tycjt.com/"],
            [SiteModel site    :@"h003a"     :@"越狱包"     :@"澳⻔威尼斯⼈"     :@"io.fhpt.H554013D2"     :@""],
            [SiteModel site    :@"c008"     :@"越狱包"     :@""     :@""     :@"https://888123app.com"],
            
            
            [SiteModel site    :@"test10"    :@"内测包"     :@"test10"   :@"com.UGGame.cp"        :@"http://test10.6yc.com"],
            [SiteModel site    :@"c083"      :@"内测包"     :@"c083测试"   :@"com.UGGame.cp"        :@"http://t111f.fhptcdn.com"],
            [SiteModel site    :@"test100"   :@"内测包"     :@"test100"   :@"com.UGGame.cp"        :@"http://test100f.fhptcdn.com"],
            [SiteModel site    :@"t032"  :@"内测包"     :@"t032"   :@"com.UGGame.cp"        :@"http://t005f.fhptcdn.com"],     // (老虎)
            [SiteModel site    :@"test20"  :@"内测包"     :@"test20"   :@"com.UGGame.cp"        :@"http://test20.6yc.com"],    // (朗朗)
            [SiteModel site    :@"test29"  :@"内测包"     :@"test29"   :@"com.UGGame.cp"        :@"http://test29f.fhptcdn.com"],// (小东)
            [SiteModel site    :@"test19"      :@"内测包"     :@"test19"   :@"com.UGGame.cp"        :@"http://test19.6yc.com"],
        ];
    });
    return __dataArray;
}

@end
