//
//  Classroom.h
//  PdfReportKit
//
//  Created by Shreenidhi Bhat on 3/16/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Classroom : NSObject

@property (nonatomic,strong) NSString * roomNo;
@property (nonatomic,strong) NSString * sc_count;
@property (nonatomic,strong) NSString * ic_count;
@property (nonatomic,strong) NSString * it_count;
@property (nonatomic,strong) NSString * st_count;
@property (nonatomic) BOOL isSC;
@property (nonatomic) BOOL isIC;
@property (nonatomic) BOOL isIT;
@property (nonatomic) BOOL isST;
@property (nonatomic,strong) NSString * endTime;
@property (nonatomic,strong) NSString * remarks;
@property (nonatomic,strong) NSString * building;

@end
