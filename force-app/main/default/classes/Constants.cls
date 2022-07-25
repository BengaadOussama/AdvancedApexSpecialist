/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-25-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public class Constants {
    public static final Integer DEFAULT_ROWS = 5;
    public static final String SELECT_ONE = Label.Select_One;
    public static final String INVENTORY_LEVEL_LOW = Label.Inventory_Level_Low;
    public static final List<Schema.PicklistEntry>  PRODUCT_FAMILY = Product2.Family.getDescribe().getPicklistValues();
    public static final String DRAFT_ORDER_STATUS = 'Draft';
    public static final String ACTIVATED_ORDER_STATUS = 'Activated';
    public static final string INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    public static final string ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';
    public static final string STANDARD_PRICEBOOK_ID = '01s7Q00000ElqhKQAR';
}
