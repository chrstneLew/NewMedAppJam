//
//  SymptomViewController.m
//  TopSecretProjectForTeam11
//
//  Created by Max on 11/17/13.
//  Copyright (c) 2013 App Jam. All rights reserved.
//

#import "SymptomViewController.h"

@interface SymptomViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *ContentView;
@property (weak, nonatomic) IBOutlet UITextField *SymptomText;
@property (weak, nonatomic) IBOutlet UISlider *PainSlider;
@property (weak, nonatomic) IBOutlet UILabel *PainNumber;
@property (strong, nonatomic) IBOutlet UITextView *notesView;
@property (weak, nonatomic) IBOutlet UITableView *occurrencesTable;
@property (weak, nonatomic) IBOutlet UITableView *treatmentsTable;
@property SummaryOccurrencesDelegate *occurrencesDelegate;
@property SummaryTreatmentDelegate *treatmentDelegate;

@end

@implementation SymptomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _SymptomText.text = _symptom.symptom;
    [self.SymptomText setUserInteractionEnabled:NO];
    _PainSlider.value = _symptom.pain;
    _PainNumber.text = [NSString stringWithFormat:@"%d", (int)roundf(_PainSlider.value)];
    _notesView.text = _symptom.notes;
    
    self.treatmentDelegate = [[SummaryTreatmentDelegate alloc] initWithController:self AndWithArray:self.symptom.treatments];
    self.occurrencesDelegate = [[SummaryOccurrencesDelegate alloc] initWithController:self AndWithArray:self.symptom.occurrences];
    
    self.occurrencesTable.delegate = self.occurrencesDelegate;
    self.occurrencesTable.dataSource = self.occurrencesDelegate;
    self.treatmentsTable.delegate = self.treatmentDelegate;
    self.treatmentsTable.dataSource = self.treatmentDelegate;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.storeSymptomKey = _symptom.symptom;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.ContentView.bounds.size;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    TreatmentDetailsViewController *ctrlr = (TreatmentDetailsViewController*) segue.destinationViewController;
    TreatmentObject *obj = [self.symptom.treatments objectAtIndex:self.selectedRow];
    ctrlr.treatment = obj;
    
    /*
     //code for editing mode to edit occurances and treatments
     if ([[segue identifier] isEqualToString:@"AddOccurrenceSegue"]) {
     AddOccurrencesController *ctrlr = [segue destinationViewController];
     ctrlr.occurrences = self.symptom.occurrences;
     }
     else
     if ([[segue identifier] isEqualToString:@"AddTreatmentSegue"]) {
     AddTreatmentController *ctrlr = [segue destinationViewController];
     ctrlr.treatments = self.symptom.treatments;
     }
     */
    
}

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];
    if (flag == YES){
        // Change views to edit mode.
        NSLog(@"edit mode");
        [self.SymptomText setUserInteractionEnabled:YES];
        _notesView.editable = YES;
        _PainSlider.enabled = YES;
    }
    else {
        SymptomDictionary *symdic = [SymptomDictionary symptomDictionary];
        //find actual symptom in dictionary with string
        _symptomToRemove = [symdic findSymptom:_storeSymptomKey];
        //remove from dictionary
        [symdic editSymptomREMOVE:_symptomToRemove];
        
        _symptom.symptom = self.SymptomText.text;
        _symptom.pain = roundf(self.PainSlider.value);
        
        _symptom.notes = self.notesView.text;
        
        [symdic editSymptomADD:(_symptom)];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        // Save the changes if needed and change the views to noneditable.
        NSLog(@"NOT in edit mode");
        [self.SymptomText setUserInteractionEnabled:NO];
        _notesView.editable = NO;
        _PainSlider.enabled = NO;
    }
}


- (IBAction)painSlider:(UISlider *)sender
{
    self.PainNumber.text = [[NSString alloc] initWithFormat:@"%d", (int)sender.value];
}

@end
