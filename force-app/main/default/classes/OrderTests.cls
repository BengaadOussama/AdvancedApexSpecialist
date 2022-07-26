/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 26-07-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
@isTest
private class OrderTests {

    @TestSetup
    static void SetupTestData(){
        TestDataFactory.InsertTestData(5);
    }
    
    @IsTest
    static void OrderUpdate_UnitTest(){
        
        Test.startTest();
        List<Product2> befores = [SELECT Id,Quantity_Ordered__c FROM Product2];

        List<Order> ords = [SELECT Id FROM Order];
        for(Order o : ords){
            o.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        UPDATE ords;
        
        List<Product2> afters = [SELECT Id,Quantity_Ordered__c FROM Product2];
        
        for(integer i =0; i<befores.size();i++){
            TestDataFactory.VerifyQuantityOrdered( befores.get(i), afters.get(i), Constants.DEFAULT_ROWS);
        }

        Test.stopTest();
        
    }
}