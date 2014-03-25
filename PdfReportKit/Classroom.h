//
//  Classroom.h
//  PdfReportKit
//
//  Created by Shreenidhi Bhat on 3/16/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Classroom : NSObject

@property (nonatomic,retain) NSString * roomNo;
@property (nonatomic,assign) int SC;
@property (nonatomic,assign) int IC;
@property (nonatomic,assign) int IT;
@property (nonatomic,assign) int ST;
@property (nonatomic,assign) BOOL isSC;
@property (nonatomic,assign) BOOL isIC;
@property (nonatomic,assign) BOOL isIT;
@property (nonatomic,assign) BOOL isST;
@property (nonatomic,retain) NSString * endTime;
@property (nonatomic,retain) NSString * remarks;
@property (nonatomic,retain) NSString * building;

@end
