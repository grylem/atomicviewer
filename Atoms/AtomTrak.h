//
//  AtomTrak.h
//  MPEG4FileViewer
//
//  Created by Jay O'Conor on 3/14/14.
//  Copyright (c) 2014 Jay O'Conor. All rights reserved.
//

#import "AtomParent.h"

@interface AtomTrak : AtomParent

-(NSString *)languageFromCode:(NSString *)languageCode;

@end
