//
//  NetWork.h
//  GuizhouEquityTrading
//
//  Created by mac on 15/10/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#ifndef NetWork_h
#define NetWork_h

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width

//股权交易
#define SERVERURL @"http://192.168.1.84:8080"
//天津投
//#define SERVERURL @"http://192.168.1.110:8805"

//连接失败提示语
#define notNetworkConnetTip @"网络不稳定，请检查网络是否连接；或者服务器是否开启。"


#define USERLogin @"/service/checkLogin"
#define USERLogout @"/app/logout"
//信息公告
#define USERinfoList @"/app/info/list"

//股权类别字典查询
#define USERQueryGqlb @"/app/gqjy/market/queryGqlb"
//股权行情
#define USERqueryEquityMarket @"/app/gqjy/market/queryEquityMarket"
//我的股权资产分页数据
#define USERmyGqzcPaging @"/app/wdzh/wdzc/myGqzcPaging"

//股权类别字典查询-当日委托/撤单
#define USERqueryDdztDict @"/app/gqjy/entrust/queryDdztDict"
//客户当日委托查询
#define USERqueryTodayEntrust @"/app/gqjy/entrust/queryTodayEntrust"
//客户当日委托撤单
#define USERentrustWithdraw @"/app/gqjy/entrust/entrustWithdraw"
//成交数据
#define USERtransactionPageData @"/app/gqjy/transaction/transactionPageData"
//查询可买卖数量
#define USERqueryKmmsl @"/app/gqjy/trade/queryKmmsl"
//股权五档行情
#define USERqueryGqhq @"/app/gqjy/trade/queryGqhq"
//资金账号查询
#define USERqueryZjzh @"/app/gqjy/trade/queryZjzh"
//股权买卖风险揭示
#define USERfxjsAgreement @"/app/gqjy/trade/fxjsAgreement"
//股权买卖提交
#define USERequityTradeSubmit @"/app/gqjy/trade/equityTradeSubmit"




//股权挂牌详情页
#define USERequityHangMarketDetail @"/app/gqjy/trade/equityHangMarketDetail"
//股权挂牌行情
#define USERqueryEquityHangMarket @"/app/gqjy/market/queryEquityHangMarket"

//股权买卖交易日与交易时段判断
#define USERequityTradeCheck @"/app/gqjy/trade/equityTradeCheck"
//股权挂牌手续费
#define USERequityTradeSxf @"/app/gqjy/trade/equityTradeSxf"
//股权挂牌手提交
#define USERequityHangMarketBuy_Submit @"/app/gqjy/trade/equityHangMarketBuy_Submit"
//交易基数
#define USERqueryJyjs @"/app/gqjy/trade/queryJyjs"

//协议
#define USERwebsiteagreement @" page/website/agreement/index_app?code=RGXY600001"


#endif /* NetWork_h */
