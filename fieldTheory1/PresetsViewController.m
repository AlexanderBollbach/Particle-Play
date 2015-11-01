
#import "PresetsViewController.h"
#import "OrbManager.h"
#import "AppDelegate.h"
#import "UIColor+ColorAdditions.h"

@interface PresetsViewController ()

@property(nonatomic,strong)UIView* presetPanelView;
@property(nonatomic,strong)UIButton* savePresetButton;
@property(nonatomic,strong)UIButton* clearPresetButton;
@property(nonatomic,strong)UITableView* tableView;

@end

@implementation PresetsViewController


- (void)viewDidLoad {
     [super viewDidLoad];
     self.view.backgroundColor = [UIColor flatSTLightBlueColor];
}

- (void)setupViews {
     
     CGFloat viewPartition = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.view.frame)/3;
     
     self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    CGRectGetWidth(self.view.bounds),
                                                                    viewPartition)
                                                   style:UITableViewStylePlain];
     self.tableView.delegate = self;
     self.tableView.dataSource = self;
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.tableView.backgroundColor = [UIColor clearColor];
     [self.view addSubview:self.tableView];
     
     UIView *lowerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  viewPartition,
                                                                  CGRectGetWidth(self.view.bounds),
                                                                  CGRectGetHeight(self.view.bounds) - viewPartition)];
     lowerView.backgroundColor = [UIColor clearColor];
     
     self.savePresetButton = [UIButton buttonWithType:UIButtonTypeSystem];
     [self.savePresetButton setTitle:@"save" forState:UIControlStateNormal];
     self.savePresetButton.backgroundColor = [UIColor clearColor];
     self.savePresetButton.frame = CGRectMake(0, 0, 50, 50);
     [self.savePresetButton addTarget:self action:@selector(savePreset) forControlEvents:UIControlEventTouchUpInside];
     self.savePresetButton.center = CGPointMake(CGRectGetWidth(lowerView.bounds) - CGRectGetWidth(lowerView.bounds)/1.2, 35);
     [lowerView addSubview:self.savePresetButton];
     
     [self.view addSubview:lowerView];
     
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSUserDefaults* myDefaults = [NSUserDefaults standardUserDefaults];
     NSMutableDictionary* decodedDict = [NSKeyedUnarchiver unarchiveObjectWithData:[myDefaults objectForKey:ABUserDefaultsPresetsKey]];
     
     if (section == 0) {
          NSMutableDictionary *dict = [decodedDict objectForKey:ABUserDefaultsPresetsStockKey];
         return dict.allKeys.count;
     } else {
          NSMutableDictionary *dict = [decodedDict objectForKey:ABUserDefaultsPresetsCustomKey];
          return dict.allKeys.count;
     }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     NSMutableDictionary *decodedDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultsPresetsKey]];
     NSMutableDictionary *stockPresetsDict = [decodedDict objectForKey:ABUserDefaultsPresetsStockKey];
     NSMutableDictionary *customPresetsDict = [decodedDict objectForKey:ABUserDefaultsPresetsCustomKey];


     UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
     if (cell == nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
     }
     if (indexPath.section == 0) {
          cell.textLabel.text = [stockPresetsDict.allKeys objectAtIndex:indexPath.row];
     } else {
          cell.textLabel.text = [customPresetsDict.allKeys objectAtIndex:indexPath.row];
     }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.textLabel.textAlignment = NSTextAlignmentCenter;
     cell.backgroundColor = [UIColor clearColor];
     cell.textLabel.textColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:0.8];
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
     selectedCell.textLabel.textColor = [UIColor redColor];
   //  NSMutableDictionary *decodedDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultsPresetsKey]];
     if (indexPath.section == 0) {
     //     NSMutableDictionary *stockDict = [decodedDict objectForKey:ABUserDefaultsPresetsStockKey];
      //    NSMutableArray *presetArray = [stockDict objectForKey:selectedCell.textLabel.text];
       //   [[AppDelegate sharedDelegate] loadPreset:presetArray];
     } else {
      //    NSMutableDictionary *custom = [decodedDict objectForKey:ABUserDefaultsPresetsCustomKey];
      //    NSMutableArray *presetArray = [custom objectForKey:selectedCell.textLabel.text];
        //  [[AppDelegate sharedDelegate] loadPreset:presetArray];
     }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
     selectedCell.textLabel.textColor = [UIColor colorWithRed:1 green:0.9 blue:0.9 alpha:0.8];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     return 120;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
     UILabel* tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,300,244)];
     tempLabel.backgroundColor = [UIColor clearColor];
     tempLabel.textColor = [UIColor whiteColor];
     tempLabel.font = [UIFont boldSystemFontOfSize:25];
     tempLabel.textAlignment = NSTextAlignmentCenter;
     if (section == 0) {
          tempLabel.text= @"Stock";
     } else {
          tempLabel.text= @"Custom";
     }
     return tempLabel;
}

- (void)savePreset {
     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SAVE PRESET"
                                                                    message:@"NAME THIS PRESET"
                                                             preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                                if (alert.textFields[0].text.length > 0) {
                                                                     // get master Dictionary
                                                                     NSMutableDictionary *decoded = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultsPresetsKey]];
                                                                    // get custom Dictionary
                                                                     NSMutableDictionary *custom = [decoded objectForKey:ABUserDefaultsPresetsCustomKey];
                                                                   // get current Preset Array
                                                                     NSArray *thisPreset = [OrbManager sharedOrbManager].orbModels;
                                                                     // set preset array to custom Dictionary with text key
                                                                     [custom setObject:thisPreset forKey:alert.textFields[0].text];
                                                                     // encode the decoded dictionary
                                                                     NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:decoded];
                                                                     // reload userdefaults with updated dictionary
                                                                     [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:ABUserDefaultsPresetsKey];
                                                                     // reload UI
                                                                     [self.tableView reloadData];
                                                                
                                                                }
                                                           }];
     
     [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
          textField.placeholder = @"name";
     }];
     [alert addAction:defaultAction];
     [self presentViewController:alert animated:YES completion:nil];
}

- (void)Clear:(UIButton *)sender {
     NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
     NSMutableDictionary *presetDictionaryDecoded = [NSKeyedUnarchiver unarchiveObjectWithData:[myDefaults objectForKey:@"presetsDictionary"]];
     [presetDictionaryDecoded removeAllObjects];
     NSData *dataDict = [NSKeyedArchiver archivedDataWithRootObject:presetDictionaryDecoded];
     [myDefaults setObject:dataDict forKey:@"presetsDictionary"];
     [self.tableView reloadData];
}



@end
