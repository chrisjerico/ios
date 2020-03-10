import {SysConf1} from '../Model/UGSysConfModel';

export default class UGSkinManagers {
  skitType: string; // 皮肤类型
  skitString: string; // 皮肤类型

  bgColor: Array<string>; // 背景 渐变色
  navBarBgColor: Array<string>; // 导航条背景色
  tabBarBgColor: string; // Tabbar背景色
  tabNoSelectColor: string; // Tabbar未选中颜色
  tabSelectedColor: string; // Tabbar已选中颜色
  cellBgColor: string; // Cell背景色
  progressBgColor: Array<string>; // 进度条背景渐变色
  homeContentColor: string; // 首页内容底色
  homeContentSubColor: string; // 首页游戏列表二级菜单背景色
  CLBgColor: string; // 长龙灰色背景底色
  menuHeadViewColor: Array<string>; // 侧边栏顶部背景渐变色
  textColor1: string; // 默认字颜色 黑色
  textColor2: string; // 占位字颜色 深灰色
  textColor3: string; // 占位字颜色 淡灰色
  textColor4: string; // 反差字体 白色
  //新额度转换
  conversionCellColor: string; // 内容Cell
  intoViewColor: string; // 转入View
  moneyCellColor: string; // 金额Cell

  // 常用颜色（不跟随主题改变）
  placeholderColor?: string = '#E5E5E5'; // 占位背景色
  redColor?: string = '#B41C1C';

  constructor(props: UGSkinManagers) {
    Object.assign(this, props);
    this.placeholderColor = '#E5E5E5';
    this.redColor = '#B41C1C';
  }

  static sysConf(): UGSkinManagers {
    this.initAllSkin();

    var dict = {
      0: `经典${SysConf1.mobileTemplateBackground}`,
      2: `新年红${SysConf1.mobileTemplateStyle}`,
      3: '石榴红',
      4: `六合资料${SysConf1.mobileTemplateLhcStyle}`,
      5: '黑色模板',
      6: '金沙主题',
      7: '火山橙',
      8: `香槟金${SysConf1.mobileTemplateStyle}`,
      9: `简约模板${SysConf1.mobileTemplateStyle}`,
    };
    var key = dict[SysConf1.mobileTemplateCategory];
    key = '香槟金2';
    var skin = UGSkinManagers.all[key] ?? UGSkinManagers.all.经典1;
    console.log('当前皮肤为：' + skin.skitString);
    return skin;
  }

  static initAllSkin() {
    if (Object.keys(UGSkinManagers.all).length) {
      return;
    }
    // 经典
    var jd = {
      //经典 1蓝色
      经典1: new UGSkinManagers({
        skitType: '经典1',
        skitString: '经典 1蓝色',
        bgColor: ['#7F9493', '#5389B3'],
        navBarBgColor: ['#609AC5', '#609AC5'],
        tabBarBgColor: '#8DA3B1',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#b2cde0',
        homeContentSubColor: '#ADC8D7',
        cellBgColor: '#C1CBC9',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#5f9bc6', '#fb5959'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 2红色
      经典2: new UGSkinManagers({
        skitType: '经典2',
        skitString: '经典 2红色',
        bgColor: ['#d19885', '#904a6e'],
        navBarBgColor: ['#73315C', '#73315C'],
        tabBarBgColor: '#DFB9B5',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#d0aeb7',
        homeContentSubColor: '#D19885',
        cellBgColor: '#DFB9B5',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#bf338e', '#fb95db'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 3褐色
      经典3: new UGSkinManagers({
        skitType: '经典3',
        skitString: '经典 3褐色',
        bgColor: ['#B48A46', '#8A5C3E'],
        navBarBgColor: ['#7E503C', '#7E503C'],
        tabBarBgColor: '#DFC8A1',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#d2bea6',
        homeContentSubColor: '#B48A46',
        cellBgColor: '#DFC8A1',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#bf7555', '#efb398'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 4绿色
      经典4: new UGSkinManagers({
        skitType: '经典4',
        skitString: '经典 4绿色',
        bgColor: ['#78BC67', '#4DB48B'],
        navBarBgColor: ['#58BEA4', '#58BEA4'],
        tabBarBgColor: '#B6DDB6',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#c4e5c7',
        homeContentSubColor: '#78BC67',
        cellBgColor: '#B6DDB6',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#49a791', '#7cead3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 5褐色
      经典5: new UGSkinManagers({
        skitType: '经典5',
        skitString: '经典 5褐色',
        bgColor: ['#913D3E', '#EAAD72'],
        navBarBgColor: ['#662E3E', '#662E3E'],
        tabBarBgColor: '#FBE0B8',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#c1a8aa',
        homeContentSubColor: '#EAAD72',
        cellBgColor: '#F7E2C0',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#a06577', '#f1adc4'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 6淡蓝色
      经典6: new UGSkinManagers({
        skitType: '经典6',
        skitString: '经典 6淡蓝色',
        bgColor: ['#61A8B4', '#C7F3E5'],
        navBarBgColor: ['#2E647C', '#2E647C'],
        tabBarBgColor: '#C5EAE7',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#c1e1e6',
        homeContentSubColor: '#4361A3',
        cellBgColor: '#C5EAE7',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#4c91a9', '#85d2ec'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 7深蓝
      经典7: new UGSkinManagers({
        skitType: '经典7',
        skitString: '经典 7深蓝',
        bgColor: ['#486869', '#436363'],
        navBarBgColor: ['#3F5658', '#3F5658'],
        tabBarBgColor: '#ABC2B4',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#acbdbe',
        homeContentSubColor: '#4DB48B',
        cellBgColor: '#ABC2B4',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#65898c', '#9fd3d8'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 8紫色
      经典8: new UGSkinManagers({
        skitType: '经典8',
        skitString: '经典 8紫色',
        bgColor: ['#934FB4', '#9146A0'],
        navBarBgColor: ['#814689', '#814689'],
        tabBarBgColor: '#D1A4D7',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#d7b6e3',
        homeContentSubColor: '#934FB4',
        cellBgColor: '#D1A4D7',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#c161c3', '#f889fb'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 9深红
      经典9: new UGSkinManagers({
        skitType: '经典9',
        skitString: '经典 9深红',
        bgColor: ['#871113', '#871B1F'],
        navBarBgColor: ['#880506', '#880506'],
        tabBarBgColor: '#DE9595',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#cd908d',
        homeContentSubColor: '#9B292F',
        cellBgColor: '#D1A4D7',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#c30808', '#f98080'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 10淡灰
      经典10: new UGSkinManagers({
        skitType: '经典10',
        skitString: '经典 10淡灰',
        bgColor: ['#FC7008', '#FC7008'],
        navBarBgColor: ['#FF8705', '#FF8705'],
        tabBarBgColor: '#FFB666',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#ffc280',
        homeContentSubColor: '#E58645',
        cellBgColor: '#FFB666',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ffa33f', '#fbd2a5'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 11橘红
      经典11: new UGSkinManagers({
        skitType: '经典11',
        skitString: '经典 11橘红',
        bgColor: ['#B52A18', '#8F1115'],
        navBarBgColor: ['#8B2B2A', '#8B2B2A'],
        tabBarBgColor: '#DC7D6E',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#dba497',
        homeContentSubColor: '#B52A18',
        cellBgColor: '#DC7D6E',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#d24040', '#dc9191'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 12星空蓝
      经典12: new UGSkinManagers({
        skitType: '经典12',
        skitString: '经典 12星空蓝',
        bgColor: ['#008CAC', '#00A9CA'],
        navBarBgColor: ['#68A7A0', '#68A7A0'],
        tabBarBgColor: '#98BEBB',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#ade5ed',
        homeContentSubColor: '#22BDD1',
        cellBgColor: '#98BEBB',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#22667b', '#5fc5e2'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 13紫色
      经典13: new UGSkinManagers({
        skitType: '经典13',
        skitString: '经典 13紫色',
        bgColor: ['#9800B7', '#46D8D6'],
        navBarBgColor: ['#9533DD', '#9533DD'],
        tabBarBgColor: '#C367D7',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#ccadee',
        homeContentSubColor: '#DCA4EA',
        cellBgColor: '#C367D7',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#aa83e8', '#dbc5ff'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 14粉红
      经典14: new UGSkinManagers({
        skitType: '经典14',
        skitString: '经典 14粉红',
        bgColor: ['#FFBED4', '#FEC1D5'],
        navBarBgColor: ['#EFCFDD', '#EFCFDD'],
        tabBarBgColor: '#FEC1D5',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#ffe7ee',
        homeContentSubColor: '#F9CFDF',
        cellBgColor: '#FEC1D5',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#e499b0', '#fecfdd'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 15淡蓝
      经典15: new UGSkinManagers({
        skitType: '经典15',
        skitString: '经典 15淡蓝',
        bgColor: ['#4CAEDC', '#5DC3EB'],
        navBarBgColor: ['#66C6EA', '#66C6EA'],
        tabBarBgColor: '#5DC3EB',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#b1e2f3',
        homeContentSubColor: '#6EC4E5',
        cellBgColor: '#5DC3EB',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#5ebee5', '#addef3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 16淡灰
      经典16: new UGSkinManagers({
        skitType: '经典16',
        skitString: '经典 16淡灰',
        bgColor: ['#4300DA', '#5800EE'],
        navBarBgColor: ['#6505E6', '#6505E6'],
        tabBarBgColor: '#A766F7',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#b680f8',
        homeContentSubColor: '#6A3BEA',
        cellBgColor: '#A766F7',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#9041fd', '#c19bf5'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 17淡灰
      经典17: new UGSkinManagers({
        skitType: '经典17',
        skitString: '经典 17淡灰',
        bgColor: ['#FECC0A', '#FE9C08'],
        navBarBgColor: ['#FFAF06', '#FFAF06'],
        tabBarBgColor: '#FFE066',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#ffe280',
        homeContentSubColor: '#F4D36C',
        cellBgColor: '#FFE066',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ffc344', '#ffe1a2'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 18钻石蓝
      经典18: new UGSkinManagers({
        skitType: '经典18',
        skitString: '经典 18钻石蓝',
        bgColor: ['#B3B3B3', '#B3B3B3'],
        navBarBgColor: ['#C1C1C1', '#C1C1C1'],
        tabBarBgColor: '#D9D9D9',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#e0e0e0',
        homeContentSubColor: '#c1c1c1',
        cellBgColor: '#D9D9D9',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#c1c1c1', '#ececec'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //经典 19忧郁蓝
      经典19: new UGSkinManagers({
        skitType: '经典19',
        skitString: '经典 19忧郁蓝',
        bgColor: ['#00B2FF', '#005ED6'],
        navBarBgColor: ['#4CABFA', '#4CABFA'],
        tabBarBgColor: '#8CB9F4',
        tabNoSelectColor: '#000000',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#a1ccff',
        homeContentSubColor: '#49CEFC',
        cellBgColor: '#8CB9F4',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#4ba2fa', '#64d0ef'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
    };
    // 新年红
    var xnh = {
      //新年红
      新年红0: new UGSkinManagers({
        skitType: '新年红0',
        skitString: '新年红 0默认风格',
        bgColor: ['#F5F5F5', '#F5F5F5'],
        navBarBgColor: ['#DE1C27', '#DE1C27'],
        tabBarBgColor: '#DE1C27',
        tabNoSelectColor: '#FFFFFF',
        tabSelectedColor: '#F1B709',
        progressBgColor: ['#FEC434', '#FE8A23'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#F4C9CD',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#e63534', '#f99695'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      新年红1: new UGSkinManagers({
        skitType: '新年红1',
        skitString: '新年红 1蓝色风格',
        bgColor: ['#48A9D8', '#5CC2EC'],
        navBarBgColor: ['#58B8E4', '#58B8E4'],
        tabBarBgColor: '#8ED0EB',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#a4ddf3',
        homeContentSubColor: '#7CB5D8',
        cellBgColor: '#BDDEEF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#5f9bc6', '#fb5959'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
    };
    // 六合
    var lh = {
      //六合资料
      六合资料0: new UGSkinManagers({
        skitType: '六合资料0',
        skitString: '六合资料 0默认风格',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#ff566d', '#ff566d'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料1: new UGSkinManagers({
        skitType: '六合资料1',
        skitString: '六合资料 1蓝色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#58baf7', '#58baf7'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#58baf7', '#a8d6f3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料2: new UGSkinManagers({
        skitType: '六合资料2',
        skitString: '六合资料 2渐变',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#b36cff', '#87d8d1'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#b36cff', '#87d8d1'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料3: new UGSkinManagers({
        skitType: '六合资料3',
        skitString: '六合资料 3大红',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#fd0202', '#fd0202'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#FEC434', '#FE8A23'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#fd0202', '#f34a4a'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料4: new UGSkinManagers({
        skitType: '六合资料4',
        skitString: '六合资料 4粉红',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#fa7dc5', '#fa7dc5'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#FEC434', '#FE8A23'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#fa7dc5', '#f5c3e0'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料5: new UGSkinManagers({
        skitType: '六合资料5',
        skitString: '六合资料 5橙色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#ffa811', '#ffa811'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ffa811', '#f1cb8b'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料6: new UGSkinManagers({
        skitType: '六合资料6',
        skitString: '六合资料 6深绿',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#85b903', '#85b903'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#85b903', '#9fb568'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料7: new UGSkinManagers({
        skitType: '六合资料7',
        skitString: '六合资料 7水绿',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#8BC34A', '#8BC34A'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#8BC34A', '#a9c18e'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料8: new UGSkinManagers({
        skitType: '六合资料8',
        skitString: '六合资料 8淡青',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#48bdb1', '#48bdb1'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#48bdb1', '#7ab9b3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料9: new UGSkinManagers({
        skitType: '六合资料9',
        skitString: '六合资料 9紫色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#ac77e6', '#ac77e6'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ac77e6', '#d7c0f1'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      六合资料10: new UGSkinManagers({
        skitType: '六合资料10',
        skitString: '六合资料 10深蓝',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#3862AA', '#3862AA'],
        tabBarBgColor: '#FFFFFF',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#3862AA', '#7887a2'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
    };
    // 香槟金
    var xbj = {
      香槟金0: new UGSkinManagers({
        skitType: '香槟金0',
        skitString: '香槟金0 默认',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#f08c34', '#eb3323'],
        tabBarBgColor: '#262223',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#eb3323',

        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      香槟金1: new UGSkinManagers({
        skitType: '香槟金1',
        skitString: '香槟金1 黑色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#f08c34', '#eb3323'],
        tabBarBgColor: '#262223',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#eb3323',

        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      香槟金2: new UGSkinManagers({
        skitType: '香槟金2',
        skitString: '香槟金2 紫色',
        bgColor: ['#5262AF', '#5262AF'],
        navBarBgColor: ['#5262AF', '#5262AF'],
        tabBarBgColor: '#262223',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#eb3323',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#C6C6EA',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      香槟金3: new UGSkinManagers({
        skitType: '香槟金3',
        skitString: '香槟金3 红色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#f08c34', '#eb3323'],
        tabBarBgColor: '#262223',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#eb3323',

        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      香槟金4: new UGSkinManagers({
        skitType: '香槟金4',
        skitString: '香槟金4 浅蓝色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#f08c34', '#eb3323'],
        tabBarBgColor: '#262223',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#eb3323',

        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      香槟金5: new UGSkinManagers({
        skitType: '香槟金5',
        skitString: '香槟金5 绿色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#f08c34', '#eb3323'],
        tabBarBgColor: '#262223',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#eb3323',

        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      香槟金6: new UGSkinManagers({
        skitType: '香槟金6',
        skitString: '香槟金6 蓝色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#f08c34', '#eb3323'],
        tabBarBgColor: '#262223',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#eb3323',

        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      香槟金7: new UGSkinManagers({
        skitType: '香槟金7',
        skitString: '香槟金7 小红色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#f08c34', '#eb3323'],
        tabBarBgColor: '#262223',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#eb3323',

        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
    };
    // 简约
    var jy = {
      //简约
      简约模板0: new UGSkinManagers({
        skitType: '简约模板0',
        skitString: '简约模板 0蓝色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#4463A5', '#4463A5'],
        tabBarBgColor: '#F4F4F4',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#FEC434', '#FE8A23'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#fa7dc5', '#f5c3e0'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      简约模板1: new UGSkinManagers({
        skitType: '简约模板1',
        skitString: '简约模板 1红色',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#fb8787', '#e45353'],
        tabBarBgColor: '#F4F4F4',
        tabNoSelectColor: '#525252',
        tabSelectedColor: '#010101',
        progressBgColor: ['#FEC434', '#FE8A23'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#fa7dc5', '#f5c3e0'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
    };
    // 其他
    var other = {
      //石榴红
      石榴红: new UGSkinManagers({
        skitType: '石榴红',
        skitString: '石榴红 ',
        bgColor: ['#F5F5F5', '#F5F5F5'],
        navBarBgColor: ['#CC022C', '#CC022C'],
        tabBarBgColor: '#CC022C',
        tabNoSelectColor: '#FFFFFF',
        tabSelectedColor: '#F1B709',
        progressBgColor: ['#FEC434', '#FE8A23'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#E8A3B3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#d7213a', '#f99695'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //黑色模板
      黑色模板: new UGSkinManagers({
        skitType: '黑色模板',
        skitString: '黑色模板',
        bgColor: ['#171717', '#171717'],
        navBarBgColor: ['#333333', '#333333'],
        tabBarBgColor: '#313131',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#FFFFFF',
        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#343434',
        homeContentSubColor: '#353535',
        cellBgColor: '#181818',
        CLBgColor: '#202122',
        menuHeadViewColor: ['#323232', '#323232'],
        textColor1: '#FEFEFE',
        textColor2: '#C1C1C1',
        textColor3: '#555555',
        textColor4: '#000000',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //金沙模板
      金沙主题: new UGSkinManagers({
        skitType: '金沙主题',
        skitString: '金沙主题',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#323232', '#323232'],
        tabBarBgColor: '#323232',
        tabNoSelectColor: '#ffffff',
        tabSelectedColor: '#aab647',

        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
      //火山橙
      火山橙: new UGSkinManagers({
        skitType: '火山橙',
        skitString: '火山橙',
        bgColor: ['#FFFFFF', '#FFFFFF'],
        navBarBgColor: ['#f08c34', '#eb3323'],
        tabBarBgColor: '#262223',
        tabNoSelectColor: '#999999',
        tabSelectedColor: '#eb3323',

        progressBgColor: ['#d80000', '#fb5959'],
        homeContentColor: '#FFFFFF',
        homeContentSubColor: '#D3D3D3',
        cellBgColor: '#FFFFFF',
        CLBgColor: '#E6E6E6',
        menuHeadViewColor: ['#ff566d', '#ffbac3'],
        textColor1: '#111111',
        textColor2: '#555555',
        textColor3: '#C1C1C1',
        textColor4: '#FFFFFF',
        conversionCellColor: '#7BA2C2',
        intoViewColor: '#7BA2C2',
        moneyCellColor: '#9BB8CB',
      }),
    };
    Object.assign(UGSkinManagers.all, jd);
    Object.assign(UGSkinManagers.all, xnh);
    Object.assign(UGSkinManagers.all, lh);
    Object.assign(UGSkinManagers.all, xbj);
    Object.assign(UGSkinManagers.all, jy);
    Object.assign(UGSkinManagers.all, other);
  }
  static all: {[x: string]: UGSkinManagers} = {};
}

export var Skin1 = UGSkinManagers.sysConf();
