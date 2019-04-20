/**
 * Created by Mike Weiss on 4/19/2019.
 *
 * Test class for PaymentDashboardController.
 */

@isTest
private with sharing class PaymentDashboardControllerTest {

    private static testMethod void testPaymentDashboardController() {
         // Create test data
        Contact testContact = new Contact();
        testContact.LastName = 'Williams';
        insert testContact;

        Project__c testProject = new Project__c();
        testProject.Name = 'Wings';
        insert testProject;

        Payment__c testPayment = new Payment__c();
        testPayment.Payment_Amount__c = 5;
        testPayment.Payment_Date__c = Date.today();
        testPayment.Contact__c = testContact.Id;
        testPayment.Project__c = testProject.Id;

        // Create second test payment to test else statement
        Payment__c testPayment2 = new Payment__c();
        testPayment2.Payment_Amount__c = 15;
        testPayment2.Payment_Date__c = Date.today();
        testPayment2.Contact__c = testContact.Id;
        testPayment2.Project__c = testProject.Id;

        // Test the methods

        PaymentDashboardController.insertPayment(testPayment);
        PaymentDashboardController.insertPayment(testPayment2);
        List<Payment__c> testPaymentList = PaymentDashboardController.getPaymentList();

        testPaymentList[0].Payment_Amount__c = 10;
        PaymentDashboardController.updatePayments(testPaymentList);

        PaymentDashboardController.getContactList();
        PaymentDashboardController.getPaymentList();
        PaymentDashboardController.getContactWrapperList();

        PaymentDashboardController.deletePayment(testPayment);

        PaymentDashboardController.getPaymentListForContact(testContact.Id);

        List<String> paymentIdList = new List<String>();
        paymentIdList.add(testPaymentList[0].Id);
        PaymentDashboardController.deletePaymentListById(paymentIdList);

    }
}