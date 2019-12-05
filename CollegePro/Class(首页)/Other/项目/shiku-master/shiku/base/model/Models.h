//
//  Models.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

 /// 所有的对象都定义在此文件

#pragma mark - models

@class ADDRESS;
@class ARTICLE;
@class ARTICLE_GROUP;
@class BANNER;
@class BONUS;
@class BRAND;
@class CART_GOODS;
@class CATEGORY;
@class COMMENT;
@class CONFIG;
@class EXPRESS;
@class FILTER;
@class GOODS;
@class GOOD_ATTR;
@class GOOD_RANK_PRICE;
@class GOOD_SPEC;
@class GOOD_VALUE;
@class INVOICE;
@class ORDER;
@class ORDER_GOODS;
@class PAGINATION;
@class PAYMENT;
@class PHOTO;
@class PRICE_RANGE;
@class REGION;
@class SESSION;
@class SHIPPING;
@class SIGNUP_FIELD;
@class SIGNUP_FIELD_VALUE;
@class SIMPLE_GOODS;
@class STATUS;
@class TOTAL;
@class USER;
@class COLLECT_GOODS;
@class SHOP_ITEM;

/**
 *  地址信息
 */
@interface ADDRESS : NSObject
@property (nonatomic, retain) NSNumber *		rec_id;
@property (nonatomic, retain) NSString *		address;
@property (nonatomic, retain) NSString *		best_time;
@property (nonatomic, retain) NSNumber *		city;//杭州市的地区代码
@property (nonatomic, retain) NSNumber *		country;//中国的地区代码
@property (nonatomic, retain) NSNumber *		default_address;//是否为默认地址0:不是  1：是
@property (nonatomic, retain) NSNumber *		district;//西湖区的地区代码
@property (nonatomic, retain) NSString *		email;
@property (nonatomic, retain) NSString *		mobile;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		province;//浙江省的地区代码
@property (nonatomic, retain) NSString *		sign_building;
@property (nonatomic, retain) NSString *		tel;
@property (nonatomic, retain) NSString *		zipcode;
@property (nonatomic, retain) NSString *		country_name;//中国
@property (nonatomic, retain) NSString *		province_name;//浙江省
@property (nonatomic, retain) NSString *		city_name;//杭州市
@property (nonatomic, retain) NSString *		district_name;//西湖区
@property (nonatomic, retain) NSString *        consignee;//收货人姓名
@end

@interface ARTICLE : NSObject
@property (nonatomic, retain) NSString *		short_title;
@property (nonatomic, retain) NSString *		title;
@property (nonatomic, retain) NSNumber *		rec_id;
@end

@interface ARTICLE_GROUP : NSObject
@property (nonatomic, retain) NSArray *		article;
@property (nonatomic, retain) NSString *		name;
@end

@interface BANNER : NSObject
@property (nonatomic, retain) NSString *		action;
@property (nonatomic, retain) NSNumber *		action_id;
@property (nonatomic, retain) NSString *		description;
@property (nonatomic, retain) PHOTO *		photo;
@property (nonatomic, retain) NSString *		url;
@end

@interface BONUS : NSObject
@property (nonatomic, retain) NSNumber * type_id;
@property (nonatomic, retain) NSString * type_name;
@property (nonatomic, retain) NSNumber * type_money;
@property (nonatomic, retain) NSString * bonus_id;
@property (nonatomic, retain) NSString * bonus_money_formated;
@end

@interface BRAND : NSObject
@property (nonatomic, retain) NSString *		url;
@property (nonatomic, retain) NSNumber *		brand_id;
@property (nonatomic, retain) NSString *		brand_name;
@end
/**
 *  购物车中得商品信息
 */
@interface CART_GOODS : NSObject
@property (nonatomic, assign) BOOL              isInEditMode;//是否为编辑状态
@property (nonatomic, assign) BOOL              isSeleced;//是否选中
@property (nonatomic, strong) NSIndexPath*      indexPath;
@property (nonatomic, retain) NSNumber *		can_handsel;
@property (nonatomic, retain) NSString *		extension_code;
@property (nonatomic, retain) NSString *		formated_goods_price;
@property (nonatomic, retain) NSString *		formated_market_price;
@property (nonatomic, retain) NSString *		formated_subtotal;
@property (nonatomic, retain) NSArray  *		goods_attr;//商品属性
@property (nonatomic, retain) NSString  *		goods_strattr;
@property (nonatomic, retain) NSNumber *		goods_attr_id;
@property (nonatomic, retain) NSNumber *		goods_id;
@property (nonatomic, retain) NSString *		goods_name;
@property (nonatomic, assign) NSInteger	        goods_number;
@property (nonatomic, assign) CGFloat 	    	goods_price;
@property (nonatomic, assign) CGFloat 	    	goods_weight;
@property (nonatomic, retain) NSString *		goods_sn;
@property (nonatomic, retain) PHOTO    *		img;
@property (nonatomic, retain) NSNumber *		is_gift;
@property (nonatomic, retain) NSNumber *		is_real;
@property (nonatomic, retain) NSNumber *		is_shipping;
@property (nonatomic, retain) NSString *		market_price;
@property (nonatomic, retain) NSNumber *		parent_id;
@property (nonatomic, retain) NSString *		pid;
@property (nonatomic, retain) NSNumber *		rec_type;
@property (nonatomic, retain) NSString *		subtotal;
@property (nonatomic, retain) NSNumber *		rec_id;
@end
/**
 *  分类对象
 */
@interface CATEGORY : NSObject
@property (nonatomic, retain) NSArray *		    children;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		value;
@property (nonatomic, retain) NSString *		rich_value;
@property (nonatomic, retain) NSNumber *		rec_id;
@property (nonatomic, retain) PHOTO *		    img;
@property (nonatomic, retain) NSString *		add_time;
@property (nonatomic, retain) NSString *		type;
@property (nonatomic, retain) NSString *        imgStr;
@property (nonatomic, retain) NSArray *         list;
@property (nonatomic, retain) NSArray *         info_list;
@end

/**
 *  新品推荐对象
 */
@interface TOP_CATEGORY : NSObject
@property (nonatomic, retain) NSArray *		children;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		rec_id;
@end

@interface COMMENT : NSObject
@property (nonatomic, retain) NSString *		author;
@property (nonatomic, retain) NSString *		content;
@property (nonatomic, retain) NSString *		create;
@property (nonatomic, retain) NSString *		re_content;
@property (nonatomic, retain) NSNumber *		rec_id;
@end

@interface CONFIG : NSObject
@property (nonatomic, retain) NSString *		close_comment;
@property (nonatomic, retain) NSString *		service_phone;
@property (nonatomic, retain) NSNumber *		shop_closed;
@property (nonatomic, retain) NSString *		shop_desc;
@property (nonatomic, retain) NSNumber *		shop_reg_closed;
@property (nonatomic, retain) NSString *		site_url;
@property (nonatomic, retain) NSString *		goods_url;
@end
/**
 *  物流信息
 */
@interface EXPRESS : NSObject
@property (nonatomic, retain) NSString *		context;
@property (nonatomic, retain) NSString *		time;
@end

/**
 *  过滤器
 */
@interface FILTER : NSObject
@property (nonatomic, retain) PAGINATION *		pagenation;
@property (nonatomic, retain) NSNumber *		brand_id;
@property (nonatomic, retain) NSNumber *		category_id;
@property (nonatomic, retain) NSNumber *		status;
@property (nonatomic, retain) NSString *		keywords;
@property (nonatomic, retain) PRICE_RANGE *		price_range;
@property (nonatomic, retain) NSString *		sort_field;
@property (nonatomic, retain) NSString *		sort_by;
@end
/**
 *  商品信息
 */
@interface GOODS : NSObject
@property (nonatomic, retain) NSNumber *		rec_id;
@property (nonatomic, retain) NSNumber *		brand_id;
@property (nonatomic, retain) NSNumber *		cat_id;
@property (nonatomic, retain) NSNumber *		click_count;
@property (nonatomic, retain) NSString *		goods_name;
@property (nonatomic, retain) NSString *		goods_number;
@property (nonatomic, retain) NSString *		goods_sn;
@property (nonatomic, retain) NSString *		goods_weight;
@property (nonatomic, retain) NSNumber *		sales;
@property (nonatomic, retain) PHOTO *           img;
@property (nonatomic, retain) NSNumber *		collected;
@property (nonatomic, retain) NSNumber *		collected_count;
@property (nonatomic, retain) NSNumber *		shop_collected;
@property (nonatomic, retain) NSNumber *		shop_collected_count;
@property (nonatomic, retain) PHOTO *           shop_img;
@property (nonatomic, retain) NSString *		shop_id;
@property (nonatomic, retain) NSString *		shop_name;
@property (nonatomic, retain) NSString *		shop_rates;
@property (nonatomic, retain) NSString *		shop_uname;
@property (nonatomic, retain) NSString *		shop_address;
@property (nonatomic, retain) NSNumber *		shop_item_stock;
@property (nonatomic, retain) NSNumber *		shop_item_count;
@property (nonatomic, retain) NSNumber *		integral;
@property (nonatomic, retain) NSNumber *		good_stocks;//库存
@property (nonatomic, retain) NSNumber *		is_shipping;
@property (nonatomic, retain) NSString *		market_price;
@property (nonatomic, retain) NSArray *         pictures;
@property (nonatomic, retain) NSString *		promote_end_date;
@property (nonatomic, retain) NSString *		promote_price;
@property (nonatomic, retain) NSString *		formated_promote_price;
@property (nonatomic, retain) NSString *		promote_start_date;
@property (nonatomic, retain) NSArray *         properties;
@property (nonatomic, retain) NSArray *         rank_prices;
@property (nonatomic, retain) NSString*         shop_price;
@property (nonatomic, retain) NSArray *         specification;
@property (nonatomic, retain) NSNumber *		goods_id;
@property (nonatomic, retain) NSArray  *		goods_attr;
@end

@interface GOODS_DETAIL_INFO : NSObject
@property (nonatomic, retain) NSArray *         item_info;
@property (nonatomic, retain) NSArray *         logs_list;
@property (nonatomic, retain) NSArray *         logs_info_list;
@property (nonatomic, retain) NSArray *         producer;
@property (nonatomic, retain) NSArray *         score;
@end

@interface GOOD_ATTR : NSObject
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		value;
@property (nonatomic, retain) NSArray *         children;
@end

@interface GOOD_RANK_PRICE : NSObject
@property (nonatomic, retain) NSNumber *		rec_id;
@property (nonatomic, retain) NSString *		price;
@property (nonatomic, retain) NSString *		rank_name;
@end

@interface GOOD_SPEC : NSObject
@property (nonatomic, retain) NSNumber *		attr_type;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSArray *         value;
@end

@interface GOOD_VALUE : NSObject
@property (nonatomic, retain) NSString *		format_price;
@property (nonatomic, retain) NSNumber *		rec_id;
@property (nonatomic, retain) NSString *		label;
@property (nonatomic, retain) NSNumber *		price;
@end

@interface GOOD_SPEC_VALUE : NSObject
@property (nonatomic, retain) GOOD_SPEC *       spec;
@property (nonatomic, retain) GOOD_VALUE *      value;
@end

@interface INVOICE : NSObject
@property (nonatomic, retain) NSString *		value;
@property (nonatomic, retain) NSNumber *		rec_id;
@end

@interface ORDER_INFO : NSObject
@property (nonatomic, retain) NSNumber *		order_id;
@property (nonatomic, retain) NSString *		order_sn;
@property (nonatomic, retain) NSString *		order_amount;
@property (nonatomic, retain) NSString *		subject;
@property (nonatomic, retain) NSString *		desc;
@property (nonatomic, retain) NSString *		pay_code;
@property (nonatomic, retain) NSString *		pay_time;
@property (nonatomic, retain) NSString *		order_time;
@property (nonatomic, retain) NSString *		check_time;
@property (nonatomic, retain) NSString *		total_fee;
@property (nonatomic, retain) NSString *		order_status;
@property (nonatomic, retain) NSString *		order_sstatus;
@end

@interface ORDER : NSObject
@property (nonatomic, retain) NSNumber *		rec_id;
@property (nonatomic, retain) NSString *        formated_integral_money;//积分
@property (nonatomic, retain) NSString *        formated_shipping_fee;
@property (nonatomic, retain) NSString *    	formated_bonus;//红包
@property (nonatomic, retain) ADDRESS*          address_item;
@property (nonatomic, retain) SHOP_ITEM*        shop_item;
@property (nonatomic, retain) PAYMENT*          payment_item;
@property (nonatomic, retain) ORDER_INFO *		order_info;
@property (nonatomic, retain) SHIPPING*         shipping_item;
@end

@interface ORDER_GOODS : NSObject
@property (nonatomic, retain) NSString *		formated_shop_price;
@property (nonatomic, retain) NSNumber *		goods_number;
@property (nonatomic, retain) PHOTO *	    	img;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		subtotal;
@property (nonatomic, retain) NSNumber *		goods_id;
@end


@interface PAGINATION : NSObject
@property (nonatomic, retain) NSNumber*		count;
@property (nonatomic, assign) BOOL  		more;
@property (nonatomic, retain) NSNumber*		page;
@property (nonatomic, retain) NSNumber*		total;
- (BOOL)hasMore;
@end

typedef enum {
    PaymentTypeNone,
    PaymentTypeUserBalance,
    PaymentTypeCashOnDelivery,
    PaymentTypeAlipay,//支付宝支付
    PaymentTypeWeixin//微信支付
} PaymentType;

/**
 *  支付信息，请对照支付api
 */
@interface PAYMENT : NSObject
@property (assign, nonatomic) NSInteger         payment_id;
@property (nonatomic, retain) NSString *		format_pay_fee;
@property (nonatomic, retain) NSNumber *		is_cod;
@property (nonatomic, retain) NSString *		pay_code;
@property (nonatomic, retain) NSString *		pay_desc;
@property (nonatomic, retain) NSString *		pay_fee;
@property (nonatomic, retain) NSString *		pay_name;
@property (nonatomic, retain) NSString *		pay_time;
@property (nonatomic, retain) NSNumber *		pay_id;

@property (strong, nonatomic) NSString *        code;
@property (strong, nonatomic) NSString *        appid;
@property (strong, nonatomic) NSString *        partner_id;
@property (strong, nonatomic) NSString *        nonceStr;
@property (strong, nonatomic) NSString *        package;
@property (strong, nonatomic) NSString *        prepay_id;
@property (strong, nonatomic) NSString *        sign;
@property (strong, nonatomic) NSString *        time_stamp;
@property (strong, nonatomic) NSString *        name;
@property (assign, nonatomic) PaymentType       type;

@end
/**
 *  图片对象
 */
@interface PHOTO : NSObject
@property (nonatomic, retain) NSString *		img;
@property (nonatomic, retain) NSString *		thumb;
@property (nonatomic, retain) NSString *		url;//大图
@property (nonatomic, retain) NSString *		small;
@property (nonatomic, retain) NSString *		type;//类型  2商品

@end

/**
 *  价格区间
 */
@interface PRICE_RANGE : NSObject
@property (nonatomic, retain) NSNumber *		price_min;
@property (nonatomic, retain) NSNumber *		price_max;
@end

/**
 *  地区
 */
@interface REGION : NSObject
@property (nonatomic, retain) NSNumber *		more;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		parent_id;
@property (nonatomic, retain) NSNumber *		rec_id;
@end

@interface SESSION : NSObject
@property (nonatomic, retain) NSString *		sid;
@property (nonatomic, retain) NSNumber *		uid;
@end
/**
 *  物流信息
 */
@interface SHIPPING : NSObject
@property (nonatomic, retain) NSString *		format_shipping_fee;
@property (nonatomic, retain) NSString *		free_money;
@property (nonatomic, retain) NSString *		insure;
@property (nonatomic, retain) NSString *		insure_formated;
@property (nonatomic, retain) NSString *		shipping_code;
@property (nonatomic, retain) NSString *		shipping_sn;
@property (nonatomic, retain) NSString *		shipping_desc;
@property (nonatomic, retain) NSString *		shipping_time;
@property (nonatomic, retain) NSString *		shipping_fee;
@property (nonatomic, retain) NSString *		shipping_name;
@property (nonatomic, retain) NSNumber *		support_cod;
@property (nonatomic, retain) NSNumber *		shipping_id;
@end

@interface SIGNUP_FIELD : NSObject
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSNumber *		need;
@property (nonatomic, retain) NSNumber *		rec_id;
@end

@interface SIGNUP_FIELD_VALUE : NSObject
@property (nonatomic, retain) NSString *		value;
@property (nonatomic, retain) NSNumber *		rec_id;
@end

/**
 *  商品信息缩略版
 */
@interface SIMPLE_GOODS : NSObject
@property (nonatomic, retain) NSString *		brief;//简介
@property (nonatomic, retain) PHOTO *	    	img;
@property (nonatomic, retain) NSString *		market_price;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		promote_price;//促销价格
@property (nonatomic, retain) NSString *		shop_price;
@property (nonatomic, retain) NSNumber *		rec_id;
@property (nonatomic, retain) NSNumber *		goods_id;
@end

@interface STATUS : NSObject
@property (nonatomic, retain) NSNumber *		error_code;
@property (nonatomic, retain) NSString *		error_desc;
@property (nonatomic, retain) NSNumber *		succeed;
@end

@interface TOTAL : NSObject
@property (nonatomic, retain) NSString *		goods_weight;
@property (nonatomic, retain) NSString *		goods_amount;
@property (nonatomic, retain) NSString *		goods_price;
@property (nonatomic, retain) NSString *		market_price;
@property (nonatomic, retain) NSNumber *		real_goods_count;
@property (nonatomic, retain) NSString *		save_rate;
@property (nonatomic, retain) NSString *		saving;
@property (nonatomic, retain) NSNumber *		virtual_goods_count;
@end

typedef enum {
    SHIKU,
    CMMAC
} AccessTokenType;

@interface AccessToken : NSObject
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *accessToken;
@property (assign, nonatomic) NSInteger expires;
@property (assign, nonatomic) AccessTokenType type;
@end

/**
 *  用户信息，相应的信息请参见后台api
 */
@interface USER : NSObject
@property (nonatomic, strong) NSMutableArray *attentionList;
@property (nonatomic, retain) NSNumber *		collection_num;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		img;

@property (nonatomic, retain) NSString *		password;
@property (nonatomic, retain) NSString *		newpassword;
@property (nonatomic, retain) NSString *		card_id;//身份证号码
@property (nonatomic, retain) NSString *		email;
@property (nonatomic, retain) NSString *		token;
@property (nonatomic, retain) NSString *		sex;
@property (nonatomic, retain) NSString *		birthday;
@property (nonatomic, retain) NSString *		intro;
@property (nonatomic, retain) NSDictionary *	order_num;
@property (nonatomic, retain) NSString *		rank_name;
@property (nonatomic, retain) NSString *		avatarimg;
@property (nonatomic, retain) NSString *		rank_level;
@property (nonatomic, retain) NSNumber *		tele;
@property (nonatomic, strong) NSString *        likeNum;
@property (nonatomic, strong) NSString *        attentionNum;
@property (nonatomic, strong) NSString *        priNum;
/**
 * tele  手机号码
 */
@property (retain, nonatomic) NSString *		teleStr;

@property (retain, nonatomic) NSNumber *		user_id;
@property (retain, nonatomic) NSNumber *		msg_express;
@property (retain, nonatomic) NSNumber *		msg_sales;
@property (retain, nonatomic) NSNumber *		msg_sys;
@property (retain, nonatomic) NSString *		score;
@property (retain, nonatomic) NSString *		coupon_num;
@property (retain, nonatomic) NSString *		order_fahuo;
@property (retain, nonatomic) NSString *		order_fukuan;
@property (retain, nonatomic) NSString *		order_shouhuo;
@property (retain, nonatomic) NSString *		order_tuikuan;

@property (retain, nonatomic) NSString *		weibo;
@property (retain, nonatomic) NSString *		weixin;
@property (retain, nonatomic) NSString *		qq;
@property (retain, nonatomic) NSString *		provence;
@property (retain, nonatomic) NSString *		city;
@property (retain, nonatomic) NSString *		area;

@property (retain, nonatomic) NSString *usertype;
@property (retain, nonatomic) NSString* keyid;
- (BOOL)authorized;
- (NSError *)valid;
@end

/**
 *  收藏对象，详情请对照各Controller对应的.xib文件
 */
@interface COLLECT_GOODS : SIMPLE_GOODS
@property (nonatomic, retain) NSString *		shop_id;//店铺id
@property (nonatomic, retain) NSString *		shop_name;//店铺名称
@property (nonatomic, retain) NSString *		sub_title1;//标题1
@property (nonatomic, retain) NSString *		sub_title2;//标题2
@property (nonatomic, assign) BOOL isEditing; // TODO:
@end

@interface SHOP_ITEM: NSObject
@property (nonatomic, assign) BOOL              isSeleced;
@property (nonatomic, assign) NSInteger         section;
@property (nonatomic, strong) NSMutableArray*   cart_goods_list;//CART_GOODS
@property (nonatomic, strong) TOTAL*            total;
@property (nonatomic, strong) NSString*         name;
@property (nonatomic, strong) NSString*         rec_id;
@end

@class AdItem;
/**
 *  首页的对象
 */
@interface HomeItems : NSObject <NSCoding>
@property (strong, nonatomic) NSArray *section0List;
@property (strong, nonatomic) NSArray *section1List;
@property (strong, nonatomic) NSArray *section2List;
@property (strong, nonatomic) NSArray *section3List;
@property (strong, nonatomic) NSArray *section4List;
@property (strong, nonatomic) NSArray *section5List;
@property (strong, nonatomic) NSArray *section6List;
@end

