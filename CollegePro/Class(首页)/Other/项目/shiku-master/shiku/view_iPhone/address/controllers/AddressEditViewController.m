//
//  AddressEditViewController.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "AddressEditViewController.h"
#import "RegionBackend.h"
#import "RegionView.h"
#import "RegionMode.h"
@interface AddressEditViewController ()<RefionViewDelegate>
{
    NSString * m_cityPid;
    NSString * m_districtPid;
}
@property(nonatomic ,strong)RegionBackend * m_RegionBackend;

@property(nonatomic ,strong)RegionView * m_RegionView;

@property(nonatomic ,strong)UIButton * provincebutt;

@property(nonatomic ,strong)UIButton * citybutt;

@property(nonatomic ,strong)UIButton * districtbutt;
@end

@implementation AddressEditViewController
- (void)deleteBtnTapped:(id)sender {
//    [[self.backend requestDelAddressWithID:[self.address.rec_id integerValue] user:[[App shared] currentUser]]
//     subscribeNext:[self didUpdate:@"删除成功"]];
    self.address.default_address=[[NSNumber alloc] initWithInt:1];
    self.address.address=self.tfDesc.text;
    self.address.name=self.tfName.text;
    self.address.tel=self.tfTell.text;
    
    [[self.backend requestUpdateAddress:self.address]
     subscribeNext:[self didUpdate:@"保存成功"]];
}

-(id)initWithAddress:(ADDRESS *)address
{
    self=[super init];
    if (self) {
        isedit=YES;
        self.address=address;
        self.backend=[UserBackend shared];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=BG_COLOR;
    
    self.title=isedit?@"新建收货地址":@"编辑收货地址";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    
    UIBarButtonItem *rbtn =[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAddress)];
    rbtn.tintColor=TEXT_COLOR_BLACK;
    self.navigationItem.rightBarButtonItem=rbtn;
   
    
    self.TableView = [[UITableView alloc]initWithFrame:CGRectMake(1,1,CGRectGetWidth(self.view.frame),50*5) style:UITableViewStylePlain];
    self.TableView.backgroundColor=WHITE_COLOR;
    self.TableView.delegate=self;
    self.TableView.dataSource=self;
    self.TableView.backgroundColor = [UIColor clearColor];
    self.TableView.showsVerticalScrollIndicator = NO;
    self.TableView.contentInset = UIEdgeInsetsMake(0, 0, 0.0, 0.0);
    [self.view addSubview:self.TableView];
    
    self.deletwBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deletwBtn.frame = CGRectMake(160, 10, 60, 30);
    self.deletwBtn.backgroundColor=MAIN_COLOR;
    self.deletwBtn.layer.cornerRadius=5;
    self.deletwBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.deletwBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [self.deletwBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.deletwBtn setBackgroundImage:[UIImage imageNamed:@"buttBac.png"] forState:UIControlStateNormal];
    [self.deletwBtn addTarget:self action:@selector(deleteBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deletwBtn];
    [self createRegionView];
}

-(void)createRegionView
{
    self.m_RegionView = [[RegionView alloc]initWithFrame:CGRectMake(0, 0, 100, 100) Pid:0 Tag:100];
    self.m_RegionView.hidden = YES;
    self.m_RegionView.m_delegate = self;
    [self.view addSubview:self.m_RegionView];
}

-(void)SelecateCell:(RegionMode *)mode Tag:(NSInteger)Tag
{
    switch (Tag) {
        case 100:
        {
            m_cityPid = mode.ID;
            self.m_RegionView.hidden = YES;
            self.citybutt.hidden = NO;
            self.address.province_name = mode.Name;
            self.address.province = [NSNumber numberWithInteger:[mode.ID integerValue]];
            self.provincebutt.titleLabel.text = mode.Name;
            
        }
            
            break;
        case 101:
        {
            m_districtPid = mode.ID;
            self.districtbutt.hidden = NO;
            self.m_RegionView.hidden = YES;
            self.address.city_name = mode.Name;
            self.address.city = [NSNumber numberWithInteger:[mode.ID integerValue]];
            self.citybutt.titleLabel.text = mode.Name;
        }
            break;
        case 102:
        {
            self.m_RegionView.hidden = YES;
            self.address.district_name = mode.Name;
            self.address.district = [NSNumber numberWithInteger:[mode.ID integerValue]];
            self.districtbutt.titleLabel.text = mode.Name;
        }
            break;
            
        default:
            
            break;
    }
}
-(void)saveAddress
{
    self.address.address=self.tfDesc.text;
    self.address.name=self.tfName.text;
    self.address.tel=self.tfTell.text;
    self.address.zipcode=self.tfZipCode.text;
    [[self.backend requestUpdateAddress:self.address]
     subscribeNext:[self didUpdate:@"保存成功"]];
}
-(void)deleteAddress
{
//    [[self.backend requestDelAddressWithID:[self.address.rec_id integerValue] user:[[App shared] currentUser]]
//     subscribeNext:[self didUpdate:@"删除成功"]];
    
}
- (void(^)(RACTuple *))didUpdate:(NSString *)text
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        //        ResponseResult *rs=(ResponseResult *)parameters;
        //        if (rs.success) {
        if ([self.delegate respondsToSelector:@selector(didAddressUpdate:controller:msg:)]) {
            [self.delegate didAddressUpdate:self.address controller:self msg:text];
        }
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 1;
    }
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *_cell=[[UITableViewCell alloc] init];
    if (indexPath.section==0) {
        //        AddressEditTableViewCell *cell;
        //        Address *address;
        //        cell = [tableView
        //                dequeueReusableCellWithIdentifier:AddressListTableCell];
        
        if (indexPath.row==0) {
            self.tfName=[[UITextField alloc] initWithFrame:CGRectMake(20, 2, _cell.frame.size.width-40, _cell.frame.size.height)];
            self.tfName.placeholder=@"收件人姓名";
            self.tfName.text=self.address.consignee;
            self.tfName.delegate=self;
            self.tfName.returnKeyType=UIReturnKeyDone;
            [_cell addSubview:self.tfName];
        }
        else if(indexPath.row==1)
        {
            self.tfTell=[[UITextField alloc] initWithFrame:CGRectMake(20, 2, _cell.frame.size.width-40, _cell.frame.size.height)];
            self.tfTell.placeholder=@"手机号码";
            self.tfTell.text=self.address.tel;
            self.tfTell.keyboardType=UIKeyboardTypeNumberPad;
            self.tfTell.returnKeyType=UIReturnKeyDone;
            [_cell addSubview:self.tfTell];
            //[cell setData:@"" placeholder:@"请输入电话"];
        }
        else if(indexPath.row==2)
        {
            self.tfZipCode=[[UITextField alloc] initWithFrame:CGRectMake(20, 2, _cell.frame.size.width-40, _cell.frame.size.height)];
            self.tfZipCode.placeholder=@"邮政编码";
            self.tfZipCode.text=self.address.zipcode;
            self.tfZipCode.keyboardType=UIKeyboardTypeNumberPad;
            self.tfZipCode.returnKeyType=UIReturnKeyDone;
            [_cell addSubview:self.tfZipCode];
            //[cell setData:@"" placeholder:@"请输入电话"];
        }
        else if(indexPath.row==3)
        {
//            self.tfArea=[[UITextField alloc] initWithFrame:CGRectMake(20, 2, _cell.frame.size.width-40, _cell.frame.size.height)];
//            self.tfArea.placeholder=@"省、市、区";
//            if (!self.address.province_name||![self.address.province_name isEqualToString:@""]) {
//                 self.tfArea.text=[NSString stringWithFormat:@"%@ %@ %@", self.address.province_name, self.address.city_name, self.address.district_name];
//            }
//            self.tfArea.delegate=self;
//            [_cell addSubview:self.tfArea];
            _cell.textLabel.text = @"地址:";
            UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala.png"]];
            img.frame = CGRectMake(45, 12, 8, 8);
            self.provincebutt = [UIButton buttonWithType:UIButtonTypeCustom];
            self.provincebutt.frame = CGRectMake(80, 10, 60, 30);
            self.provincebutt.tag = 100;
            [self.provincebutt setTitle:@"请选择" forState:UIControlStateNormal];
            self.provincebutt.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.provincebutt setBackgroundImage:[UIImage imageNamed:@"buttBac.png"] forState:UIControlStateNormal];
            [self.provincebutt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.provincebutt addTarget:self action:@selector(buttClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.provincebutt addSubview:img];
            [_cell.contentView addSubview:self.provincebutt];
            
            UIImageView * img1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala.png"]];
            img1.frame = CGRectMake(45, 12, 8, 8);
            self.citybutt = [UIButton buttonWithType:UIButtonTypeCustom];
            self.citybutt.frame = CGRectMake(160, 10, 60, 30);
            self.citybutt.tag = 101;
            self.citybutt.hidden = YES;
            self.citybutt.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.citybutt setTitle:@"请选择" forState:UIControlStateNormal];
            [self.citybutt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.citybutt setBackgroundImage:[UIImage imageNamed:@"buttBac.png"] forState:UIControlStateNormal];
            [self.citybutt addTarget:self action:@selector(buttClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.citybutt addSubview:img1];
            [_cell.contentView addSubview:self.citybutt];
            
            UIImageView * img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala.png"]];
            img2.frame = CGRectMake(45, 12, 8, 8);
            self.districtbutt = [UIButton buttonWithType:UIButtonTypeCustom];
            self.districtbutt.frame = CGRectMake(240, 10, 60, 30);
            self.districtbutt.tag = 102;
            self.districtbutt.hidden = YES;
            self.districtbutt.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.districtbutt setTitle:@"请选择" forState:UIControlStateNormal];
            [self.districtbutt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.districtbutt setBackgroundImage:[UIImage imageNamed:@"buttBac.png"] forState:UIControlStateNormal];
            [self.districtbutt addTarget:self action:@selector(buttClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.districtbutt addSubview:img2];
            [_cell.contentView addSubview:self.districtbutt];
            
        }
        else if(indexPath.row==4)
        {
            self.tfDesc=[[UITextField alloc] initWithFrame:CGRectMake(20, 2, _cell.frame.size.width-40, _cell.frame.size.height)];
            self.tfDesc.placeholder=@"详细地址";
            self.tfDesc.text=self.address.address;
            self.tfDesc.delegate=self;
            self.tfDesc.returnKeyType=UIReturnKeyDone;
            [_cell addSubview:self.tfDesc];
        }
        //_cell=cell;
    }
    else
    {
//        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 2, _cell.frame.size.width, _cell.frame.size.height)];
//        btn.backgroundColor=[UIColor redColor];
//        btn.layer.cornerRadius=5;
//        [btn setTitle:@"删除地址" forState:UIControlStateNormal];
//        [_cell addSubview:btn];
//        _cell.backgroundColor=[UIColor clearColor];
//        _cell.layer.borderWidth=0;
//        _cell.layer.borderColor=[UIColor clearColor].CGColor;
//        UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 50)];
//        textLabel.layer.backgroundColor=MAIN_COLOR.CGColor;
//        textLabel.text=@"删除地址";
//        textLabel.textColor=[UIColor whiteColor];
//        textLabel.textAlignment=NSTextAlignmentLeft;
//        textLabel.layer.cornerRadius=5;
//        textLabel.layer.borderWidth  = 1.0f;
//        textLabel.layer.borderColor  = MAIN_COLOR.CGColor;
//        textLabel.layer.cornerRadius = 5.0f;
//        [_cell addSubview:textLabel];
        
    }
    _cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return _cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    CheckoutTableViewCellHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellHeader];
    //    view.shop_item=[self.cart.checkout_shop_list objectAtIndex:section];
    //    view.shop_item.section=section;
    //    //    headerView.delegate=self;
    //    [view bind];
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //    CheckoutTableViewCellFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellFooter];
    //    view.shop_item=[self.cart.shop_list objectAtIndex:section];
    //    view.shop_item.section=section;
    //    [view bind];
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - .address sele
-(void)buttClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {
            self.citybutt.hidden = YES;
            self.districtbutt.hidden = YES;
            self.m_RegionView.frame = CGRectMake(80, 150, 80, 150);
            self.m_RegionView.hidden = NO;
            [self.m_RegionView ReloadView:@"0" Tag:sender.tag];
            
        }
            break;
        case 101:
        {
            self.districtbutt.hidden = YES;
            self.m_RegionView.frame = CGRectMake(160, 150, 80, 150);
            [self.m_RegionView ReloadView:m_cityPid Tag:sender.tag];
            self.m_RegionView.hidden = NO;
            
        }
            break;
        case 102:
        {
            
            self.m_RegionView.frame = CGRectMake(240, 150, 80, 150);
            [self.m_RegionView ReloadView:m_districtPid Tag:sender.tag];
            self.m_RegionView.hidden = NO;
        
        }
            break;
            
        default:
            break;
    }


}
#pragma mark - HZAreaPicker delegate

-(void)pickerDidTapedOKBtn:(TAreaPickerView *)picker
{
    if(!self.address)
    {
        self.address=[ADDRESS new];
    }
    self.address.province_name=picker.locate.state;
    self.address.city_name=picker.locate.city;
    self.address.district_name=picker.locate.district;
    self.tfArea.text=[NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    [picker cancelPicker];
}

-(void)cancelLocatePicker
{
    [locatePicker cancelPicker];
    locatePicker.delegate = nil;
    locatePicker = nil;
}
#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.tfArea) {
        [self.tfDesc resignFirstResponder];
        [self.tfName resignFirstResponder];
        [self.tfTell resignFirstResponder];
        [self.tfZipCode resignFirstResponder];
        [self cancelLocatePicker];
//        locatePicker = [[TAreaPickerView alloc] initWithStyle:TAreaPickerWithStateAndCityAndDistrict frame:self.view.frame delegate:self];
//        [locatePicker showInView:self.view];
       
        return NO;
        
    }
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self cancelLocatePicker];
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self cancelLocatePicker];
    [textField resignFirstResponder];
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
