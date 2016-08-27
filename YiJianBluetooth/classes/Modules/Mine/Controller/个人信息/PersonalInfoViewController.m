//
//  PersonalInfoViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/26.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "HFStretchableTableHeaderView.h"

@interface PersonalInfoViewController (){
    User *_user;
    BOOL _edit;
    UITextField *_nameTextField;

}

@property (strong, nonatomic) UIImageView *picture;
@property (nonatomic, strong) HFStretchableTableHeaderView* stretchableTableHeaderView;

@end

@implementation PersonalInfoViewController



-(instancetype)initWithUser:(User *)user andEditable:(BOOL)editable{
//    self = [super init];
    self=[super initWithNibName:@"PersonalInfoViewController" bundle:nil];

    if (self) {
        _user = user;
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
    
    [self initwithPhonecell];
}

-(void) initwithnamecell{
    _namecell = [[UserNameCell alloc] initWithUsername:_user.name];
    _namecell.delegate = self;
}

-(void) initwithPhonecell{
    _phonecell = [[UserPhoneCell alloc] initWithUserPhone:_user.phone];
    _phonecell.delegate = self;
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"xiaoxixi.png"]];   // 保存文件的名称
    //UIGraphicsBeginImageContext(CGSizeMake(0, 630));
    self.picture.image = originalImage;
    NSData *imageData = UIImageJPEGRepresentation(self.picture.image, 0.5);
    [imageData writeToFile: filePath    atomically:YES];
//    [self uploadPic:filePath];
    
    
    //保存
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
            return nil;
            break;
        case 3:
            return nil;
            break;
        case 4:
            return nil;
            break;
        case 5:
            return nil;
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    NSInteger position = [indexPath row];
    
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

    _user.phone = phone;

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
