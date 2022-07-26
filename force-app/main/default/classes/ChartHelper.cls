/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 26-07-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public without sharing class ChartHelper {

    @AuraEnabled
    public static List<chartData> GetInventory(){
        List<chartData> cht = new List<chartData>();

        List<AggregateResult> ar = [SELECT Family, SUM(Quantity_Remaining__c) num FROM Product2 WHERE IsActive = true AND Quantity_Remaining__c>0 GROUP BY Family];

        for(AggregateResult a : ar){
            cht.add (new ChartData((String )a.get('Family'),(Decimal) a.get('num')));
        }
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }

}