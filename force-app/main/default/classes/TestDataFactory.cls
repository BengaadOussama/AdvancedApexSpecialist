/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        return new CollaborationGroup(CollaborationType='Public',Name='TEST'+constants.INVENTORY_ANNOUNCEMENTS);

        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static list<Product2> ConstructProducts(Integer cnt){
        list<Product2> prods = new list<Product2>();

        for(integer i=0;i<cnt;i++){
            prods.add(new Product2(Name='Product'+i,IsActive=true,Initial_Inventory__c=10, family = Constants.PRODUCT_FAMILY.get(math.mod(i, Constants.PRODUCT_FAMILY.size())).getValue()));
        }
        return prods;
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){

        List<PricebookEntry> entries = new List<PricebookEntry>();
        for(integer i=0;i<prods.size();i++){
            entries.add(new PricebookEntry(product2Id = prods.get(i).Id, Pricebook2Id = constants.STANDARD_PRICEBOOK_ID, UnitPrice = 12, IsActive = true));
        }
        return entries;

        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static list<Account>  ConstructAccounts(Integer cnt){
        list<Account> accs = new list<Account>();

        for(integer i=0;i<cnt;i++){
            accs.add(new Account(Name='Account'+i));
        }
        return accs;
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        List<Contact> cs = new list<Contact>();

        for(integer i=0;i<cnt;i++){
                cs.add(new Contact(FirstName='Fname'+i,LastName='Lname'+i,AccountId=accts.get(math.mod(i, accts.size())).Id));
        }
            
        return cs;

        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        List<Order> cs = new list<Order>();

       for(integer i=0;i<cnt;i++){
                cs.add(new Order(status='Draft',EffectiveDate= System.today(),AccountId=accts.get(math.mod(i, accts.size())).Id,Pricebook2Id=Constants.STANDARD_PRICEBOOK_ID));
        }
            
        return cs;

        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        List<OrderItem> cs = new list<OrderItem>();

        for(integer i=0;i<cnt;i++){
            OrderItem oi = new OrderItem();
            oi.Quantity = Constants.DEFAULT_ROWS;
            oi.OrderId = ords.get(math.mod(i, ords.size())).Id;
            oi.PricebookEntryId = pbes.get(math.mod(i, pbes.size())).Id;
            oi.UnitPrice = 250;
            cs.add(oi);
        }
        
        return cs;
        
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        INSERT ConstructCollaborationGroup();
        list<Account> accs = ConstructAccounts(cnt);
        INSERT accs;

        INSERT ConstructContacts(cnt,accs);

        list<Product2> prods = ConstructProducts(cnt);
        INSERT prods;
        
        list<PriceBookEntry> ents =ConstructPricebookEntries(prods);
        INSERT ents;
        
        list<Order> ords = ConstructOrders(cnt, accs);
        INSERT ords;

        INSERT ConstructOrderItems(cnt, ents, ords);

        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.

    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        System.assertEquals(updatedProduct.Quantity_Ordered__c, originalProduct.Quantity_Ordered__c + qtyOrdered);
    }
}