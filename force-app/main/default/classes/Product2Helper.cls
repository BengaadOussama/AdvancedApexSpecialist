/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 26-07-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public without sharing class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> oldList,List<Product2> newList){
        
        //ToDo: Declare a List of Product2 records named needsAnnouncement
        List<Product2> needsAnnouncement = new List<Product2>();

        //ToDo: Declare a Map of Strings to Inventory_Setting__mdt records
        //ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
        Map<String,Inventory_Setting__mdt> invSettings =  inventory_Setting__mdt.getAll();
        
        //ToDo: Loop through the Products in newList
        // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
        // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert
        //      add it to the needsAnnouncement list
        
        for (Integer i=0; i<oldList.size() ; i++){
            if ( oldList.get(i).Quantity_Remaining__c != newList.get(i).Quantity_Remaining__c){
                for(Inventory_Setting__mdt inv: invSettings.values()){
                    if( newList.get(i).family == inv.DeveloperName && newList.get(i).Quantity_Remaining__c < inv.Low_Quantity_Alert__c){
                        needsAnnouncement.add(newList.get(i));
                        break;
                    }
                }
                
            }
        }

        //ToDo: Pass records to the postAlerts method
        PostAlerts(needsAnnouncement);
    }


    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            // expires in a day
            // does not notify users via email.
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
            ConnectApi.AnnouncementInput a = new ConnectApi.AnnouncementInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();

            a.expirationDate = System.Today()+1;
            a.sendEmails = false;
            a.parentId = COLLABORATION_GROUP.get(0).Id;
            textSegmentInput.text= p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;
            messageBodyInput.messageSegments = new List<ConnectApi.TextSegmentInput>();
            messageBodyInput.messageSegments.add(textSegmentInput);
            a.body = messageBodyInput;
            toPost.Add(a);
        }
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
        AnnouncementQueueable a = new AnnouncementQueueable();
        a.toPost = toPost;

        System.enqueueJob(a);
    }
}