//
//  Classroom.m
//  PdfReportKit
//
//  Created by Shreenidhi Bhat on 3/16/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import "Classroom.h"

@implementation Classroom

- (void)encodeWithCoder:(NSCoder *)encoder;
{
    [encoder encodeObject:[self roomNo] forKey:@"roomNo"];
    [encoder encodeObject:[self building] forKey:@"building"];
    
    [encoder encodeObject:[self remarks] forKey:@"remarks"];
    [encoder encodeObject:[self endTime] forKey:@"endTime"];
    
    [encoder encodeObject:[self sc_count] forKey:@"sc_count"];
    [encoder encodeObject:[self st_count] forKey:@"st_count"];
    
    [encoder encodeObject:[self ic_count] forKey:@"ic_count"];
    [encoder encodeObject:[self it_count] forKey:@"it_count"];
    
    [encoder encodeBool:[self isSC] forKey:@"isSC"];
    [encoder encodeBool:[self isST] forKey:@"isSt"];
    
    [encoder encodeBool:[self isIT] forKey:@"isIT"];
    [encoder encodeBool:[self isIC] forKey:@"isIC"];
    
    [encoder encodeObject:[self isIcCorrect] forKey:@"isIcCorrect"];
    [encoder encodeObject:[self isItCorrect] forKey:@"isItCorrect"];
    
    [encoder encodeObject:[self isScCorrect] forKey:@"isScCorrect"];
    [encoder encodeObject:[self isStCorrect] forKey:@"isStCorrect"];
}

- (id)initWithCoder:(NSCoder *)decoder;
{
    if ( ![super init] )
    	return nil;
    
    [self setRoomNo:[decoder decodeObjectForKey:@"roomNo"]];
    [self setBuilding:[decoder decodeObjectForKey:@"building"]];
    [self setRemarks:[decoder decodeObjectForKey:@"remarks"]];
    [self setEndTime:[decoder decodeObjectForKey:@"endTime"]];
    
    [self setSc_count:[decoder decodeObjectForKey:@"sc_count"]];
    [self setSt_count:[decoder decodeObjectForKey:@"st_count"]];
    [self setIc_count:[decoder decodeObjectForKey:@"ic_count"]];
    [self setIt_count:[decoder decodeObjectForKey:@"it_count"]];
    
    [self setIsIC:[decoder decodeBoolForKey:@"isIC"]];
    [self setIsIT:[decoder decodeBoolForKey:@"isIT"]];
    [self setIsSC:[decoder decodeBoolForKey:@"isSC"]];
    [self setIsST:[decoder decodeBoolForKey:@"isST"]];
    
    [self setIsScCorrect:[decoder decodeObjectForKey:@"isScCorrect"]];
    [self setIsStCorrect:[decoder decodeObjectForKey:@"isStCorrect"]];
    [self setIsIcCorrect:[decoder decodeObjectForKey:@"isIcCorrect"]];
    [self setIsItCorrect:[decoder decodeObjectForKey:@"isItCorrect"]];
    
    
    return self;
}

@end
