//
//  OccurrencesObject.h
//  TopSecretProjectForTeam11
//
//  Created by App Jam on 11/17/13.
//  Copyright (c) 2013 App Jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OccurrencesObject : NSObject <NSCoding>

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

-(id) initWithStartDate:(NSDate *) startDate
            WithEndDate:(NSDate *) endDate;

- (NSDate *) startDate;
- (NSDate *) endDate;

@end
