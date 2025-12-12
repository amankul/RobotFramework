#!/usr/bin/python
# -*- coding: utf-8 -*-
# Filename: TestCase_RuleSync.py

import logging
import os
import datetime
import time
import argparse
import yaml
import requests
from requests.exceptions import HTTPError
from d.Utilities import Utilities
from d.Loggers import logging_setup

"""d Fund Advisors PROPRIETARY AND CONFIDENTIAL INFORMATION

The software and information contained herein is the proprietary and confidential property of DFA and shall not be
disclosed in whole or in part. Possession, use, reproduction or transfer of this software and information is prohibited
without the express written permission of DFA.

Copyright © 2019 d Fund Advisors  All rights reserved.

Revision Log:
  11/19/2019    Randy Schmidt    Initial revision.

"""
version = '1.0.0'


# noinspection PyPep8Naming
class TestCase_RuleSync:
    """Test case used to verify the API's in a Postman collections.

    Execution:
      To execute this test case standalone from command line, enter the following from directory where the script is
      located:

    Usage:
      Multiple parameters can be used on a command line

      All default settings:
        python TestCase_RuleSync.py

      Set test environment: -e or --env ... options are "DEV", "STG" or "PRD"
        python TestCase_RuleSync.py -e "DEV"

      Set parameters/YAML file to use: -p or --param ... defaults to TestCase_RuleSync.yaml
        python TestCase_RuleSync.py -p TestCase_ApiAutomatedTestSpecialEffects.yaml

      Set log file name: -o or --output ... defaults to TestCase_RuleSync.log
        python TestCase_RuleSync.py -o log.log

      Set database name: -d or --database ... defaults to TestCase_RuleSync.db
        python TestCase_RuleSync.py -d database.db

      Run only on selected tests/collections: -t or --test ... where 1 or more entries are permitted
        python TestCase_RuleSync.py -t "indices"
        python TestCase_RuleSync.py -t "indices" "indices-series" "slugs"

      Ignore the selected tables/queries: -i or --ignore ... where 1 or more entries are permitted
        python TestCase_RuleSync.py -i "indices"
        python TestCase_RuleSync.py --ignore "indices" "indices-series" "slugs"

      Run all the files in the meta directory except for the indices and indices-series directories
        python TestCase_RuleSync.py -t "meta" -i "indices" "indices-series"
        python TestCase_RuleSync.py --test "meta" --ignore "indices" "indices-series"

    Notes:
      None

    Attributes:
      logger (obj): the initialized logging object
      start_time (str): the start time of the test
      test_name (str): the name of the class used as test name
      args (dict): parsed command line arguments
      TEST_STATUS (dict): dict containing logger calls to be used based on status
      RESULTS (str): the directory, relative to application dir, where the test results are stored
      timestamp (str): data and time the test suite was executed, in format YYYYMMDD_HHMMSS

    Params:
      None

    """
    RULE_SYNCS = [RuleSyncFirms, RuleSyncClientAccounts, RuleSyncUsers, ReconcileContentPages, AddUpdateContentPage, ReconcileIndexesRequest, RuleEditUserCountry]

    def __init__(self):
        self.test_name = self.__class__.__name__
        self.RESULTS = "..\\..\\Results"
        self.timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")  # Leave out all special characters
        self.args = None

        # Command line arguments are ONLY defined for the main test case being run
        self.args = self.__parse_args()

        # Read dict for logger settings and command line arguments ONLY if being invoked from command line
        if __name__ == '__main__':
            # Initialize global variables from command line arguments
            self.environment = self.args['env']

            # ONLY the main application setups up the data logger.
            logging_setup(self.args)

        # Set the logger name for this test case
        self.logger = logging.getLogger(self.test_name)

        # Create lookup for logging command to use based on test status
        self.TEST_STATUS = {'PASS': self.logger.info, 'SKIP': self.logger.info, 'FAIL': self.logger.error}

        self.start_time = time.time()  # Get time for start of test.

    def __parse_args(self):
        """This private function is used to construct the argument parser and parse the command line arguments.

        Params:
          None

        Returns:
          None

        Raises:
          None

        Examples:
          args = self.__parse_args()

        """
        parser = argparse.ArgumentParser(
            prog=self.test_name, description='Command line arguments for ' + self.test_name)

        # if __name__ == "__main__":
        # Test parameters that are required for all test cases.
        parser.add_argument(
            "-e", "--env", required=False, choices=['DEV', 'STG', 'PRD'],
            default='DEV',
            help="The environment to run the tests against")
        parser.add_argument(
            "-d", "--database", required=False,
            default=self.test_name + '.db',
            help="The database to store the test results -  FEATURE NOT CURRENTLY IMPLEMENTED")
        parser.add_argument(
            "-o", "--output", required=False,
            default=self.test_name + '.log',
            help="The name of the log file")
        parser.add_argument(
            "-p", "--params", required=False,
            default=self.test_name + '.yaml', type=str,
            help="A file containing the test parameters for the script(s), in YAML format")

        # Test/script specific command line parameters
        parser.add_argument(
            "-t", "--test", required=False, nargs='*',
            default=None, help="The RULe sync(s) to test, a space delimited list of double quoted string of RULe syncs to process")
        parser.add_argument(
            "-i", "--ignore", required=False, nargs='*',
            default=None, help="The RULesync(s) to ignore, a space delimited list of double quoted strings")

        return vars(parser.parse_args())  # convert results to dict

    def __load_test_parameters(self):
        """This private function is used to load the test parameters.

        Note: If the format of the YAML file changes then this access function MUST also change!!

        Params:
          None

        Returns:
          test_parameters (dict): a dictionary containing the test parameters for this instance of the test case

        Raises:
          None

        Examples:
          test_parameters = self.__load_test_parameters()

        """
        # Open test parameters file
        test_parameters = {}

        try:
            with open("../" + self.args['params'], 'r') as f:
                test_parameters = yaml.safe_load(f)
        except yaml.YAMLError as ex:
            self.logger.exception("Error reading %s - %s", self.args['params'], ex)
        except OSError as e:
            self.logger.exception("File not found %s - %s", self.args['params'], e)

        return test_parameters

    def RuleSyncFirms(self):
        self.logger.info("Executing %s ...", self.test_name)

        tc_status = 'PASS'

        return tc_status

    def RuleSyncClientAccounts(self):
        tc_status = 'PASS'

        return tc_status

    def RuleSyncUsers(self):
        tc_status = 'PASS'

        return tc_status

    def ReconcileContentPages(self):
        tc_status = 'PASS'

        return tc_status

    def AddUpdateContentPage(self):
        tc_status = 'PASS'

        return tc_status

    def ReconcileIndexesRequest(self):
        tc_status = 'PASS'

        return tc_status

    def RuleEditUserCountry(self):
        tc_status = 'PASS'

        return tc_status

    def __cleanup(self):
        """This private function is used to reset the system to the default settings.

        Params:
          None

        Returns:
          None

        Raises:
          None

        Examples:
          self.__cleanup()

        """
        # Calculate and log the elapsed test time.
        self.logger.info("Elapsed Test Time: %s", Utilities.calculate_elapsed_time(self.start_time, time.time()))

    def __test_case(self):
        """This private function is used to perform the API testing.

        Params:
          None

        Returns:
          None

        Raises:
          None

        Examples:
          self.__test_case()

        """
        self.logger.info("Starting %s ...", self.test_name)

        # Initialize local variables
        tc_status = 'PASS'
        status = 'PASS'

        for job in self.RULE_SYNCS:
            status = job()

            tc_status = Utilities.update_test_status(status, tc_status)

        self.TEST_STATUS[tc_status]("Completed %s: %s", self.test_name, tc_status)

        return tc_status

    def execute_test_case(self):
        tc_result = self.__test_case()
        self.__cleanup()

        return tc_result


def main():
    # Execute test case
    test_case = TestCase_RuleSync()
    test_case.execute_test_case()

    return 0

if __name__ == "__main__":
    import sys

    sys.exit(main())
