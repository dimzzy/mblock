//
//  TouchInputView.h
//  MBlock
//
//  Created by Dmitry Stadnik on 1/4/13.
//  Copyright (c) 2013 Dmitry Stadnik. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const TouchesDidChangeNotification;

@interface TouchInfo : NSObject

@property(readonly) int32_t identifier;
@property(readonly) CGFloat x;
@property(readonly) CGFloat y;
@property(readonly) BOOL valid;

@end


@interface TouchInputView : UIView

@property UIColor *marksColor;
@property UIColor *touchesColor;

@property(readonly) NSArray *touchInfos;

@end
