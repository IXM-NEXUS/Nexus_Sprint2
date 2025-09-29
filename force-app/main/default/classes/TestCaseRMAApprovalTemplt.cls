@isTest
public class TestCaseRMAApprovalTemplt {

    @isTest
    public static void testRMAApprovalMT(){
        
        Account a = new Account(name='test');
        insert a;
        
        Contact con = new Contact();
        con.lastname = 'test';
        con.AccountId = a.id;
        
        insert con;
        
        Case ca = new Case();
        ca.ContactId = con.id;
        ca.Subject = 'test';
        ca.labels__c = 'test';
        
        insert ca;
        
        RMA_Device_Detail__c rmaDevice = new RMA_Device_Detail__c();
        rmaDevice.Device_Serial_Number__c = '123';
        rmaDevice.Device_Type__c = 'FP22';
        rmaDevice.Device_Family__c = 'MYCRO';
        rmaDevice.Warranty_Status__c = 'Out of Warranty';
        rmaDevice.Hardware_Issue__c = 'Android Crash';
        rmaDevice.Case__c = ca.id;
        
        insert rmaDevice;
        Test.startTest();
            CaseRMAApprovalTemplt obj = new CaseRMAApprovalTemplt();
            obj.caseId = ca.id;
            obj.getrma();
            obj.getDeviceNumbers();
        
        SendRMAApprovalMessage.sendRMApprovalEmail(new List<Case>{ca});
        Test.stopTest();
        
    }
}