//
//  PersonalInfoViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/26.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "HFStretchableTableHeaderView.h"
#import "DateUtil.h"
#import "UsersDao.h"
#import "BlockUIAlertView.h"
#import "NewFile.h"

#import "PostUserAccountThred.h"
#import "Master.h"
#import "MasterDao.h"
#import "mUser.h"
#import "DeleteUserAccountThread.h"

@interface PersonalInfoViewController ()<UIPickerViewDataSource, UIPickerViewDelegate,UIAlertViewDelegate>
{
    User *_user;
    Master *_master;
    mUser *_mUser;
    BOOL _edit;
    UITextField *_nameTextField;
    NSInteger pickInterger;
    
    
    NSString *heightString;
    NSString *weightString;
    NSString *ageString;
    NSString *sexString;
    
    UIPickerView *_PickerView;
    UIDatePicker *datePic;
}
@property(nonatomic, strong)UIView *writeView;
@property(nonatomic, strong)UIView *toumingView;

@property (strong, nonatomic) UIImageView *picture;
@property (nonatomic, strong) HFStretchableTableHeaderView* stretchableTableHeaderView;


@property(nonatomic, strong)NSString *dateString;


@property(nonatomic, strong)NSMutableArray *heightArray;
@property(nonatomic, strong)NSMutableArray *weightArray;

@end

@implementation PersonalInfoViewController



-(instancetype)initWithUser:(User *)user WithMaster:(Master *)master andEditable:(BOOL)editable{
//    self = [super init];
    self=[super initWithNibName:@"PersonalInfoViewController" bundle:nil];

    if (self) {
        _master = master;
        if (user==nil) {
            _user = [[User alloc] init];
            
        }else{
            _user = user;

        }
        _edit = editable;
    }
    
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人信息";
    
 
    
    self.infotableview.delegate=self;
    self.infotableview.dataSource=self;
    [self.view addSubview:self.infotableview];
    [self setExtraCellLineHidden:self.infotableview];

    
    [self initLeftBarButtonItem];
    
    
    [self stretchableCreate];
//    [self tableData];
    [self headerCreate];
    
    [self initwithnamecell];
    [self initwithsexcell];
    [self initwithPhonecell];
    
    [self initwithheihgtcell];
    [self initwithweightcell];
    [self initwithbirthdatecell];

    //从我的亲友界面过来才有删除按钮
    if ([self.mineString isEqualToString:@"亲友"]) {
        if (_user) {
            [self initrightBarButtonItem:@"删除" action:@selector(deleteUser)];
        }
    }
    [self addArray];
}

- (void)deleteUser{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除此人" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self deleteData];
        }
    }
}

-(void)addArray{
    
    for (int i = 80; i < 241; i++) {
        [self.heightArray addObject:@(i)];
    }
    
    
    for (int j = 15; j < 121; j++) {
        [self.weightArray addObject:@(j)];
    }
    
    
}
-(void) initwithnamecell{
    _namecell = [[UserNameCell alloc] initWithUsername:_user.name];
    _namecell.delegate = self;
}

-(void) initwithPhonecell{
    _phonecell = [[UserPhoneCell alloc] initWithUserPhone:_user.phone];
    _phonecell.delegate = self;
}

-(void)initwithsexcell{
    _sexcell = [[UserSexCell alloc]initWithUserSex:_user.gender];
    _sexcell.delegate = self;
}

-(void)initwithweightcell{
    static NSString * cellIde=@"workingTitle";


    if (_user.weight) {
        _weightcell = [[UserInfoCell alloc]initWithUserTitle:@"体重" andUserinfo:[NSString stringWithFormat:@"%d",_user.weight] andreuseIdentifier:nil];
    }else{
        _weightcell = [[UserInfoCell alloc]initWithUserTitle:@"体重" andUserinfo:nil andreuseIdentifier:nil];
    }
    [_weightcell setRestorationIdentifier:cellIde];

//    _infocell.delegate = self;
}
-(void)initwithheihgtcell{
    static NSString * cellIde=@"workingTitle";
    
    if (_user.height) {
        _heihgtcell = [[UserInfoCell alloc]initWithUserTitle:@"身高" andUserinfo:[NSString stringWithFormat:@"%d",_user.height] andreuseIdentifier:nil];
    }else{
        _heihgtcell = [[UserInfoCell alloc]initWithUserTitle:@"身高" andUserinfo:nil andreuseIdentifier:nil];
    }

    [_heihgtcell setRestorationIdentifier:cellIde];

    //    _infocell.delegate = self;
}
-(void)initwithbirthdatecell{
    static NSString * cellIde=@"workingTitle";

    
    NSString *date = [DateUtil DateFormatToString:_user.birthdate WithFormat:@"yyyy-MM-dd"];
    if (date) {
        _agecell = [[UserInfoCell alloc]initWithUserTitle:@"出生日期" andUserinfo:date andreuseIdentifier:nil] ;

    }else{
        _agecell = [[UserInfoCell alloc]initWithUserTitle:@"出生日期" andUserinfo:nil andreuseIdentifier:nil] ;

    }
    [_agecell setRestorationIdentifier:cellIde];

    //    _infocell.delegate = self;
}
- (void)saveUser{

    
    
    [self getData];
    
    //[self showToast:@"保存成功"];
    
    //[self.navigationController popViewControllerAnimated:YES];

}
// header设置
- (void)headerCreate
{
    self.saveBtn  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.saveBtn.backgroundColor = UIColorFromRGB(0xc62828);
    [self.saveBtn setTintColor:[UIColor whiteColor]];
    [self.saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    self.saveBtn.frame = CGRectMake(SCR_W/2-100, SCR_H-NAVIGATION_HEIGHT-70, 200, 50);
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 6.0;
    self.saveBtn.layer.borderWidth = 1.0;
    self.saveBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.saveBtn addTarget:self action:@selector(saveUser) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.saveBtn];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(SCR_W/2 - 32, 40, 64, 64)];
    image.image = [UIImage imageNamed:@"txbg_v_1"];
    [self.view addSubview:image];
    
    self.picture = [[UIImageView alloc]initWithFrame:CGRectMake(SCR_W/2 - 30, 42, 60, 60)];
    [self.picture.layer setMasksToBounds:YES];
    [self.picture.layer setCornerRadius:29];
//    [self.picture sd_setImageWithURL:[NSURL URLWithString:[UserManager shareManager].user.picUrlMid] placeholderImage:[UIImage imageNamed:@"txcur_v_1"]];
    [self.picture setImage:[UIImage imageNamed:@"txcur_v_1"]];
    [self.view addSubview:self.picture];
    
    UIButton *changeImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeImg setFrame:CGRectMake(SCR_W/2 - 32, 40, 64, 64)];
    [changeImg.layer setMasksToBounds:YES];
    [changeImg addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    [changeImg.layer setCornerRadius:33];
    [self.view addSubview:changeImg];
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_stretchableTableHeaderView scrollViewDidScroll:scrollView];
}

- (void)viewDidLayoutSubviews
{
    [_stretchableTableHeaderView resizeView];
}
- (void)changeImage
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍  照" otherButtonTitles:@"使用相册", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"拍照");
        if ([self isCameraAvailable])
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate      = self;
            imagepicker.allowsEditing = YES;
            imagepicker.sourceType    = sourceType;
            [self presentViewController:imagepicker animated:YES completion:nil];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小君君提示" message:@"发生了什么？ 摄像头不可用" delegate:self cancelButtonTitle:@"知道啦~" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else if (buttonIndex == 1){
        NSLog(@"相册");
        if ([self isPhotoLibraryAvailable])
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate      = self;
            imagepicker.allowsEditing = YES;
            imagepicker.sourceType    = sourceType;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小君君提示" message:@"纳尼~ 图片库不可用" delegate:self cancelButtonTitle:@"再试试~" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark - 判断相机相册是否可用
- (BOOL)isCameraAvailable
{
    // 是否存在摄像头
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return YES;
    }
    return NO;
}

- (BOOL)isPhotoLibraryAvailable
{
    // 相册是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return YES;
    }
    return NO;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageOrientation imageOrientation = originalImage.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp){
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(originalImage.size);
        [originalImage drawInRect:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];
        originalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"xiaoxixi.png"]];   // 保存文件的名称
//    //UIGraphicsBeginImageContext(CGSizeMake(0, 630));

    self.picture.image = originalImage;
    NSData *imageData = UIImageJPEGRepresentation(self.picture.image, 0.5);
    
    NSString* fileName=[NSString stringWithFormat:@"%@_%@",[DateUtil DateFormatToString:[NSDate date] WithFormat:@"yyyyMMdd_HHmmss"],_master.username];
    NSString * localName=[NSString stringWithFormat:@"%@.png",fileName];
    
    NSString * key = [NSString stringWithFormat:@"client/work/%@/%@/%@",_master.username,[DateUtil DateFormatToString:[NSDate date] WithFormat:@"yyyy-MM-dd"],localName];
    NewFile* pic=[[NewFile alloc]init];
    pic.key=key;
    pic.name=localName;
    //保存
    [pic saveDataToCache:imageData];
    
    _user.headIcon_file = pic;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)stretchableCreate
{
    _stretchableTableHeaderView = [HFStretchableTableHeaderView new];
    [_stretchableTableHeaderView stretchHeaderForTableView:self.infotableview withView:_stretchView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return _namecell;
            break;
        case 1:
            return _phonecell;
            break;
        case 2:
            return _sexcell;
            break;
        case 3:
            return _heihgtcell;
            break;
        case 4:
            return _weightcell;
            break;
        case 5:
            return _agecell;
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    NSInteger position = [indexPath row];

    switch (position) {
        case 3:
            pickInterger = 3;
            [self addPickView:3];
            [_PickerView selectRow:90 inComponent:0 animated:NO];
            heightString = [NSString stringWithFormat:@"%@",self.heightArray[90]];
            
            break;
        case 4:
            pickInterger = 4;
            [self addPickView:4];
            if (_user.gender) {
                 [_PickerView selectRow:45 inComponent:0 animated:NO];
                 weightString = [NSString stringWithFormat:@"%@", self.weightArray[45]];
            }else{
               [_PickerView selectRow:60 inComponent:0 animated:NO];
                weightString = [NSString stringWithFormat:@"%@", self.weightArray[60]];
            }
            break;
        case 5:
            pickInterger = 5;
            [self addPickView:5];
            break;
            
        default:
            break;
    }
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -UserNameCellDelegate -
- (void)callbackUserName:(NSString *)name{
    NSLog(@"%@",name);
    _user.name = name;
}

- (void)callbackUserPhone:(NSString *)phone{
    NSLog(@"%@",phone);
    
    if (![self isMobileNumber:phone]) {
        [self showToast:@"电话号码格式错误!"];
    }else{
        _user.phone = phone;
    }

}

#pragma mark ========手机号验证码正则表达式
//手机号码验证
-(BOOL)isMobileNumber:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((16[0-9])|^((17[0-9])|^((14[0-9])|^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *phoneRegex = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|16[0-9]|17[0-9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (void)callbackusersex:(BOOL)usersex{
    NSLog(@"%d",usersex);
    _user.gender = usersex;
}


-(void)addPickView:(NSInteger)pickInterger{
    [self.view endEditing:YES];
    
    
    self.navigationController.navigationBarHidden = YES;
    _toumingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _toumingView.backgroundColor = UIColorFromRGB(0x777777);
    _toumingView.alpha = 0.4;
    [self.view addSubview:_toumingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toumingAction:)];
    [_toumingView addGestureRecognizer:tap];
    
    _writeView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 220, [UIScreen mainScreen].bounds.size.width, 220)];
    _writeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_writeView];
    
    
    UILabel *danweiLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, 5, 80, 30)];
    danweiLabel.textColor = UIColorFromRGB(0x777777);
    if (pickInterger== 3) {
        danweiLabel.text = @"单位：cm";
    }else if (pickInterger == 4){
        
        danweiLabel.text = @"单位：kg";
    }else if (pickInterger == 5){
        
        danweiLabel.hidden = YES;
    }
    [_writeView addSubview:danweiLabel];
    
    //添加取消按钮
    UIButton *quxiaoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 60, 30)];
    [quxiaoButton setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [quxiaoButton addTarget:self action:@selector(pickerViewQuXiaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [_writeView addSubview:quxiaoButton];
    
    //添加确定按钮
    UIButton *quedingButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60 , 5, 60, 30)];
    quedingButton.tag = pickInterger;
    [quedingButton setTitle:@"确定" forState:UIControlStateNormal];
    [quedingButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [quedingButton addTarget:self action:@selector(pickerViewQueDingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_writeView addSubview:quedingButton];
    
    //添加pickView
    
    if (pickInterger != 5) {
        _PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 180)];
        _PickerView.backgroundColor = UIColorFromRGB(0xeeeeee);
        _PickerView.delegate = self;
        _PickerView.dataSource = self;
        [_writeView addSubview:_PickerView];
    }else{
        
        datePic = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCR_W - 20, 180)];
        datePic.backgroundColor = [UIColor whiteColor];
        datePic.datePickerMode = UIDatePickerModeDate;
        [datePic addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [_writeView addSubview:datePic];
    }
    
    
}

#pragma mark =======弹出pickView 上面取消按钮点击事件=======
-(void)pickerViewQuXiaoAction:(UIButton *)sender{
    self.navigationController.navigationBarHidden = NO;
    [_toumingView removeFromSuperview];
    [_writeView removeFromSuperview];
    
}
#pragma mark =======弹出pickView 上面取确定钮点击事件=======
-(void)pickerViewQueDingAction:(UIButton *)sender{
    self.navigationController.navigationBarHidden = NO;
    if (sender.tag == 3) {
        [_heihgtcell setuserInfo:heightString];
        _user.height = [heightString integerValue];
        
    }else if (sender.tag == 4){
        [_weightcell setuserInfo:weightString];
        _user.weight = [weightString integerValue];
        
    }else if(sender.tag == 5){
        
        if (self.dateString == nil) {
            self.dateString = @"未填写";
        }
        [_agecell  setuserInfo:self.dateString];
        
    }
    
    [_toumingView removeFromSuperview];
    [_writeView removeFromSuperview];
}
#pragma mark ======添加在类型弹出灰色背景上的手势========
-(void)toumingAction:(UITapGestureRecognizer *)sender{
    self.navigationController.navigationBarHidden = NO;
    [_toumingView removeFromSuperview];
    [_writeView removeFromSuperview];
    
}


// datePicker日期改变会调用此方法
-(void)dateChanged:(id)sender
{
    
    
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *selected = [datePicker date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    _user.birthdate = selected;

    
    self.dateString  = [dateFormatter stringFromDate:selected];
    
    
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickInterger == 3) {
        return self.heightArray.count;
    }else if (pickInterger == 4){
        
        return self.weightArray.count;
    }else{
     return 1;
    }
   
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickInterger == 3) {
        NSString *height = [NSString stringWithFormat:@"%@",self.heightArray[row]];
        return height;
    }else{
        
        NSString *weight = [NSString stringWithFormat:@"%@", self.weightArray[row]];
        return weight;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (pickInterger == 3) {
        
        heightString = [NSString stringWithFormat:@"%@",self.heightArray[row]];
    }else{
        weightString = [NSString stringWithFormat:@"%@", self.weightArray[row]];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:22]];
        [pickerLabel setTextColor:UIColorFromRGB(0x010000)];
    }
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(NSMutableArray *)heightArray{

    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}
-(NSMutableArray *)weightArray{

    if (!_weightArray) {
        _weightArray = [NSMutableArray array];
    }
    return _weightArray;
}

#pragma mark ========================保存个人信息网络请求
-(void)getData{

    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    if (self.uid  != nil && ![self.uid isEqualToString:@""]) {
         [data setObject:self.uid forKey:@"uid"];
    }
    [data setObject:_user.name forKey:@"aliasName"];
    [data setObject:_user.phone forKey:@"phone"];
    [data setObject:@(_user.gender) forKey:@"gender"];
    [data setObject:@(_user.height) forKey:@"height"];
    [data setObject:@(_user.weight) forKey:@"weight"];
    NSString *date = [DateUtil DateFormatToString:_user.birthdate WithFormat:@"yyyy-MM-dd"];
    [data setObject:date forKey:@"age"];
    
    PostUserAccountThred *account = [[PostUserAccountThred alloc] initWithAid:[NSString stringWithFormat:@"%ld",_master.aid] withToken:_master.token widthData:data];

    [account requireonPrev:^{
        
        [self showHud:@"正在保存中..." onView:self.view];
    } success:^(NSDictionary *response) {
        [self hideHud];
        [self showToast:@"保存成功"];
        _mUser = [[mUser alloc] init];
        _mUser.name = _user.name;
        [_master.users addObject:_mUser];
        [MasterDao saveMasterInfo:_master];
        [self.navigationController popViewControllerAnimated:YES];
    } unavaliableNetwork:^{
        [self hideHud];
        [self showToast:@"网络未连接"];
    } timeout:^{
        [self hideHud];
        [self showToast:@"网络连接超时"];
    } exception:^(NSString *message) {
        [self hideHud];
        if (message) {
            [self showToast:message];
        }else{
            [self showToast:@"网络连接错误"];
        }
    }];
}

#pragma mark ================删除个人信息
-(void)deleteData{

    DeleteUserAccountThread *delete = [[DeleteUserAccountThread alloc] initWithAid:[NSString stringWithFormat:@"%ld",_master.aid] withuid:self.uid withToken:_master.token];
    [delete requireonPrev:^{
        [self showHud:@"正在删除中..." onView:self.view];
    } success:^(NSDictionary *response) {
        [self hideHud];
        [self showToast:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } unavaliableNetwork:^{
        [self hideHud];
        [self showToast:@"网络未连接"];
    } timeout:^{
        [self hideHud];
        [self showToast:@"网络连接超时"];
    } exception:^(NSString *message) {
        [self hideHud];
        if (message) {
            [self showToast:message];
        }else{
            [self showToast:@"网络连接错误"];
        }
    }];
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
