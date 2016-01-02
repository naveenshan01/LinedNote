//
//  TextNoteViewController.h
//  LinedNote
//
//  Created by Naveen Shan on 11/10/15.
//  Copyright © 2015 LinedNote All rights reserved.
//

#import "BaseViewController.h"

#import "TextNoteViewModel.h"
#import "TextNoteInputModel.h"

@interface TextNoteViewController : BaseViewController

@property (nonatomic, strong) TextNoteViewModel *viewModel;
@property (nonatomic, strong) TextNoteInputModel *inputModel;

@end
