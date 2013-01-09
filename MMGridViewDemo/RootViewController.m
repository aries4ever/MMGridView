//
// Copyright (c) 2010-2011 Ren� Sprotte, Provideal GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RootViewController.h"
#import "AnyViewController.h"
#import "MMGridViewDefaultCell.h"


@interface RootViewController()
{
    
}
@property (retain,nonatomic) NSMutableArray *dataSource;

- (void)reload;
- (void)setupPageControl;
@end

@implementation RootViewController

// ----------------------------------------------------------------------------------

#pragma - Object lifecycle

- (void)dealloc
{
    [gridView release];
    [pageControl release];
    [super dealloc];
}


- (void)viewDidUnload {
    [gridView release];
    gridView = nil;
    [pageControl release];
    pageControl = nil;
    [super viewDidUnload];
}


- (void)viewDidLoad
{
    self.dataSource = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i<20; i++) {
        [_dataSource addObject:@"Example"];
    }
    
    // Give us a nice title
    self.title = @"MMGridView Demo";
    
    // Create a reload button
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                  target:self 
                                                                                  action:@selector(reload)];
    self.navigationItem.rightBarButtonItem = reloadButton;
    [reloadButton release];
    
    // setup MMGrid view 
    
    gridView.cellMargin = 5;
    gridView.numberOfRows = 4;
    gridView.numberOfColumns = 3;
    // gridView.layoutStyle = HorizontalLayout;
    gridView.layoutStyle = VerticalLayout;
    
    // setup the page control 
    [self setupPageControl];    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || 
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)reload
{
    [gridView reloadData];
}


- (void)setupPageControl
{
    pageControl.numberOfPages = gridView.numberOfPages;
    pageControl.currentPage = gridView.currentPageIndex;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDataSource

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return [_dataSource count];
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewDefaultCell *cell = [[[MMGridViewDefaultCell alloc] initWithFrame:CGRectNull] autorelease];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", index];
    cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-image.png"]];
    return cell;
}

-(void)loadMoreForGrid
{
    //request more data here.
    for (int i = 0; i<10; i++) {
        [_dataSource addObject:@"Example"];
    }
    
    [self performSelector:@selector(LoadDataFinished) withObject:nil afterDelay:1.0];
}

-(void)LoadDataFinished
{
     [gridView reloadData];
    [gridView loadMoreFinished];   
}

  // ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    AnyViewController *c = [[AnyViewController alloc] initWithNibName:@"AnyViewController" bundle:nil];
    [self.navigationController pushViewController:c animated:YES];
    [c release];
}


- (void)gridView:(MMGridView *)gridView didDoubleTapCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"Cell at index %d was double tapped.", index]
                                                   delegate:nil 
                                          cancelButtonTitle:@"Cool!" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


- (void)gridView:(MMGridView *)theGridView changedPageToIndex:(NSUInteger)index
{
    [self setupPageControl];
}

-(BOOL)canLoadMoreForGrid
{
    //return hasMore.
    //here assume always YES.
    return YES;
}

@end
