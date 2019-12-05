//
//  OffLineMapViewController.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/29.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "OffLineMapViewController.h"
#import "ExponsionCell1.h"
#import "ExponsionCell2.h"
#import "MapLoadDownTableViewCell.h"
#import "SVProgressHUD.h"
#import "BlockUI.h"


@implementation OffLineMapViewController
@synthesize offLineMapView;

-(void)loadView{
    [super loadView];
    self.offLineMapView = [[OffLineMapView alloc]initWithController:self];
    
    [self.view addSubview:self.offLineMapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setTitle:@"离线地图"];
    
    self.offLineManger = [TOffLineManger sharesInstance];
    self.offLineManger.delegate = self;
    self.offLineMapSearch = self.offLineManger.MapListManger;
    
    // 更新离线地图列表
    [self.offLineManger UpDateMapList];
    
    self.offLineMapView.downLoadTableView.delegate = self;
    self.offLineMapView.downLoadTableView.dataSource = self;
    
    self.offLineMapView.cityTableView.delegate = self;
    self.offLineMapView.cityTableView.dataSource = self;
    
    [self.offLineMapView.cityTableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.offLineManger.delegate=nil;
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == offLineMapView.cityTableView) {
        if (self.isOpen) {
            if (self.selectIndex.section == section) {
                // 全部城市列表-省内的城市个数
                TProvinceInfor *pro = [_offLineMapSearch.m_arrprovince objectAtIndex:section];
                return [pro.arrCitys count];
                
            }
        }
        
    }
    else if(tableView == offLineMapView.downLoadTableView){
        
        return self.offLineManger.arrDownLoadingMapList.count;
        
    }
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == offLineMapView.cityTableView) {

        return [self.offLineMapSearch.m_arrprovince count];
        
    }
    
    return 1;
}

//定义单元格样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == offLineMapView.cityTableView) {
        
        // 全部城市列表
        TProvinceInfor *pro = [_offLineMapSearch.m_arrprovince objectAtIndex:indexPath.section];
        TCityInfor *city = [pro.arrCitys objectAtIndex:indexPath.row];
        
        if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
            
            static NSString *CellIdentifier = @"ExponsionCell2";
            ExponsionCell2 *cell2 = (ExponsionCell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell2) {
                cell2 = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            
            cell2.titleLabel.text=city.strcityName;
            if (city.iVectMapSize/1024/1024>0) {
                
                cell2.sizeLabel.text=[NSString stringWithFormat:@"(%.1dMB)",city.iVectMapSize/1024/1024];
            }
            else{
                cell2.sizeLabel.text=[NSString stringWithFormat:@"(%.1dKB)",city.iVectMapSize/1024];
            }
            
            
            //遍历判断是否该城市已经下载
            if (city.imapVerstatus == 1 || city.imapVerstatus == 2
                ||city.imapVerstatus==3){
                
                [self changeCellStatus:cell2 AndBMKOLUpdateElement:city];
            }
            
            return cell2;
        }
        else{
            static NSString *CellIdentifier = @"ExponsionCell1";
            ExponsionCell1 *cell1 = (ExponsionCell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell1) {
                cell1 = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            }
            
            int iVectMapSize=0;
            for (int i=0; i<pro.arrCitys.count; i++) {
                TCityInfor *city = [pro.arrCitys objectAtIndex:i];
                iVectMapSize+=city.iVectMapSize;
            }
            if (iVectMapSize/1024/1024>0) {
                
                cell1.sizeLabel.text=[NSString stringWithFormat:@"(%.1dMB)",iVectMapSize/1024/1024];
            }
            else{
                cell1.sizeLabel.text=[NSString stringWithFormat:@"(%.1dKB)",iVectMapSize/1024];
            }
            
            cell1.titleLabel.text=pro.strcityName;
            
            if ([pro.arrCitys count]>1 ) {
                cell1.arrowImageView.image = [UIImage imageNamed:@"map_down_img"];
                
                //遍历判断是否该城市已经下载
                if (city.imapVerstatus == 1 || city.imapVerstatus == 2
                    ||city.imapVerstatus==3){
                    
                    [self changeCellStatus:cell1 AndBMKOLUpdateElement:city];
                }
                
                
            }else{
                
                [cell1 changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
            }
            
            return cell1;
            
        }
        
        
    }
    
    else{
        
        static NSString *CellIdentifier = @"OffMapDownLoadTableViewCell";
        MapLoadDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
            cell = [[MapLoadDownTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        TDownLoadingCity *city = [self.offLineManger.arrDownLoadingMapList objectAtIndex:indexPath.row];
        cell.cityName.text=city.strName;
        cell.updateInfo=city;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, cell.frame.size.width, 0.5)];
        headLineView.backgroundColor =  [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
        [cell.contentView insertSubview:headLineView atIndex:0];
        
        return cell;
        
    }
    
    
}
//判断城市列表各项的状态
- (void)changeCellStatus:(UITableViewCell*)cell AndBMKOLUpdateElement:(TCityInfor *)city{
    
    cell.tag = 200;//这里把已经下载的cell添加tag，后面点击下载可以判断是否该城市已经下载
    if ([cell isMemberOfClass:[ExponsionCell2 class]]) {
        
        ExponsionCell2 *cell2 = (ExponsionCell2*)cell;
        cell2.sizeLabel.textColor = [UIColor redColor];
        cell2.titleLabel.textColor = [UIColor redColor];
        
        
        if(city.imapVerstatus == 1){
            cell2.sizeLabel.text = @"正在下载";
        }
        else if (city.imapVerstatus ==2){
            cell2.sizeLabel.text = @"已下载";
            cell2.sizeLabel.textColor = [UIColor blueColor];
            cell2.titleLabel.textColor = [UIColor blueColor];
            
        }
        else if(city.imapVerstatus == 3){
            cell2.sizeLabel.text = @"有更新";
            
        }
    }
    else{
        ExponsionCell1 *cell1 = (ExponsionCell1*)cell;
        cell1.sizeLabel.textColor = [UIColor redColor];
        cell1.titleLabel.textColor = [UIColor redColor];
        
        if(city.imapVerstatus == 1){
            cell1.sizeLabel.text = @"正在下载";
            
        }
        else if (city.imapVerstatus ==2){
            cell1.sizeLabel.text = @"已下载";
            cell1.sizeLabel.textColor = [UIColor blueColor];
            cell1.titleLabel.textColor = [UIColor blueColor];
            
        }
        else if(city.imapVerstatus == 3){
            cell1.sizeLabel.text = @"有更新";
            
        }
    }
}
#pragma mark - UITableViewDelegate
//row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == offLineMapView.cityTableView) {
        return 40.0f;
    }else{
        return 45.0f;
    }
    
}


//点击列表项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == offLineMapView.cityTableView ) {
        // 全部城市列表
        TProvinceInfor *pro = [_offLineMapSearch.m_arrprovince objectAtIndex:indexPath.section];
        TCityInfor *city = [pro.arrCitys objectAtIndex:indexPath.row];
        
        if ([pro.arrCitys count]==1) {
            //没有二级目录
            [offLineMapView.cityTableView deselectRowAtIndexPath:indexPath animated:YES];
            
            TDownLoadingCity *downcity = [[TDownLoadingCity alloc] initWithCityInfor:city maptype:0];
            [self.offLineManger AddOneDownLoad:downcity];
            // 添加 得到地图列表管理类
            self.offLineMapSearch = self.offLineManger.MapListManger;
            
            return;
            
        }
        
        if (indexPath.row == 0) {
            if ([indexPath isEqual:self.selectIndex]) {
                self.isOpen = NO;
                [self didSelectCellRowFirstDo:NO nextDo:NO];
                self.selectIndex = nil;
                
            }else
            {
                if (!self.selectIndex) {
                    self.selectIndex = indexPath;
                    [self didSelectCellRowFirstDo:YES nextDo:NO];
                    
                }else
                {
                    
                    [self didSelectCellRowFirstDo:NO nextDo:YES];
                }
            }
            
        }
        else{
            
            [offLineMapView.cityTableView deselectRowAtIndexPath:indexPath animated:YES];
            TDownLoadingCity *downcity = [[TDownLoadingCity alloc] initWithCityInfor:city maptype:0];
            [self.offLineManger AddOneDownLoad:downcity];
            [self.offLineManger StartDownLoadOneMap:downcity];
            [self.offLineMapView.downLoadTableView reloadData];
        }
       
    }
    else{
        
        TDownLoadingCity *city = [_offLineManger.arrDownLoadingMapList objectAtIndex:indexPath.row];
        
   //     NSArray *array = [NSArray arrayWithObject:indexPath];
        if (city.istatus == 0) {
            // 先停止下载地图
            if ([self.offLineManger StopDownMap]) {
                // 等待下载->下载
                [self.offLineManger StartDownLoadOneMap:city];
              //  [self.offLineMapView.downLoadTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else if (city.istatus == 1) {
            // 正在下载->暂停
            
            [self.offLineManger StopDownMap];
           // [self.offLineMapView.downLoadTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
        }
        else if (city.istatus == 2) {
            // 先停止下载地图
            if ([self.offLineManger StopDownMap]) {
                // 暂停下载->下载
                [self.offLineManger StartDownLoadOneMap:city];
            //    [self.offLineMapView.downLoadTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        [self.offLineMapView.downLoadTableView reloadData ];
     }
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    ExponsionCell1 *cell = (ExponsionCell1 *)[self.offLineMapView.cityTableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.offLineMapView.cityTableView beginUpdates];
    
    NSInteger section = self.selectIndex.section;
    
    TProvinceInfor *pro = [_offLineMapSearch.m_arrprovince objectAtIndex:section];
    NSInteger contentCount = pro.arrCitys.count-1 ;
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i =1; i < contentCount+1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {
        [self.offLineMapView.cityTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
        
    }
    else
    {
        [self.offLineMapView.cityTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    
    [self.offLineMapView.cityTableView endUpdates];
    
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.offLineMapView.cityTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.offLineMapView.cityTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}




#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}



#pragma mark - TOffLineMangerDelegate

// 下载完成
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadOver:(TDownLoadingCity *)mapinfor {
    NSLog(@"TOffLineManger DownLoadOver CityName is %@, %d", mapinfor.strName, mapinfor.iIndexOfcityList);
    
    [ offLineMapView.cityTableView reloadData];
    [offLineMapView.downLoadTableView reloadData];
    
    
}

// 开始一个新的下载
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadstart:(TDownLoadingCity *)mapinfor {
    NSLog(@"TOffLineManger DownLoadstart CityName is %@, index = %d", mapinfor.strName, mapinfor.iIndexOfcityList);
    
    // 开始一个下载 得到地图列表管理类
  //  self.offLineMapSearch = self.offLineManger.MapListManger;
    [ offLineMapView.cityTableView reloadData];
    [offLineMapView.downLoadTableView reloadData];
    
}

- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadstart:(TDownLoadingCity *)mapinfor error:(NSError *)error {
    NSString *strLog = [NSString stringWithFormat:@"下载%@离线地图时出错!", mapinfor.strName];
    NSLog(@"%@", strLog);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:strLog delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

    
    // 开始一个下载 得到地图列表管理类
 //   self.offLineMapSearch = self.offLineManger.MapListManger;
    
    [ offLineMapView.cityTableView reloadData];
    [offLineMapView.downLoadTableView reloadData];
    
}

// 停止下载
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadStop:(TDownLoadingCity *)mapinfor {
    NSLog(@"TOffLineManger DownLoadStop CityName is %@, %d", mapinfor.strName, mapinfor.iIndexOfcityList);
    
    // 开始一个下载 得到地图列表管理类
 //   self.offLineMapSearch = self.offLineManger.MapListManger;
    
    [self.offLineMapView.cityTableView reloadData];
    
    // 更新下载列表

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:mapinfor.iIndexOfcityList inSection:0];
    NSArray *array = [NSArray arrayWithObject:indexPath];
    [self.offLineMapView.downLoadTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
    
    
}

// 收到下载数据
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadData:(TDownLoadingCity *)mapinfor {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:mapinfor.iIndexOfcityList inSection:0];
    NSArray *array = [NSArray arrayWithObject:indexPath];
    [self.offLineMapView.downLoadTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
    
    
}

- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownInfor:(TDownLoadingCity *)mapinfor error:(NSError *)error {
    NSString *strLog = [NSString stringWithFormat:@"下载%@离线地图时出错!", mapinfor.strName];
    NSLog(@"%@", strLog);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:strLog delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    [self.offLineMapView.cityTableView reloadData];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:mapinfor.iIndexOfcityList inSection:0];
    NSArray *array = [NSArray arrayWithObject:indexPath];
    [self.offLineMapView.downLoadTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
    
    
}

- (void)UpdateListOver:(TOffLineManger *)offlinemanger {
    NSLog(@"UpdateListOver");
    self.offLineMapSearch = self.offLineManger.MapListManger;
    [ offLineMapView.cityTableView reloadData];
    [offLineMapView.downLoadTableView reloadData];
    
    
}

- (void)UpDateList:(TOffLineManger *)offlinemanger error:(NSError *)error {
    NSString *strLog = [NSString stringWithFormat:@"UpDateList error, error = %d", error.code];
    NSLog(@"%@", strLog);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:strLog delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];

}




#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}





@end
