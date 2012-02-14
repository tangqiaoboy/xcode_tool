//
//  NSStringWrapperTests.m
//  NSStringWrapperTests
//
//  Created by Tang Qiao on 12-2-4.
//  Copyright (c) 2012年 blog.devtang.com. All rights reserved.
//

#import "NSStringWrapperTests.h"
#import "NSStringWrapper.h"

@implementation NSStringWrapperTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCompareTo {
    STAssertTrue([@"abc" compareTo:@"abc"] == 0, @"They should be equal.");
    STAssertTrue([@"aaa" compareTo:@"abc"] == -1, @"They should be -1.");
    STAssertTrue([@"ac" compareTo:@"abc"] == 1, @"They should be 1.");
}

- (void)testCompareToIgnoreCase {
    STAssertTrue([@"abc" compareToIgnoreCase:@"aBc"] == 0, @"They should be equal.");
    STAssertTrue([@"aaa" compareToIgnoreCase:@"ABC"] == -1, @"They should be -1.");
    STAssertTrue([@"AC" compareToIgnoreCase:@"abc"] == 1, @"They should be 1.");
}

- (void)testContains {
    STAssertTrue([@"abcdef" contains:@"a"], @"It should contain.");
    STAssertTrue([@"abcdef" contains:@"f"], @"It should contain.");
    STAssertTrue([@"abcdef" contains:@"ef"], @"It should contain.");
    STAssertTrue([@"abc" contains:@"abc"], @"It should contain.");
    STAssertFalse([@"" contains:@"a"], @"It should not contain");
    STAssertFalse([@"ddd" contains:@"a"], @"It should not contain");
    STAssertFalse([@"aa" contains:@"aab"], @"It should not contain");
}


- (void)testStartsWith {
    STAssertTrue([@"abcdef" startsWith:@"abc"], @"");
    STAssertTrue([@"aa" startsWith:@"aa"], @"");
    STAssertTrue([@"aa" startsWith:@""], @"");
    STAssertFalse([@"abc" startsWith:@"b"], @"");
    STAssertFalse([@"abc" startsWith:@"abcd"], @"");
}

- (void)testEndsWith {
    STAssertTrue([@"abcdef" endsWith:@"def"], @"");
    STAssertTrue([@"aa" endsWith:@"aa"], @"");
    STAssertTrue([@"aa" endsWith:@""], @"");
    STAssertFalse([@"abc" endsWith:@"b"], @"");
    STAssertFalse([@"abc" endsWith:@"dabc"], @"");
}

- (void)testEquals {
    STAssertTrue([@"abc" equals:@"abc"], @"They should be equal.");
    STAssertTrue([@"" equals:@""], @"They should be equal.");
    STAssertFalse([@"aaa" equals:@"abc"], @"They should not be equal.");
    STAssertFalse([@"ac" equals:@"abc"], @"They should not be equal.");
    STAssertFalse([@"" equals:@"abc"], @"They should not be equal.");
    STAssertFalse([@"a" equals:@""], @"They should not be equal.");
    STAssertFalse([@"abcd" equals:@"abc"], @"They should not be equal.");
    STAssertFalse([@"abC" equals:@"abc"], @"They should not be equal.");
}

- (void)testEqualsIgnoreCase {
    STAssertTrue([@"abc" equalsIgnoreCase:@"abC"], @"They should be equal.");
    STAssertTrue([@"" equalsIgnoreCase:@""], @"They should be equal.");
    STAssertFalse([@"aaa" equalsIgnoreCase:@"abc"], @"They should not be equal.");
    STAssertFalse([@"ac" equalsIgnoreCase:@"abc"], @"They should not be equal.");
    STAssertFalse([@"" equalsIgnoreCase:@"abc"], @"They should not be equal.");
    STAssertFalse([@"a" equalsIgnoreCase:@""], @"They should not be equal.");
    STAssertFalse([@"abcd" equalsIgnoreCase:@"abc"], @"They should not be equal.");
    STAssertTrue([@"abC" equalsIgnoreCase:@"abc"], @"They should be equal.");
}

- (void)testIndexOfChar {
    STAssertEquals(-1, [@"abc" indexOfChar:'d'], @"");
    STAssertEquals(1, [@"abc" indexOfChar:'b'], @"");
}

- (void)testIndexOfCharFromIndex {
    STAssertEquals(-1, [@"abc" indexOfChar:'d' fromIndex:0], @"");
    STAssertEquals(1, [@"abc" indexOfChar:'b' fromIndex:1], @"");
    STAssertEquals(3, [@"abcbb" indexOfChar:'b' fromIndex:2], @"");
}

- (void)testIndexOfString {
    STAssertEquals(-1, [@"abc" indexOfString:@"dd"], @"");
    STAssertEquals(1, [@"abc" indexOfString:@"bc"], @"");
    STAssertEquals(1, [@"abc" indexOfString:@"b"], @"");
    STAssertEquals(1, [@"abcbbb" indexOfString:@"b"], @"");
    STAssertEquals(-1, [@"" indexOfString:@"b"], @"");
}

- (void)testIndexOfStringFromIndex {
    STAssertEquals(-1, [@"abc" indexOfString:@"dd" fromIndex:0], @"");
    STAssertEquals(1, [@"abc" indexOfString:@"bc" fromIndex:1], @"");
    STAssertEquals(-1, [@"abc" indexOfString:@"bc" fromIndex:2], @"");
    STAssertEquals(3, [@"abcb" indexOfString:@"b" fromIndex:2], @"");
    STAssertEquals(4, [@"abcbbb" indexOfString:@"b" fromIndex:4], @"");
    STAssertEquals(-1, [@"" indexOfString:@"b"], @"");
}

- (void)testLastIndexOfChar {
    STAssertEquals(-1, [@"abc" lastIndexOfChar:'d'], @"");
    STAssertEquals(3, [@"abcb" lastIndexOfChar:'b'], @"");
}

- (void)testLastIndexOfCharFromIndex {
    STAssertEquals(-1, [@"abc" lastIndexOfChar:'d' fromIndex:2], @"");
    STAssertEquals(1, [@"abc" lastIndexOfChar:'b' fromIndex:1], @"");
    STAssertEquals(4, [@"abcbb" lastIndexOfChar:'b' fromIndex:4], @"");
}

- (void)testLastIndexOfString {
    STAssertEquals(-1, [@"abc" lastIndexOfString:@"dd"], @"");
    STAssertEquals(1, [@"abc" lastIndexOfString:@"bc"], @"");
    STAssertEquals(1, [@"abc" lastIndexOfString:@"b"], @"");
    STAssertEquals(5, [@"abcbbb" lastIndexOfString:@"b"], @"");
    STAssertEquals(-1, [@"" lastIndexOfString:@"b"], @"");
}

- (void)testLastIndexOfStringFromIndex {
    STAssertEquals(-1, [@"abc" lastIndexOfString:@"dd" fromIndex:3], @"");
    STAssertEquals(1, [@"abc" lastIndexOfString:@"bc" fromIndex:3], @"");
    STAssertEquals(-1, [@"abc" lastIndexOfString:@"bc" fromIndex:2], @"");
    STAssertEquals(3, [@"abcb" lastIndexOfString:@"b" fromIndex:4], @"");
    STAssertEquals(4, [@"abcbbb" lastIndexOfString:@"b" fromIndex:5], @"");
    STAssertEquals(-1, [@"" lastIndexOfString:@"b"], @"");
}

- (void)testSubstring {
    STAssertEqualObjects(@"aa", [@"aaaa" substringFromIndex:1 toIndex:3], @"");
    STAssertEqualObjects(@"ab", [@"aaba" substringFromIndex:1 toIndex:3], @"");
}

- (void)testToLowerCase {
    STAssertEqualObjects(@"aaaa", [@"aAaa" toLowerCase], @"");
    STAssertEqualObjects(@"ab", [@"AB" toLowerCase], @"");
}

- (void)testToUpperCase {
    STAssertEqualObjects(@"AAAA", [@"aAaa" toUpperCase], @"");
    STAssertEqualObjects(@"AB", [@"aB" toUpperCase], @"");
}

- (void)testTrim {
    STAssertEqualObjects(@"AAAA", [@" AAAA  " trim], @"");
}

- (void)testReplaceAll {
    STAssertEqualObjects(@"hello  ", [@"hello abc abc" replaceAll:@"abc" with:@""], @"");
}

@end









