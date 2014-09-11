//
//  WSAssetPickerState.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/24/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "WSAssetPickerState.h"

@interface WSAssetPickerState ()
@property (nonatomic, strong) NSMutableOrderedSet *selectedAssetsSet;
@end

@implementation WSAssetPickerState

@dynamic selectedAssets;
@synthesize selectedAssetsSet = _selectedAssetsSet;
@synthesize selectedCount = _selectedCount;
@synthesize state = _state;

- (id)init
{
    if ((self = [super init])) {
        self.state = WSAssetPickerStateInitializing;
    }
    return self;
}

- (id)initWithSelectedAssetsSet:(NSArray *)assetsSet
{
    if ((self = [super init])) {
        self.state = WSAssetPickerStateInitializing;
        self.selectedAssetsSet = [NSMutableOrderedSet orderedSetWithArray:assetsSet];
    }
    return self;
}

- (void)setState:(WSAssetPickingState)state
{
    _state = state;
    
    // Clear the selcted assets and count.
    if (WSAssetPickerStatePickingAlbum == _state) {
        [self.selectedAssetsSet removeAllObjects];
        self.selectedCount = 0;
    }
}

- (NSMutableOrderedSet *)selectedAssetsSet
{
    if (!_selectedAssetsSet) {
        _selectedAssetsSet = [NSMutableOrderedSet orderedSet];
    }
    return _selectedAssetsSet;
}

- (NSArray *)selectedAssets
{
    return [[self.selectedAssetsSet array] copy];
}

- (void)changeSelectionState:(BOOL)selected forAsset:(ALAsset *)asset
{
    if (selected) {
//        [self.selectedAssetsSet addObject:asset];
        [self.selectedAssetsSet insertObject:asset atIndex:0];

    } else {
        
        int index = [self.selectedAssetsSet indexOfObject:asset];
        if (index == NSNotFound) {
            for (int i=0; i<self.selectedAssetsSet.count; i++) {
                ALAsset *subAsset = self.selectedAssetsSet[i];
                if ([subAsset.defaultRepresentation.url isEqual: asset.defaultRepresentation.url]) {
                    index = i;
                    break;
                }
            }
            if (index != NSNotFound) {
                [self.selectedAssetsSet removeObjectAtIndex:index];
            }
            
        } else {
            [self.selectedAssetsSet removeObject:asset];
        }
    }
    
    // Update the observable count property.
    self.selectedCount = [self.selectedAssetsSet count];
}

@end
