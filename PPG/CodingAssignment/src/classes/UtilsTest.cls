/**
 * Created by Mike Weiss on 4/28/2019.
 *
 * Test class for Utils
 */

@isTest
private with sharing class UtilsTest {

    static testMethod void testUtils() {
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        List<Object> testNullList;
        List<Object> testEmptyList = new List<Object>();
        List<Object> testList = new List<Object>();
        testList.add(testAccount);

        Map<Id, Object> testNullMap;
        Map<Id, Object> testEmptyMap = new Map<Id, Object>();
        Map<Id, Object> testMap = new Map<Id, Object>();
        testMap.put(testAccount.Id, testAccount);

        System.assert(Utils.isListNullOrEmpty(testNullList));
        System.assert(Utils.isListNullOrEmpty(testEmptyList));
        System.assert(!Utils.isListNullOrEmpty(testList));

        System.assert(Utils.isMapNullOrEmpty(testNullMap));
        System.assert(Utils.isMapNullOrEmpty(testEmptyMap));
        System.assert(!Utils.isMapNullOrEmpty(testMap));

    }
}