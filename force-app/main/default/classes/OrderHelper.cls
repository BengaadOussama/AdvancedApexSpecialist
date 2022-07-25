/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-25-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
                orderIds.add(newList[i].Id);
            }
        }

        OrderHelper.RollUpOrderItems(orderIds);
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<Id,Product2> productMap = new Map<Id,Product2>();

        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds
        for(Order o : [SELECT Id, (SELECT id,Product2Id,Quantity,Product2.Quantity_Ordered__c FROM OrderItems) FROM Order WHERE Id IN :activatedOrderIds]){
            for(OrderItem oi : o.OrderItems){
                productMap.put(oi.Product2Id, oi.Product2);
            }
        }
        
        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset
        AggregateResult[] groupedResults = [SELECT Product2Id, SUM(Quantity) quantity FROM OrderItem WHERE Product2Id IN :productMap.keyset() GROUP BY Product2Id ];
        for(AggregateResult ar : groupedResults){
                Product2 p = productMap.get((ID)ar.get('Product2Id'));
                p.Quantity_Ordered__c += (Decimal)ar.get('quantity');
                productMap.put((ID)ar.get('Product2Id'), p);
        }
        
        //ToDo: Perform an update on the records in the productMap
        UPDATE productMap.values();
        
    }

}