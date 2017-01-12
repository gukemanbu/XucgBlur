//
//  ViewController.m
//  XucgBlur
//
//  Created by xucg on 2017/1/12.
//  Copyright © 2017年 xucg. All rights reserved.
//  Welcome visiting

#import "ViewController.h"
#import "UIImage+Blur.h"

const CGFloat gImageHeight = 350.f;

@interface ViewController ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = (id<UITableViewDelegate>)self;
    self.tableView.dataSource = (id<UITableViewDataSource>)self;
    self.tableView.contentInset = UIEdgeInsetsMake(gImageHeight, 0, 0, 0);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellReusedId"];
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -gImageHeight, [UIScreen mainScreen].bounds.size.width, gImageHeight)];
    _headerImageView.image = [[UIImage imageNamed:@"fbb.png"] blurWithValue:0.5];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.tag = 101;
    [self.tableView addSubview:_headerImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReusedId" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"I am row %ld", indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    if (point.y < -gImageHeight) {
        CGRect rect = _headerImageView.frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        _headerImageView.frame = rect;
    }
}

- (IBAction)sliderBarValueChanged:(UISlider*)sender {
    _headerImageView.image = [[UIImage imageNamed:@"fbb.png"] blurWithValue:sender.value];
}

@end
