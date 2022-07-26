/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 26-07-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}
    public String selectedFamily {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        selectedFamily = Constants.SELECT_ONE;
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add( new ProductWrapper() );
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference Save(){

        Savepoint sp = Database.setSavepoint();
        try {
            insertRecords();
            
            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Constants.ERROR_MESSAGE));
        }
        return null;
    }

    public void insertRecords(){
        List<Product2> prods = new List<Product2> ();
        List<PriceBookEntry> prodEntries = new List<PriceBookEntry> ();

        for(integer i=0; i<productsToInsert.size(); i++){
            if(productsToInsert.get(i).productRecord.Name !=null && productsToInsert.get(i).productRecord.Name != '' && productsToInsert.get(i).productRecord.family != null && productsToInsert.get(i).productRecord.family != '' && productsToInsert.get(i).productRecord.Initial_Inventory__c>0){
                prods.Add(productsToInsert.get(i).productRecord);
                prodEntries.add(productsToInsert.get(i).pricebookEntryRecord);

            }
        }
        INSERT prods;

        for(integer i=0; i<prodEntries.size(); i++){
            prodEntries.get(i).Product2Id = prods.get(i).Id;
            prodEntries.get(i).Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
        }
        INSERT prodEntries;
    }


    public List<SelectOption> getFamilyOptions(){
        List<SelectOption> familyOptions = new List<SelectOption>();
        familyOptions.add(New SelectOption(Constants.SELECT_ONE,Constants.SELECT_ONE));

        for(Schema.PicklistEntry p : Constants.PRODUCT_FAMILY){
            familyOptions.add(New SelectOption(p.getLabel(),p.getValue()));
        }

        return familyOptions;
    }

    public class ProductWrapper{
        public Product2 productRecord {get;set;}
        public PriceBookEntry pricebookEntryRecord {get;set;}

        public ProductWrapper(){
            productRecord = new Product2();
            pricebookEntryRecord = new PriceBookEntry();
        }
    }
}