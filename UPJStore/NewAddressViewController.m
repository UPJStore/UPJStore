//
//  NewAddressViewController.m
//  UPJStore
//
//  Created by 邝健锋 on 16/3/15.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "NewAddressViewController.h"
#import "MyAddressViewController.h"
#import "AFNetworking.h"
#import "UIViewController+CG.h"
#import "MBProgressHUD.h"

@interface NewAddressViewController ()<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITextField *nameTextField;
    UITextField *phoneNumberTextField;
    UITextField *idcardTextField;
    UITextField *cityTextField;
    UITextView *fullAddressTextView;
    UILabel *headLabel;
    NSString *nameStr;
    NSString *phoneNumberStr;
    NSString *idcardStr;
    NSString *provinceStr;
    NSString *cityStr;
    NSString *areaStr;
    NSString *fullAddressStr;
    NSMutableArray *data;
    NSMutableArray *data2;
    NSMutableArray *areaArray;
    NSMutableArray *cityArray;
    NSMutableArray *provinceArray;
    UIPickerView *pickView;
    UIAlertController *alertCon;
}

@property (nonatomic,strong)MBProgressHUD *loadingHud;

@end

@implementation NewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *backcolor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    //  UIColor *btncolor = [UIColor colorWithRed:204.0/255 green:34.0/255 blue:69.0/255 alpha:1];
    UIColor *fontcolor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    UIColor *textcolor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    UIColor *holdcolor = [UIColor colorWithWhite:0.75 alpha:1];
    
    self.navigationItem.title = @"新建收货地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui_@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];


    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction:)];
    
    
    self.view.backgroundColor = backcolor;
    
    UIView *newAddressView = [[UIView alloc]initWithFrame:CGRectMake1(0, 0, 414, 672)];
    [self.view addSubview:newAddressView];
    
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake1(13, 13, 388, 40)];
    nameTextField.placeholder = @"收货人姓名：";
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.font = [UIFont systemFontOfSize:16];
    nameTextField.textColor = textcolor;
    [newAddressView addSubview:nameTextField];
    
    phoneNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake1(13, 64, 388, 40)];
    phoneNumberTextField.placeholder = @"手机号码：";
    phoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    phoneNumberTextField.backgroundColor = [UIColor whiteColor];
    phoneNumberTextField.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [newAddressView addSubview:phoneNumberTextField];
    
    idcardTextField = [[UITextField alloc]initWithFrame:CGRectMake1(13, 115, 388, 40)];
    idcardTextField.placeholder = @"身份证：";
    idcardTextField.borderStyle = UITextBorderStyleRoundedRect;
    idcardTextField.backgroundColor = [UIColor whiteColor];
    idcardTextField.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    idcardTextField.keyboardType = UIKeyboardTypeDefault;
    [newAddressView addSubview:idcardTextField];
    
    cityTextField = [[UITextField alloc]initWithFrame:CGRectMake1(13, 166, 388, 40)];
    cityTextField.placeholder = @"省市区";
    cityTextField.borderStyle = UITextBorderStyleRoundedRect;
    cityTextField.backgroundColor = [UIColor whiteColor];
    cityTextField.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    cityTextField.delegate = self;
    [newAddressView addSubview:cityTextField];
    
    fullAddressTextView = [[UITextView alloc]initWithFrame:CGRectMake1(13, 217, 388, 76)];
    [fullAddressTextView.layer setCornerRadius:5.0];
    [fullAddressTextView.layer setBorderWidth:0.2];
    [fullAddressTextView.layer setBorderColor:fontcolor.CGColor];
    fullAddressTextView.delegate = self;
    fullAddressTextView.textAlignment = 0;
    fullAddressTextView.backgroundColor = [UIColor whiteColor];
    fullAddressTextView.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    [newAddressView addSubview:fullAddressTextView];
    
    headLabel = [[UILabel alloc]initWithFrame:CGRectMake1(6, 6, 300, 16)];
    headLabel.text = @"详细地址";
    headLabel.font = [UIFont systemFontOfSize:CGFloatMakeY(16)];
    headLabel.textColor = holdcolor;
    [fullAddressTextView addSubview:headLabel];
    
    pickView = [[UIPickerView alloc]initWithFrame:CGRectMake1(0, 500, 414, 234)];
    pickView.delegate = self;
    pickView.dataSource = self;
    
    UIToolbar *finishBar = [[UIToolbar alloc]initWithFrame:CGRectMake1(0, 10, 414, 40)];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style: UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
    
    UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = CGFloatMakeX(345);
    [finishBar setItems:@[fixedSpace,doneButton]];
    cityTextField.inputAccessoryView = finishBar;
    cityTextField.inputView = pickView;
    
    //判断是否进入编辑状态
    if (_isedit) {
        nameTextField.text = _editnameStr;
        phoneNumberTextField.text = _editphoneStr;
        idcardTextField.text = _editidcardStr;
        cityTextField.text = [NSString stringWithFormat:@"%@%@%@",_editprovinceStr,_editcityStr,_editareaStr];
        fullAddressTextView.text = _editfulladdressStr;
        headLabel.hidden = YES;
    }
    
    provinceArray = [NSMutableArray new];
    cityArray = [NSMutableArray new];
    //数据解析
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    // NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    data = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    for (NSDictionary *dic in data) {
        NSString *province = dic[@"state"];
        [provinceArray addObject:province];
    }
    for (NSDictionary *dic in data[0][@"cities"]) {
        [cityArray addObject:dic[@"city"]];
        areaArray = dic[@"areas"];
    }
}

-(void)finishAction{
    [cityTextField endEditing:YES];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAction:(UIButton*)button
{
    [self setMBHUD];
    //返回数据
    nameStr = [NSString stringWithFormat:@"%@",nameTextField.text];
    phoneNumberStr = [NSString stringWithFormat:@"%@",phoneNumberTextField.text];
    idcardStr = [NSString stringWithFormat:@"%@",idcardTextField.text];
    fullAddressStr = [NSString stringWithFormat:@"%@",fullAddressTextView.text];
    if ([self validatePhone:phoneNumberStr])
    {
        if ([self checkUserIdCard:idcardStr])
        {
            if (!nameStr) {
                nameStr = @" ";
            }
            if (!phoneNumberStr) {
                phoneNumberStr = @" ";
            }
            if (!idcardStr) {
                idcardStr = @" ";
            }
            if (!provinceStr) {
                provinceStr = @" ";
            }
            if(!cityStr)
            {
                cityStr = @" ";
            }
            if(!areaStr)
            {
                areaStr = @" ";
            }
            if(!fullAddressStr)
            {
                fullAddressStr = @" ";
            }
            if (_isedit)
            {
                if (provinceStr&&cityStr&&areaStr)
                {
                    NSDictionary *dic = @{@"mobile":phoneNumberStr,@"mid":[self returnMid],@"appkey":APPkey,@"name":nameStr,@"idcard":idcardStr,@"province":provinceStr,@"city":cityStr,@"area":areaStr,@"address":fullAddressStr,@"aid":_aid};
                    [self postDataWith:dic];
                }else
                {
                    NSDictionary *dic = @{@"mobile":phoneNumberStr,@"mid":[self returnMid],@"appkey":APPkey,@"name":nameStr,@"idcard":idcardStr,@"province":_editprovinceStr,@"city":_editcityStr,@"area":_editareaStr,@"address":fullAddressStr,@"aid":_aid};
                    [self postDataWith:dic];
                }
            }
            else
            {
                NSDictionary *dic = @{@"mobile":phoneNumberStr,@"mid":[self returnMid],@"appkey":APPkey,@"name":nameStr,@"idcard":idcardStr,@"province":provinceStr,@"city":cityStr,@"area":areaStr,@"address":fullAddressStr};
                [self postDataWith:dic];
            }
        }
        else
        {
            alertCon = [UIAlertController alertControllerWithTitle:nil message:@"请输入正确的15或18位身份证" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_loadingHud hideAnimated:YES];
                _loadingHud = nil;
            }];
            [alertCon addAction:okAction];
            [self presentViewController:alertCon animated:YES completion:nil];
            
        }
    }
    else
    {
        alertCon = [UIAlertController alertControllerWithTitle:nil message:@"请输入正确的11位手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_loadingHud hideAnimated:YES];
            _loadingHud = nil;
        }];
        [alertCon addAction:okAction];
        
        [self presentViewController:alertCon animated:YES completion:nil];
        
    }
}

-(void)postDataWith:(NSDictionary*)dic
{
    
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager POST:kaddAddress parameters:Ndic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        [_loadingHud hideAnimated:YES];
        _loadingHud = nil;
        [self.delegate tableViewReflash];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"failure%@",error);
    }];
}

-(BOOL)validatePhone:(NSString*)phone
{
    NSString*phoneRegex=@"1[3|5|7|8|][0-9]{9}";
    NSPredicate*phoneTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return[phoneTest evaluateWithObject:phone];
}

- (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [nameTextField resignFirstResponder];
    [phoneNumberTextField resignFirstResponder];
    [idcardTextField resignFirstResponder];
    [cityTextField resignFirstResponder];
    [fullAddressTextView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    headLabel.hidden = YES;
    if (fullAddressTextView.text.length == 0) {
        headLabel.hidden = NO;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return [provinceArray count];
            break;
        case 1:
            return [cityArray count];
            break;
        case 2:
            if ([areaArray count]) {
                return [areaArray count];
                break;
            }
        default:
            return 0;
            break;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinceArray objectAtIndex:row];
            break;
        case 1:
            return [cityArray objectAtIndex:row];
            break;
        case 2:
            if ([areaArray objectAtIndex:row]) {
                return [areaArray objectAtIndex:row];
                break;
            }
        default:
            return 0;
            break;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            data2 = data[row][@"cities"];
            areaArray = data2[0][@"areas"];
            [cityArray removeAllObjects];
            for (NSDictionary *dic in data2) {
                [cityArray addObject:dic[@"city"]];
            }
            [pickView reloadComponent:1];
            [pickView selectRow:0 inComponent:1 animated:YES];
            [pickView reloadComponent:2];
            [pickView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        case 1:
        {
            areaArray = data2[row][@"areas"];
            [pickView reloadComponent:2];
            [pickView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger row1 = [pickView selectedRowInComponent:0];
    NSInteger row2 = [pickView selectedRowInComponent:1];
    NSInteger row3 = [pickView selectedRowInComponent:2];
    provinceStr = [provinceArray objectAtIndex:row1];
    
    cityStr = [cityArray objectAtIndex:row2];
    NSString *str = @"";
    if (areaArray.count != 0) {
        areaStr = [areaArray objectAtIndex:row3];
        str = [[provinceStr stringByAppendingString:cityStr] stringByAppendingString:areaStr];
    }else
    {
        str = [provinceStr stringByAppendingString:cityStr];
        areaStr = nil;
    }
    cityTextField.text = str;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark -- 加载动画
-(void)setMBHUD{
    _loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set the custom view mode to show any view.
    /*
     _loadingHud.mode = MBProgressHUDModeCustomView;
     UIImage *gif = [UIImage sd_animatedGIFNamed:@"youpinji"];
     
     UIImageView *gifView = [[UIImageView alloc]initWithImage:gif];
     _loadingHud.customView = gifView;
     */
    _loadingHud.bezelView.backgroundColor = [UIColor clearColor];
    _loadingHud.animationType = MBProgressHUDAnimationFade;
    _loadingHud.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
