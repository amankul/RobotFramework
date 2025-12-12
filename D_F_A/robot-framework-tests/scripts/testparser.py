'''
This script prints all robot test cases inside tests dir along with # of tests cases for each tag
'''

from robot.running import TestSuiteBuilder
from robot.model import SuiteVisitor
from collections import defaultdict

class TestCasesFinder(SuiteVisitor):
    def __init__(self):
        self.tests = dict()

    def visit_test(self, test):
        self.tests[test.name] = test.tags

builder = TestSuiteBuilder()
testsuite = builder.build('robot-framework-tests/tests')
finder = TestCasesFinder()
testsuite.visit(finder)

print("--------------------------------------TESTCASES------------------------------------------------")
print(*finder.tests, sep='\n')

# tests has test cases as key and tags as values. Create another dict since we want other way.
tags_dict = defaultdict(list)

uniq_tags = {item for sublist in finder.tests.values() for item in sublist}


for tag in uniq_tags:
    for k,v in finder.tests.items():
        tags_dict[tag].append(k) if tag in v else 0


print("--------------------------------------TAGS WITH COUNT-------------------------------------------")

list(map(lambda tag: print(tag, len(tags_dict.get(tag)), sep='\t'), tags_dict.keys()))
