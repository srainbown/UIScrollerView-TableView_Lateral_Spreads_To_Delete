//
//  MyScrollView.m
//  UIScrollerView+TableView_Lateral_Spreads_To_Delete
//
//  Created by mac on 20/11/2018.
//  Copyright © 2018 Woodsoo. All rights reserved.
//

#import "MyScrollView.h"

@interface MyScrollView()<UIGestureRecognizerDelegate>

@end

@implementation MyScrollView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer.state != 0) {
        return YES;
    }else{
        return NO;
    }
}


@end
