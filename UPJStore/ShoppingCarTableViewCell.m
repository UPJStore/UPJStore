//
//  ShoppingCarTableViewCell.m
//  UPJStore
//
//  Created by upj on 16/3/26.
//  Copyright © 2016年 UPJApp. All rights reserved.
//

#import "ShoppingCarTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShoppingCartViewController.h"
#import "AFNetWorking.h"
#import "UIView+cg.h"


static CGFloat CELL_HEIGHT =100;

@interface ShoppingCarTableViewCell () <UITextFieldDelegate>

@property (nonatomic,strong) UIButton * selectBt;
@property (nonatomic,strong) UIImageView * shoppingImgView;
@property (nonatomic,strong) UIImageView * spuImgView;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) ChangeCountView *changeView;
@property (nonatomic,strong) UILabel * priceLab;
@property (nonatomic,strong) UILabel * sizeLab;
@property(nonatomic,assign)CGRect tableVieFrame;
@property(nonatomic,strong)UILabel *soldoutLab;

@end

@implementation ShoppingCarTableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    _soldoutLab.hidden=YES;
    [_shoppingImgView sd_setImageWithURL:nil];
    [_changeView removeFromSuperview];
    _spuImgView.image = nil;
    _changeView = nil;
    _sizeLab.text = nil;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _tableView = tableView;
        [self initCellView];
    }
    return self;
}

- (void)initCellView
{
    
    
    UIImage *btimg = [UIImage imageNamed:@"ic_cb_normal"];
    UIImage *selectImg = [UIImage imageNamed:@"ic_cb_checked"];
    
    _selectBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btimg.size.width+CGFloatMakeX(20), CGFloatMakeY(CELL_HEIGHT))];
    [_selectBt addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_selectBt setImage:btimg forState:UIControlStateNormal];
    [_selectBt setImage:selectImg forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBt];
    
    
    
    _shoppingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_selectBt.frame)+CGFloatMakeX(7),CGFloatMakeY(12),CGFloatMakeX(70),CGFloatMakeY(70))];
    [self.contentView addSubview:_shoppingImgView];
    
    _spuImgView = [[UIImageView alloc] initWithFrame:CGRectMake1(0, 0, 10, 10)];
    [_shoppingImgView addSubview:_spuImgView];
    
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shoppingImgView.frame)+CGFloatMakeX(10),CGFloatMakeY(10), kWidth-CGRectGetMaxX(_shoppingImgView.frame)-CGFloatMakeX(15),CGFloatMakeY(21))];
    _title.font=[UIFont systemFontOfSize:CGFloatMakeY(15)];
    _title.textColor=[UIColor colorFromHexRGB:@"666666"];
    
    [self.contentView addSubview:_title];
    
    
    _sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_title.frame),CGFloatMakeX(200),CGFloatMakeY(17))];
    _sizeLab.font=[UIFont systemFontOfSize:CGFloatMakeY(12)];
    _sizeLab.textColor=[UIColor colorFromHexRGB:@"666666"];
    [self.contentView addSubview:_sizeLab];
    
    
    
    _soldoutLab = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_sizeLab.frame)+CGFloatMakeY(15),CGFloatMakeX(100), CGFloatMakeY(17))];
    _soldoutLab.hidden =YES;
    _soldoutLab.text=@"无货";
    _soldoutLab.font =  [UIFont systemFontOfSize:CGFloatMakeY(14)];
    _soldoutLab.textColor=[UIColor colorFromHexRGB:@"666666"];
    [self.contentView addSubview:_soldoutLab];
    
    
    _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-CGFloatMakeX(118),  CGRectGetMaxY(_sizeLab.frame)+CGFloatMakeY(10),CGFloatMakeX(100), CGFloatMakeY(17))];
    _priceLab.textAlignment=NSTextAlignmentRight;
    _priceLab.textColor=[UIColor colorFromHexRGB:@"666666"];
    _priceLab.font=[UIFont systemFontOfSize:CGFloatMakeY(14)];
    [self.contentView addSubview:_priceLab];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _changeView.numberFD = textField;
    if ([self isPureInt:_changeView.numberFD.text]) {
        if ([_changeView.numberFD.text integerValue]<0) {
            _changeView.numberFD.text=@"1";
        }
        
    }
    else
    {
        _changeView.numberFD.text=@"1";
    }
    
    
    if ([_changeView.numberFD.text isEqualToString:@""] || [_changeView.numberFD.text isEqualToString:@"0"]) {
        self.choosedCount = 1;
        _changeView.numberFD.text=@"1";
        
    }
    NSString *numText = _changeView.numberFD.text;
    if ([numText intValue]>[self totalCountWith:_model]) {
        _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",(int)[self totalCountWith:_model]];
        
        
    }
    
    if ([numText intValue] >99) {
        //  [SVProgressHUD showErrorWithStatus:@"最多支持购买99个"];
        _changeView.numberFD.text = @"99";
    }
    
    _changeView.addButton.enabled=YES;
    _changeView.subButton.enabled=YES;
    self.choosedCount = [_changeView.numberFD.text integerValue];
    _model.model.total = _changeView.numberFD.text;
    [self changCountWithCount:_model.model.total];
    _model.isSelect = _selectBt.selected;
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


-(void)setModel:(ShoppingCarModel*)model
{
    _model = model;
    _selectBt.selected=model.isSelect;
    
    if (_changeView.numberFD.text) {
        self.choosedCount = [_changeView.numberFD.text integerValue];
    }
    else{
        self.choosedCount =[model.model.total integerValue] ;
    }
    
    _shoppingImgView.layer.cornerRadius = 2;
    _shoppingImgView.layer.borderWidth = 1;
    _shoppingImgView.layer.borderColor = [UIColor colorFromHexRGB:@"e2e2e2"].CGColor;
    [_shoppingImgView sd_setImageWithURL:[NSURL URLWithString:model.model.thumb] placeholderImage:[UIImage imageNamed:@"default"]];
    _shoppingImgView.contentMode = UIViewContentModeScaleAspectFit;
    _title.text= model.model.title;
    _priceLab.text =[NSString stringWithFormat:@"￥%@", model.model.marketprice];
    
    if ([model.model.stock isEqualToString:@"0"]) {
        _soldoutLab.hidden=NO;
        _selectBt.enabled=NO;
        
        if (self.isEdit) {
            //编辑状态
            _selectBt.enabled=YES;
        }
    }
    else{
        _selectBt.enabled=YES;
        
        _changeView = [[ChangeCountView alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_sizeLab.frame)+CGFloatMakeY(5), CGFloatMakeX(100), CGFloatMakeY(30))  chooseCount:self.choosedCount totalCount: [self totalCountWith:model]];
        
        [_changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _changeView.numberFD.delegate = self;
        
        [_changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_changeView];
    }
    
}

-(NSInteger)totalCountWith:(ShoppingCarModel*)model
{
    NSInteger totalCount ;
    if ([model.model.stock isEqualToString:@"-1"]) {
        totalCount = 99;
    } else if ([model.model.stock isEqualToString:@"0"])
    {
        totalCount = 0;
    }
    else
    {
        totalCount = [model.model.stock integerValue];
    }
    return totalCount;
}

//加
- (void)addButtonPressed:(id)sender
{
    
    if (self.choosedCount<99) {
        [self addCar];
    }
    
    ++self.choosedCount ;
    if (self.choosedCount>0) {
        _changeView.subButton.enabled=YES;
    }
    
    
    if ([self totalCountWith:_model]<self.choosedCount) {
        self.choosedCount  = [self totalCountWith:_model];
        _changeView.addButton.enabled = NO;
    }
    else
    {
        _changeView.subButton.enabled = YES;
    }
    
    if(self.choosedCount>=99)
    {
        self.choosedCount  = 99;
        _changeView.addButton.enabled = NO;
    }
    

    
}


-(void)addCar
{
    [self changCountWithCount:[NSString stringWithFormat:@"%ld",_choosedCount+1]];
}


-(void)clickSelect:(UIButton *)bt
{
    
    //  _selectBt.selected = !_selectBt.selected;
    if (!_soldoutLab.hidden && !self.isEdit) {
        return;
    }
    _selectBt.selected = !_selectBt.selected;
    _model.isSelect = _selectBt.selected;
    
    if (_changeView.numberFD.text!=nil) {
        _model.model.total = _changeView.numberFD.text;
    }
    
    [self.delegate singleClick:_model row:self.row];
}

//减
- (void)subButtonPressed:(id)sender
{
    
    if (self.choosedCount >1) {
        [self deleteCar];
    }
    
    -- self.choosedCount ;
    
    if (self.choosedCount==0) {
        self.choosedCount= 1;
        _changeView.subButton.enabled=NO;
    }
    else
    {
        _changeView.addButton.enabled=YES;
        
    }
    
    
}


-(void)deleteCar
{
    [self changCountWithCount:@"-1"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


+(CGFloat)getHeight
{
    return CELL_HEIGHT;
}


-(void)changCountWithCount:(NSString*)count
{
   NSDictionary *dic = @{@"appkey":APPkey,@"mid":[self returnMid],@"amount":count,@"id":_model.model.listId};
#pragma dic MD5
    NSDictionary * Ndic = [self md5DicWith:dic];
    
    AFHTTPSessionManager *manager = [self sharedManager];;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    
    [manager POST:kSgoodsCount parameters:Ndic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        
        _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
        
        _model.model.total = _changeView.numberFD.text;
        
        _model.isSelect=_selectBt.selected;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
