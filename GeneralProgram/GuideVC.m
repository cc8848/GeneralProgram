//
//  GuideVC.m
//  GeneralProgram
//
//  Created by Mac 1 on 2018/12/6.
//  Copyright © 2018年 Mac 1. All rights reserved.
//

#import "GuideVC.h"
#import "PageControlView.H"
#import "ViewController.h"

@interface GuideVC ()

@property(strong , nonatomic)PageControlView *pageControlV;
@property(strong , nonatomic)NSArray *imageArr;

@end

@implementation GuideVC

- (NSArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }
    return _imageArr;
}

- (PageControlView *)pageControlV
{
     __weak typeof(self)weakSelf = self;
    
    if (!_pageControlV) {
        _pageControlV = [[PageControlView instance] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) andImageList:self.imageArr];
        [_pageControlV setGoviewtBlock:^{
            ViewController *view = [[ViewController alloc]init];
            [weakSelf presentViewController:view animated:NO completion:nil];
            
        }];
    }
    return _pageControlV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.pageControlV];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
